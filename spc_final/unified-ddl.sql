-- ============================================================================
-- SPEC-IMPL-001B — DDL Unificado do Giuseppe Executive Assistant
-- Status: FROZEN V1 — mudanças apenas via Alembic migration + change log
-- Data: 02/04/2026
-- Engine: SQLite 3.45+ via aiosqlite / SQLAlchemy 2.0 async
-- Convenções: snake_case, UUID v4 como TEXT, timestamps ISO 8601 UTC
-- ============================================================================

-- =====================
-- PHASE 0 — Foundation
-- =====================

CREATE TABLE IF NOT EXISTS system_metadata (
    key TEXT PRIMARY KEY,
    value TEXT NOT NULL,
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);
-- Seed obrigatório: ('schema_version', '1'), ('app_name', 'Giuseppe Executive Assistant'), ('install_date', <now>)

CREATE TABLE IF NOT EXISTS migrations_applied (
    id TEXT PRIMARY KEY,              -- UUID v4
    version TEXT NOT NULL UNIQUE,     -- ex: '001_initial', '002_add_voice'
    applied_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    checksum TEXT,                    -- hash do arquivo de migration
    success INTEGER NOT NULL DEFAULT 1
);

CREATE TABLE IF NOT EXISTS audit_log (
    id TEXT PRIMARY KEY,
    event_type TEXT NOT NULL,         -- 'conversation.created', 'document.exported', etc.
    target_type TEXT NOT NULL,        -- 'conversation', 'message', 'workflow', etc.
    target_id TEXT NOT NULL,
    actor TEXT NOT NULL DEFAULT 'system',  -- 'user', 'system', 'agent:<name>'
    event_data TEXT,                  -- JSON com detalhes do evento
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);
CREATE INDEX idx_audit_log_target ON audit_log(target_type, target_id);
CREATE INDEX idx_audit_log_type ON audit_log(event_type, created_at);

CREATE TABLE IF NOT EXISTS llm_cache (
    cache_key TEXT PRIMARY KEY,       -- hash de (task_type + input_hash)
    task_type TEXT NOT NULL,          -- 'intent', 'routing', 'domain_analysis', etc.
    response_json TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    expires_at TEXT NOT NULL,
    hit_count INTEGER NOT NULL DEFAULT 0
);
CREATE INDEX idx_llm_cache_expires ON llm_cache(expires_at);

-- ===================================
-- PHASE 1 — Core Data and Navigation
-- ===================================

CREATE TABLE IF NOT EXISTS workspaces (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,               -- 'Planejamento', 'Captação', etc.
    type TEXT NOT NULL CHECK(type IN ('planejamento','captacao','normas_regulacao','documentos')),
    display_order INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);

CREATE TABLE IF NOT EXISTS conversations (
    id TEXT PRIMARY KEY,
    workspace_id TEXT NOT NULL,
    title TEXT NOT NULL CHECK(length(title) >= 3),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','paused','archived','draft')),
    origin_mode TEXT NOT NULL DEFAULT 'manual' CHECK(origin_mode IN ('manual','voice')),
    objective_summary TEXT,
    course_ref TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE RESTRICT
);
CREATE INDEX idx_conversations_workspace ON conversations(workspace_id, updated_at DESC);
CREATE INDEX idx_conversations_status ON conversations(status);

CREATE TABLE IF NOT EXISTS conversation_tags (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    tag_value TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);
CREATE INDEX idx_conv_tags_conv ON conversation_tags(conversation_id);

CREATE TABLE IF NOT EXISTS messages (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    role TEXT NOT NULL CHECK(role IN ('user','assistant','system','reviewer')),
    message_type TEXT NOT NULL DEFAULT 'standard' CHECK(message_type IN ('standard','ack','progress','checkpoint','review_request','partial_output')),
    raw_text TEXT,
    normalized_text TEXT,
    workflow_id TEXT,                  -- NULL se mensagem normal, preenchido se incremental
    executive_summary TEXT,           -- para mensagens incrementais
    next_step_hint TEXT,              -- para mensagens incrementais
    requires_user_action INTEGER NOT NULL DEFAULT 0,
    message_order INTEGER NOT NULL,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE SET NULL
);
CREATE INDEX idx_messages_conv ON messages(conversation_id, message_order);

