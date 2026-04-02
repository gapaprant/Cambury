# Coding Pack: Context Persistence (M3)

## Role
Continuidade entre sessões: ledger de estado, compaction, resume bundles, lifecycle events.

## Tables
`session_ledgers`, `compaction_events`, `context_packs`, `agent_learnings` (stub M3), `lifecycle_events`

## Endpoints
**POST /ledgers** → Body: `{conversation_id, workflow_id?, workspace, goal}` → 201
**GET /ledgers/:conversation_id/current** → último ledger ativo da conversa
**PATCH /ledgers/:id** → atualizar phase, accepted_facts, decisions, blockers, next_step
**POST /ledgers/:id/compact** → gera compaction_event com summary → 201
**POST /context-packs** → Body: `{conversation_id, workflow_id?, pack_type}` → monta e salva resume bundle → 201
**GET /context-packs/:conversation_id/latest?type=resume** → último pack do tipo
**POST /lifecycle-events** → Body: `{conversation_id, event_type, event_data}` → 201

## Lifecycle Events
`conversation_start`, `conversation_resume`, `workflow_checkpoint`, `pre_compaction`, `conversation_pause`, `conversation_close`, `session_end`, `daily_rollover`

## Compaction Rules
Compactar QUANDO: após checkpoint, antes de handoff, ao encerrar sessão, ao reabrir caso antigo. NÃO compactar: no meio de coleta crítica, durante verificação, antes de evidências mínimas registradas.

## Acceptance Criteria
1. ✅ Ledger criado ao abrir conversa, atualizado durante trabalho
2. ✅ Compaction gera summary JSON com goal, facts, decisions, blockers, next_step
3. ✅ Resume bundle monta pacote com último ledger + compact summary + fatos institucionais
4. ✅ Conversa longa retomável sem replay de histórico inteiro
5. ✅ Lifecycle events registrados corretamente

## Dependencies: M1, M2

---

# Coding Pack: Orchestration (M5)

## Role
Ponte voz→trabalho: Voice Execution Envelope → classificação → workflow creation → resposta incremental.

## Tables
`voice_execution_envelopes`, `orchestrator_decisions`, `workflows`, `workflow_seeds`, `workflow_tasks`, `executive_routing_packs`

## Endpoints
**POST /voice/execution-envelope** → Body: envelope data → 201
**POST /orchestrator/classify-request** → Body: `{envelope_id}` → `{decision_type, should_create_workflow, workflow_type}`
**POST /orchestrator/create-workflow-from-voice** → Body: `{envelope_id, workflow_type}` → `{workflow_id, seed_id, initial_tasks[]}`
**GET /workflows/:id** → full workflow with seed, tasks, checkpoints
**PATCH /workflows/:id** → `{status?, priority?}` (pause, resume, cancel)
**GET /workflows/:id/tasks** → `[{id, title, status, depends_on}]`
**POST /workflows/:id/tasks** → add task manually
**GET /orchestrator/decisions/:id** → decision details

## Workflow Types
`planning`, `competitor_analysis`, `regulatory_analysis`, `document_preparation`, `institutional_diagnosis`, `monitoring_case`

## Workflow States (see state-machines.md)
`created → queued → running → waiting_confirmation → paused → completed → failed`

## Decision Types
`local_reply`, `internal_retrieval`, `external_intelligence`, `workflow_creation`, `workflow_continuation`, `document_request`, `sensitive_review`

## MVP Simplification
- Max 1 workflow ativo por conversa (sem fairness/locks complexos)
- Árvore de tarefas: 3-5 template tasks por tipo de workflow
- Tasks não executam automaticamente — o orchestrator chama domínios sequencialmente

## Acceptance Criteria
1. ✅ Voice Execution Envelope criado a partir de intent
2. ✅ Classificação decide corretamente entre local_reply e workflow_creation
3. ✅ Workflow criado com seed, tipo, prioridade e tasks iniciais
4. ✅ Pausa, retomada e cancelamento funcionam com state machine correta
5. ✅ Resposta incremental: ack imediato + progress + checkpoint

## Dependencies: M1, M2, M3, M4

---

# Coding Pack: Institutional Truth (M6)

## Role
Base de fatos da IES: fatos canônicos, documentos-fonte, precedência, busca FTS, cruzamento.

## Tables
`source_documents`, `institutional_facts`, `institutional_facts_fts`, `canonical_views`

## Endpoints
**POST /source-documents** → upload documento-fonte → 201
**GET /source-documents** → lista com filtro por type, status
**POST /institutional-facts** → Body: `{fact_key, fact_value, fact_type, valid_from, source_document_id?, confidence}` → 201
**GET /institutional-facts?key_prefix=curso.gastronomia&confidence=confirmed** → filtro
**GET /institutional-facts/search?q=preço+gastronomia** → busca FTS5
**PATCH /institutional-facts/:id** → atualizar value, confidence, valid_until
**GET /canonical-views/:view_name** → gera view derivada (ficha_institucional, ficha_curso)
**POST /institutional-facts/cross-check** → Body: `{claims_json}` → `{aligned[], conflicted[], missing[]}` ← usado pela verificação

## Fact Keys Convention
`ies.<attr>` (ex: ies.cnpj, ies.nome), `curso.<nome>.<attr>` (ex: curso.gastronomia.preco_mensal), `infra.<item>`, `contrato.<nome>.<attr>`

## Precedence Rules
confirmed > probable > disputed > outdated. Documento homologado > rascunho. Tabela vigente > tabela antiga.

## MVP Simplification
Ingestão manual: Giuseppe faz upload de PDFs/docs, sistema extrai texto básico (não OCR avançado). Fatos inseridos via UI ou importação simples.

## Acceptance Criteria
1. ✅ Fatos CRUD com chave, valor, vigência, confiança, fonte
2. ✅ Busca FTS5 retorna fatos relevantes por texto
3. ✅ Cross-check compara claims com fatos e retorna aligned/conflicted/missing
4. ✅ Views derivadas (ficha institucional) geradas sob demanda

## Dependencies: M1, M2

---

# Coding Pack: Domain Agents (M7 + M8)

## Role
Coordenação cognitiva: Executivo roteia → domínios analisam → verificação valida → redação finaliza.

## Tables
`execution_routing_plans`, `domain_assignments`, `domain_results`, `executive_checkpoints`, `verification_artifacts`, `writing_requests`, `writing_outputs`

## Endpoints
**POST /executive/route** → Body: `{routing_pack_id}` → `{routing_plan_id, domains[], strategy}` (chama LLM)
**POST /domains/assign** → Body: `{workflow_id, domain_target, goal_statement, entities}` → 201
**POST /domains/:assignment_id/execute** → executa domain analysis (chama LLM) → `{domain_result_id}`
**GET /domains/results/:id** → full Domain Result Package
**POST /verification/check** → Body: `{domain_result_id, stage}` → `{verification_status, confidence, gaps}`
**POST /writing/request** → Body: `{workflow_id, output_type, content_blocks}` → `{writing_output_id}`
**GET /writing/outputs/:id** → full writing output
**POST /checkpoints** → Body: `{workflow_id, checkpoint_type, executive_summary}` → 201
**GET /workflows/:id/checkpoints** → lista de checkpoints

## MVP Architecture (KEY DECISION)
Cada domínio = 1 função Python que monta prompt + context → chama Claude → parseia JSON → retorna Domain Result Package. NÃO é árvore de subagents.

```python
async def execute_domain(assignment: DomainAssignment, context: ContextPack) -> DomainResult:
    prompt = build_domain_prompt(assignment.domain_target, assignment, context)
    response = await call_claude(model="sonnet", system=prompt, max_tokens=4000)
    return parse_domain_result(response)
```

## Domain Quality States
- Concorrência: `broad_signal_only | course_comparable | competitive_gap_ready | insufficient_public_evidence`
- Regulação: `descriptive_only | impact_mapped | regulatory_case_ready | normative_conflict_or_gap`
- Diagnóstico: `diagnostic_sketch | actionable_diagnosis | plan_skeleton_ready | insufficient_internal_basis`