CREATE TABLE IF NOT EXISTS attachments (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    file_name TEXT NOT NULL,
    mime_type TEXT NOT NULL,
    file_path TEXT NOT NULL,
    size_bytes INTEGER,
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','deleted')),
    uploaded_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);
CREATE INDEX idx_attachments_conv ON attachments(conversation_id);

-- FTS5 para busca textual em conversas e mensagens
CREATE VIRTUAL TABLE IF NOT EXISTS conversations_fts USING fts5(
    title,
    objective_summary,
    content='conversations',
    content_rowid='rowid'
);

CREATE VIRTUAL TABLE IF NOT EXISTS messages_fts USING fts5(
    raw_text,
    content='messages',
    content_rowid='rowid'
);

-- ============================
-- PHASE 2 — Voice Interaction
-- ============================

CREATE TABLE IF NOT EXISTS voice_events (
    id TEXT PRIMARY KEY,
    conversation_id TEXT,
    audio_path TEXT NOT NULL,
    audio_format TEXT NOT NULL DEFAULT 'wav_16khz_mono',
    duration_seconds REAL,
    captured_at TEXT NOT NULL,
    processed_at TEXT,
    status TEXT NOT NULL CHECK(status IN ('captured','transcribing','transcribed','interpreted','failed')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE SET NULL
);
CREATE INDEX idx_voice_events_conv ON voice_events(conversation_id);

CREATE TABLE IF NOT EXISTS voice_transcripts (
    id TEXT PRIMARY KEY,
    voice_event_id TEXT NOT NULL,
    raw_transcript TEXT,
    normalized_transcript TEXT,
    transcript_quality_score REAL CHECK(transcript_quality_score BETWEEN 0.0 AND 1.0),
    language_detected TEXT DEFAULT 'pt',
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (voice_event_id) REFERENCES voice_events(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS intent_events (
    id TEXT PRIMARY KEY,
    conversation_id TEXT,
    voice_event_id TEXT,
    primary_intent TEXT NOT NULL,     -- 'start_planning', 'continue_work', etc.
    secondary_intent TEXT,
    workspace_candidate TEXT,
    conversation_action TEXT NOT NULL, -- 'create_new', 'resume_existing', etc.
    entities_json TEXT,               -- JSON: {"curso":"Gastronomia","concorrente":"UniAlfa"}
    confidence_score REAL NOT NULL CHECK(confidence_score BETWEEN 0.0 AND 1.0),
    requires_confirmation INTEGER NOT NULL DEFAULT 0,
    suggested_title TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE SET NULL,
    FOREIGN KEY (voice_event_id) REFERENCES voice_events(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS voice_execution_envelopes (
    id TEXT PRIMARY KEY,
    voice_event_id TEXT NOT NULL,
    conversation_id TEXT NOT NULL,
    workspace_final TEXT NOT NULL,
    primary_intent TEXT NOT NULL,
    secondary_intent TEXT,
    conversation_action TEXT NOT NULL,
    confidence_score REAL NOT NULL,
    requires_confirmation INTEGER NOT NULL DEFAULT 0,
    confirmation_state TEXT CHECK(confirmation_state IN ('pending','confirmed','rejected','not_needed')),
    ledger_ref TEXT,
    resume_bundle_ref TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (voice_event_id) REFERENCES voice_events(id) ON DELETE CASCADE,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS orchestrator_decisions (
    id TEXT PRIMARY KEY,
    envelope_id TEXT NOT NULL,
    decision_type TEXT NOT NULL CHECK(decision_type IN ('local_reply','internal_retrieval','external_intelligence','workflow_creation','workflow_continuation','document_request','sensitive_review')),
    workflow_id TEXT,
    routed_to_executive_agent INTEGER NOT NULL DEFAULT 0,
    response_mode TEXT NOT NULL CHECK(response_mode IN ('immediate','short_prep','workflow_with_initial_response')),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (envelope_id) REFERENCES voice_execution_envelopes(id) ON DELETE CASCADE,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE SET NULL
);

-- =====================================
-- PHASE 3 — Context Persistence Engine
-- =====================================

CREATE TABLE IF NOT EXISTS session_ledgers (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    workflow_id TEXT,
    workspace TEXT NOT NULL,
    phase TEXT,                        -- 'exploring', 'executing', 'verifying', 'writing'
    goal TEXT,
    accepted_facts_json TEXT,          -- JSON array
    evidence_refs_json TEXT,           -- JSON array de IDs
    decisions_json TEXT,               -- JSON array
    attempted_approaches_json TEXT,
    failed_approaches_json TEXT,
    blockers_json TEXT,
    open_questions_json TEXT,
    next_step TEXT,
    verification_state TEXT CHECK(verification_state IN ('not_started','in_progress','green','yellow','red')),
    last_compaction_ref TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE SET NULL
);
CREATE INDEX idx_ledgers_conv ON session_ledgers(conversation_id);

CREATE TABLE IF NOT EXISTS compaction_events (
    id TEXT PRIMARY KEY,
    session_ledger_id TEXT NOT NULL,
    compact_summary_json TEXT NOT NULL, -- JSON com: goal, accepted_facts, decisions, blockers, next_step
    trigger_reason TEXT NOT NULL,       -- 'checkpoint', 'handoff', 'session_end', 'manual'
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (session_ledger_id) REFERENCES session_ledgers(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS context_packs (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    workflow_id TEXT,
    pack_type TEXT NOT NULL CHECK(pack_type IN ('execution','resume','handoff')),
    content_json TEXT NOT NULL,         -- JSON com todo o contexto montado
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS agent_learnings (
    id TEXT PRIMARY KEY,
    domain TEXT NOT NULL,              -- 'concorrencia', 'regulacao', etc.
    learning_type TEXT NOT NULL,       -- 'heuristic', 'failure_pattern', 'success_pattern'
    description TEXT NOT NULL,
    evidence_refs_json TEXT,
    recurrence_count INTEGER NOT NULL DEFAULT 1,
    confidence REAL NOT NULL DEFAULT 0.5,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);
CREATE INDEX idx_learnings_domain ON agent_learnings(domain);

CREATE TABLE IF NOT EXISTS lifecycle_events (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    workflow_id TEXT,
    event_type TEXT NOT NULL CHECK(event_type IN ('conversation_start','conversation_resume','workflow_checkpoint','pre_compaction','conversation_pause','conversation_close','session_end','daily_rollover')),
    event_data_json TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE
);
CREATE INDEX idx_lifecycle_conv ON lifecycle_events(conversation_id, created_at);

-- ==========================================
-- PHASE 4-5 — Workflows and Orchestration
-- ==========================================

CREATE TABLE IF NOT EXISTS workflows (
    id TEXT PRIMARY KEY,
    conversation_id TEXT NOT NULL,
    workspace_id TEXT NOT NULL,
    workflow_type TEXT NOT NULL CHECK(workflow_type IN ('planning','competitor_analysis','regulatory_analysis','document_preparation','institutional_diagnosis','monitoring_case')),
    trigger_type TEXT NOT NULL CHECK(trigger_type IN ('voice','manual','system','monitoring')),
    goal_statement TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'created' CHECK(status IN ('created','queued','running','waiting_confirmation','paused','completed','failed')),
    priority TEXT NOT NULL DEFAULT 'normal' CHECK(priority IN ('low','normal','high','urgent')),
    origin_voice_event_id TEXT,
    origin_envelope_id TEXT,
    created_from_resume INTEGER NOT NULL DEFAULT 0,
    suggested_output_type TEXT,        -- 'plan', 'report', 'parecer', 'alert', 'dossie'
    verification_required INTEGER NOT NULL DEFAULT 0,
    human_review_likely INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    completed_at TEXT,
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE,
    FOREIGN KEY (workspace_id) REFERENCES workspaces(id) ON DELETE RESTRICT
);
CREATE INDEX idx_workflows_conv ON workflows(conversation_id);
CREATE INDEX idx_workflows_status ON workflows(status);

CREATE TABLE IF NOT EXISTS workflow_seeds (
    id TEXT PRIMARY KEY,
    workflow_id TEXT NOT NULL UNIQUE,
    objective TEXT NOT NULL,
    scope_description TEXT,
    entities_json TEXT,                -- JSON: {"curso":"Gastronomia"}
    hypothesis_type TEXT,             -- tipo de workflow hipotético
    context_summary TEXT,
    known_facts_json TEXT,
    uncertainty_level TEXT CHECK(uncertainty_level IN ('low','medium','high')),
    expected_output_type TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS workflow_tasks (
    id TEXT PRIMARY KEY,
    workflow_id TEXT NOT NULL,
    parent_task_id TEXT,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','queued','running','completed','failed','skipped')),
    resource_class TEXT CHECK(resource_class IN ('light_io','heavy_io','cpu_parse','cpu_rank','llm_short','llm_long','render')),
    priority_score REAL NOT NULL DEFAULT 0.5,
    depends_on_json TEXT,             -- JSON array de task IDs
    result_json TEXT,                 -- JSON com resultado da task
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    started_at TEXT,
    completed_at TEXT,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE,
    FOREIGN KEY (parent_task_id) REFERENCES workflow_tasks(id) ON DELETE SET NULL
);
CREATE INDEX idx_tasks_workflow ON workflow_tasks(workflow_id, status);

CREATE TABLE IF NOT EXISTS executive_routing_packs (
    id TEXT PRIMARY KEY,
    workflow_id TEXT NOT NULL,
    conversation_id TEXT NOT NULL,
    goal_statement TEXT NOT NULL,
    normalized_transcript TEXT,
    primary_intent TEXT,
    entities_json TEXT,
    verification_requirements TEXT,
    suggested_output_type TEXT,
    priority_hint TEXT,
    ledger_ref TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS execution_routing_plans (
    id TEXT PRIMARY KEY,
    routing_pack_id TEXT NOT NULL,
    workflow_id TEXT NOT NULL,
    case_taxonomy TEXT NOT NULL CHECK(case_taxonomy IN ('simple_case','composite_case','sensitive_case','longitudinal_case')),
    decomposition_strategy TEXT NOT NULL CHECK(decomposition_strategy IN ('linear','parallel_with_synthesis','exploratory_early_checkpoint','longitudinal_monitoring')),
    domains_json TEXT NOT NULL,        -- JSON array: ["concorrencia","regulacao"]
    order_json TEXT NOT NULL,          -- JSON: ordem ou paralelismo
    verification_required INTEGER NOT NULL DEFAULT 0,
    hitl_required INTEGER NOT NULL DEFAULT 0,
    expected_delivery_format TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (routing_pack_id) REFERENCES executive_routing_packs(id) ON DELETE CASCADE,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS domain_assignments (
    id TEXT PRIMARY KEY,
    workflow_id TEXT NOT NULL,
    conversation_id TEXT NOT NULL,
    domain_target TEXT NOT NULL,       -- 'concorrencia', 'regulacao', 'diagnostico', 'verificacao', 'redacao'
    goal_statement TEXT NOT NULL,
    domain_objective TEXT NOT NULL,
    entities_json TEXT,
    context_pack_ref TEXT,
    verification_requirement TEXT CHECK(verification_requirement IN ('none','standard','mandatory')),
    expected_output_type TEXT,
    priority_hint TEXT,
    handoff_reason TEXT,
    status TEXT NOT NULL DEFAULT 'pending' CHECK(status IN ('pending','in_progress','completed','partial','blocked')),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE
);
CREATE INDEX idx_assignments_workflow ON domain_assignments(workflow_id);

CREATE TABLE IF NOT EXISTS domain_results (
    id TEXT PRIMARY KEY,
    assignment_id TEXT NOT NULL,
    domain_name TEXT NOT NULL,
    result_status TEXT NOT NULL CHECK(result_status IN ('ok','partial','blocked','conflicted')),
    quality_state TEXT NOT NULL,       -- domain-specific: 'broad_signal_only', 'impact_mapped', etc.
    executive_summary TEXT NOT NULL,
    findings_json TEXT,               -- JSON array de achados
    evidence_refs_json TEXT,
    institutional_truth_refs_json TEXT,
    confidence_score REAL CHECK(confidence_score BETWEEN 0.0 AND 1.0),
    conflicts_json TEXT,
    gaps_json TEXT,
    suggested_next_step TEXT,
    ready_for_verification INTEGER NOT NULL DEFAULT 0,
    ready_for_writing INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (assignment_id) REFERENCES domain_assignments(id) ON DELETE CASCADE
);

-- =====================================
-- PHASE 5 — Checkpoints and Delivery
-- =====================================

CREATE TABLE IF NOT EXISTS executive_checkpoints (
    id TEXT PRIMARY KEY,
    workflow_id TEXT NOT NULL,
    checkpoint_type TEXT NOT NULL CHECK(checkpoint_type IN ('initial','analytical','verification','draft','final')),
    executive_summary TEXT NOT NULL,
    completed_work_json TEXT,
    open_gaps_json TEXT,
    next_step TEXT,
    requires_user_action INTEGER NOT NULL DEFAULT 0,
    can_progress_without_user INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE
);
CREATE INDEX idx_checkpoints_workflow ON executive_checkpoints(workflow_id);

CREATE TABLE IF NOT EXISTS verification_artifacts (
    id TEXT PRIMARY KEY,
    workflow_id TEXT NOT NULL,
    domain_result_id TEXT,
    verification_stage TEXT NOT NULL CHECK(verification_stage IN ('intake','domain_output','cross_domain','pre_writing','final_release')),
    verification_status TEXT NOT NULL CHECK(verification_status IN ('green','yellow','red')),
    confidence_score REAL CHECK(confidence_score BETWEEN 0.0 AND 1.0),
    sufficiency_score REAL CHECK(sufficiency_score BETWEEN 0.0 AND 1.0),
    recency_score REAL CHECK(recency_score BETWEEN 0.0 AND 1.0),
    conflicts_json TEXT,
    gaps_json TEXT,
    allowed_next_steps_json TEXT,
    blocked_next_steps_json TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE,
    FOREIGN KEY (domain_result_id) REFERENCES domain_results(id) ON DELETE SET NULL
);
CREATE INDEX idx_verification_workflow ON verification_artifacts(workflow_id, verification_stage);

CREATE TABLE IF NOT EXISTS writing_requests (
    id TEXT PRIMARY KEY,
    workflow_id TEXT NOT NULL,
    output_type TEXT NOT NULL CHECK(output_type IN ('chat_executive','structured_note','formal_document')),
    document_type TEXT,               -- 'despacho','oficio','parecer','relatorio','plano','dossie','checklist'
    verification_status TEXT NOT NULL,
    institutional_alignment TEXT CHECK(institutional_alignment IN ('aligned','partially_aligned','conflicted','insufficient_internal_truth')),
    executive_profile_refs_json TEXT,
    template_ref TEXT,
    content_blocks_json TEXT NOT NULL,
    source_trace_refs_json TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS writing_outputs (
    id TEXT PRIMARY KEY,
    writing_request_id TEXT NOT NULL,
    output_type TEXT NOT NULL,
    title TEXT,
    executive_text TEXT,
    document_sections_json TEXT,
    printable INTEGER NOT NULL DEFAULT 0,
    exportable INTEGER NOT NULL DEFAULT 0,
    style_profile_version TEXT,
    release_status TEXT NOT NULL CHECK(release_status IN ('draft','review','approved','blocked','released')),
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (writing_request_id) REFERENCES writing_requests(id) ON DELETE CASCADE
);

-- =========================================
-- PHASE 6 — Institutional Truth Layer
-- =========================================

CREATE TABLE IF NOT EXISTS source_documents (
    id TEXT PRIMARY KEY,
    file_name TEXT NOT NULL,
    file_path TEXT NOT NULL,
    document_type TEXT NOT NULL,       -- 'contrato','regulamento','ppc','tabela_preco','organograma','ata','politica'
    ingested_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','superseded','archived')),
    version_label TEXT,
    hash_sha256 TEXT
);

CREATE TABLE IF NOT EXISTS institutional_facts (
    id TEXT PRIMARY KEY,
    fact_key TEXT NOT NULL,            -- 'curso.gastronomia.preco_mensal', 'ies.cnpj', etc.
    fact_value TEXT NOT NULL,
    fact_type TEXT NOT NULL DEFAULT 'text', -- 'text', 'number', 'date', 'json'
    valid_from TEXT NOT NULL,
    valid_until TEXT,                  -- NULL = vigente
    confidence TEXT NOT NULL DEFAULT 'confirmed' CHECK(confidence IN ('confirmed','probable','disputed','outdated')),
    source_document_id TEXT,
    source_description TEXT,
    confirmed_at TEXT,
    conflict_notes TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (source_document_id) REFERENCES source_documents(id) ON DELETE SET NULL
);
CREATE INDEX idx_facts_key ON institutional_facts(fact_key);
CREATE INDEX idx_facts_confidence ON institutional_facts(confidence);

CREATE VIRTUAL TABLE IF NOT EXISTS institutional_facts_fts USING fts5(
    fact_key,
    fact_value,
    source_description,
    content='institutional_facts',
    content_rowid='rowid'
);

CREATE TABLE IF NOT EXISTS canonical_views (
    id TEXT PRIMARY KEY,
    view_name TEXT NOT NULL UNIQUE,    -- 'ficha_institucional', 'ficha_curso', 'mapa_ingresso', etc.
    view_type TEXT NOT NULL,
    content_json TEXT NOT NULL,        -- JSON com a view renderizada
    generated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    source_facts_json TEXT            -- JSON array de fact IDs usados
);

-- ============================
-- PHASE 7 — Executive Profile
-- ============================

CREATE TABLE IF NOT EXISTS profile_traits (
    id TEXT PRIMARY KEY,
    trait_group TEXT NOT NULL,         -- 'escrita','formalidade','objetividade','tom','decisao','revisao'
    trait_key TEXT NOT NULL,
    trait_value TEXT NOT NULL,
    weight REAL NOT NULL DEFAULT 0.5 CHECK(weight BETWEEN 0.0 AND 1.0),
    version INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))
);
CREATE INDEX idx_traits_group ON profile_traits(trait_group);

CREATE TABLE IF NOT EXISTS trait_evidence (
    id TEXT PRIMARY KEY,
    trait_id TEXT NOT NULL,
    evidence_type TEXT NOT NULL,       -- 'approval', 'rejection', 'rewrite', 'time_to_approve'
    evidence_data_json TEXT NOT NULL,
    conversation_id TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (trait_id) REFERENCES profile_traits(id) ON DELETE CASCADE
);

-- ======================================
-- PHASE 8 — Monitoring and Intelligence
-- ======================================

CREATE TABLE IF NOT EXISTS monitoring_threads (
    id TEXT PRIMARY KEY,
    conversation_id TEXT,
    thread_type TEXT NOT NULL CHECK(thread_type IN ('regulatory_radar','competitor_radar','market_radar','internal_comparative')),
    subject TEXT NOT NULL,             -- 'UniAlfa Administração', 'Portaria X', etc.
    entities_json TEXT,
    status TEXT NOT NULL DEFAULT 'active' CHECK(status IN ('active','paused','concluded')),
    check_frequency TEXT DEFAULT 'weekly', -- 'daily', 'weekly', 'on_demand'
    last_checked_at TEXT,
    next_check_at TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS external_sources (
    id TEXT PRIMARY KEY,
    source_name TEXT NOT NULL,
    source_type TEXT NOT NULL,         -- 'official_gov', 'competitor_site', 'news', 'manual_input'
    url TEXT,
    last_accessed_at TEXT,
    reliability TEXT DEFAULT 'medium' CHECK(reliability IN ('high','medium','low','unknown'))
);

CREATE TABLE IF NOT EXISTS external_items (
    id TEXT PRIMARY KEY,
    source_id TEXT NOT NULL,
    monitoring_thread_id TEXT,
    item_type TEXT NOT NULL,           -- 'price', 'campaign', 'regulation', 'news', 'offer'
    title TEXT NOT NULL,
    content_summary TEXT,
    raw_data_json TEXT,
    detected_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    relevance_score REAL CHECK(relevance_score BETWEEN 0.0 AND 1.0),
    processed INTEGER NOT NULL DEFAULT 0,
    FOREIGN KEY (source_id) REFERENCES external_sources(id) ON DELETE CASCADE,
    FOREIGN KEY (monitoring_thread_id) REFERENCES monitoring_threads(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS comparison_reports (
    id TEXT PRIMARY KEY,
    monitoring_thread_id TEXT,
    workflow_id TEXT,
    report_type TEXT NOT NULL,         -- 'competitive_gap', 'regulatory_impact', 'market_trend'
    content_json TEXT NOT NULL,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (monitoring_thread_id) REFERENCES monitoring_threads(id) ON DELETE SET NULL,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE SET NULL
);

-- =====================================
-- PHASE 9 — Documents Engine
-- =====================================

CREATE TABLE IF NOT EXISTS documents (
    id TEXT PRIMARY KEY,
    conversation_id TEXT,
    workflow_id TEXT,
    writing_output_id TEXT,
    document_type TEXT NOT NULL,       -- 'despacho','oficio','parecer','relatorio','plano','dossie'
    title TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'draft' CHECK(status IN ('draft','review','approved','exported','archived')),
    current_version INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    updated_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE SET NULL,
    FOREIGN KEY (workflow_id) REFERENCES workflows(id) ON DELETE SET NULL,
    FOREIGN KEY (writing_output_id) REFERENCES writing_outputs(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS document_versions (
    id TEXT PRIMARY KEY,
    document_id TEXT NOT NULL,
    version_number INTEGER NOT NULL,
    content_json TEXT NOT NULL,        -- JSON com seções do documento
    change_summary TEXT,
    created_at TEXT NOT NULL DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now')),
    FOREIGN KEY (document_id) REFERENCES documents(id) ON DELETE CASCADE
);
CREATE INDEX idx_doc_versions ON document_versions(document_id, version_number DESC);

-- ============================================================================
-- CONTAGEM FINAL: 38 tabelas + 3 tabelas FTS5 = 41 objetos
-- Por fase: Phase 0 (4), Phase 1 (5+2 FTS), Phase 2 (5), Phase 3 (5),
--           Phase 4-5 (10), Phase 5 checkpoints (4), Phase 6 (3+1 FTS),
--           Phase 7 (2), Phase 8 (4), Phase 9 (2)
-- ============================================================================