## Case Taxonomy
`simple_case` (1 domínio), `composite_case` (2+ domínios), `sensitive_case` (verificação obrigatória + possível HITL), `longitudinal_case` (monitoramento contínuo)

## Verification Stages (see state-machines.md)
`intake` → `domain_output` → `cross_domain` → `pre_writing` → `final_release`. MVP implementa stages 2 e 4 reais; 1, 3, 5 como pass-through.

## Writing Output Formats
`chat_executive` (resposta curta na conversa), `structured_note` (síntese com seções), `formal_document` (documento imprimível)

## Acceptance Criteria
1. ✅ Executivo produz routing plan com domínios e estratégia
2. ✅ Domain assignment delegado e executado com Result Package retornado
3. ✅ Verificação stage 2 (domain_output) classifica green/yellow/red
4. ✅ Verificação stage 4 (pre_writing) bloqueia red, permite yellow com caveat
5. ✅ Redação produz output nos 3 formatos
6. ✅ Checkpoint executivo gerado a cada fase relevante
7. ✅ Caso composto com 2 domínios coordenado sem perda de contexto

## Dependencies: M1-M6

---

# Coding Pack: Monitoring (M10)

## Role
Inteligência contínua: threads de monitoramento, dados externos, alertas, comparações.

## Tables
`monitoring_threads`, `external_sources`, `external_items`, `comparison_reports`

## Endpoints
**POST /monitoring/threads** → Body: `{subject, thread_type, entities, check_frequency}` → 201
**GET /monitoring/threads?status=active** → lista
**PATCH /monitoring/threads/:id** → pause/resume/conclude
**POST /external-items** → Body: `{source_id, monitoring_thread_id?, item_type, title, content_summary}` → 201 (input manual no MVP)
**GET /monitoring/threads/:id/items** → itens externos vinculados
**POST /monitoring/threads/:id/compare** → gera comparison_report cruzando com fatos institucionais → 201

## MVP Simplification
Toda coleta é MANUAL no MVP. Giuseppe insere dados de concorrentes/regulação via UI. Sistema organiza, compara com base institucional, e gera alertas. Coleta automática (web scraping) é pós-MVP.

## Thread Types
`regulatory_radar`, `competitor_radar`, `market_radar`, `internal_comparative`

## Acceptance Criteria
1. ✅ Thread criado com assunto e tipo
2. ✅ Itens externos vinculados a thread
3. ✅ Comparação com fatos institucionais gera report
4. ✅ Pause/resume/conclude funcionam

## Dependencies: M1, M2, M6, M8

---

# Coding Pack: Documents (M11)

## Role
Produção documental: templates, renderização, versionamento, exportação PDF/DOCX, impressão.

## Tables
`documents`, `document_versions`

## Endpoints
**POST /documents** → Body: `{conversation_id?, workflow_id?, document_type, title}` → 201
**GET /documents/:id** → with current version content
**GET /documents/:id/versions** → lista de versões
**POST /documents/:id/versions** → Body: `{content_json, change_summary}` → nova versão → 201
**POST /documents/:id/export?format=pdf** → gera PDF (WeasyPrint) → retorna file path
**POST /documents/:id/export?format=docx** → gera DOCX (pandoc) → retorna file path
**PATCH /documents/:id** → `{status, title}`

## Document Types
`despacho`, `oficio`, `parecer`, `relatorio`, `plano`, `dossie`, `checklist`

## MVP Templates
Cada tipo tem template Markdown com placeholders: {header}, {date}, {recipient}, {body}, {signature}, {footer}. WeasyPrint converte Markdown→HTML→PDF com CSS institucional.

## Acceptance Criteria
1. ✅ Documento criado com tipo e título
2. ✅ Versões acumulam sem sobrescrever
3. ✅ Export PDF gera arquivo legível
4. ✅ Export DOCX gera arquivo editável
5. ✅ Documento vinculado a conversa e/ou workflow

## Dependencies: M1, M2, M7 (writing outputs alimentam documents)
