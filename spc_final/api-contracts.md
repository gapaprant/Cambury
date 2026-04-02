# API Contracts V1

> Base URL: `http://localhost:8741`
> Content-Type: `application/json`
> Todas as respostas de erro seguem: `{"error": "<code>", "message": "<human-readable>", "details": {}}`
> Códigos de erro HTTP: 400 (input inválido), 404 (não encontrado), 409 (conflito de estado), 500 (erro interno)

---

## Phase 0 — Foundation

### GET /health/live
Response 200: `{"status": "alive", "timestamp": "string(ISO8601)"}`

### GET /health/ready
Response 200: `{"status": "ready", "checks": {"db": "bool", "dirs": "bool", "config": "bool", "storage_writable": "bool", "migrations_current": "bool"}}`
Response 503: `{"status": "not_ready", "checks": {...}, "failing": ["string"]}`

### GET /health/dependencies
Response 200: `{"backend": "bool", "sqlite": "bool", "disk_space_mb": "int", "disk_min_mb": "int", "whisper_model_loaded": "bool"}`

### GET /system/info
Response 200: `{"app_name": "string", "schema_version": "string", "python_version": "string", "uptime_seconds": "float"}`

### GET /system/version
Response 200: `{"version": "string", "build_date": "string(ISO8601)", "schema_version": "string"}`

### POST /system/shutdown
Response 200: `{"status": "shutting_down"}`

---

## Phase 1 — Conversations

### GET /workspaces
Response 200: `{"items": [{"id": "uuid", "name": "string", "type": "string", "display_order": "int", "conversation_count": "int"}]}`

### GET /workspaces/:id
Response 200: `{"id": "uuid", "name": "string", "type": "string", "display_order": "int", "conversation_count": "int", "recent_conversations": [{"id": "uuid", "title": "string", "status": "string", "updated_at": "ISO8601"}]}`

### POST /conversations
Request: `{"workspace_id": "uuid(required)", "title": "string(required, min 3)", "origin_mode": "manual|voice(default:manual)", "objective_summary": "string?", "course_ref": "string?", "tags": ["string"]?}`
Response 201: `{"id": "uuid", "workspace_id": "uuid", "title": "string", "status": "active", "origin_mode": "string", "created_at": "ISO8601"}`
Error 400: `{"error": "title_required|title_too_short|workspace_not_found"}`

### GET /conversations/:id
Response 200: `{"id": "uuid", "workspace_id": "uuid", "title": "string", "status": "string", "origin_mode": "string", "objective_summary": "string?", "course_ref": "string?", "tags": ["string"], "message_count": "int", "attachment_count": "int", "created_at": "ISO8601", "updated_at": "ISO8601"}`

### GET /workspaces/:id/conversations
Query: `?status=active&limit=20&offset=0&sort=updated_at:desc`
Response 200: `{"items": [{...conversation}], "total": "int", "has_more": "bool"}`

### PATCH /conversations/:id
Request: `{"title": "string?", "status": "string?", "objective_summary": "string?", "course_ref": "string?"}`
Response 200: `{...updated conversation}`
Error 409: `{"error": "invalid_state_transition", "details": {"from": "archived", "to": "draft"}}`

### POST /conversations/:id/messages
Request: `{"role": "user|assistant|system|reviewer(required)", "raw_text": "string(required)", "message_type": "standard|ack|progress|checkpoint|review_request|partial_output(default:standard)", "workflow_id": "uuid?", "executive_summary": "string?", "next_step_hint": "string?", "requires_user_action": "bool(default:false)"}`
Response 201: `{"id": "uuid", "conversation_id": "uuid", "role": "string", "message_type": "string", "raw_text": "string", "message_order": "int", "created_at": "ISO8601"}`

### GET /conversations/:id/messages
Query: `?limit=50&before_order=100`
Response 200: `{"items": [{...message}], "total": "int", "has_more": "bool"}`

### GET /search/conversations
Query: `?workspace_id=uuid&query=string&limit=20`
Response 200: `{"items": [{"id": "uuid", "title": "string", "workspace_name": "string", "status": "string", "updated_at": "ISO8601", "snippet": "string"}], "total": "int"}`

### POST /conversations/:id/attachments
Content-Type: `multipart/form-data` — field `file` (binary) + field `metadata` (JSON)
Response 201: `{"id": "uuid", "file_name": "string", "mime_type": "string", "size_bytes": "int", "uploaded_at": "ISO8601"}`

### DELETE /attachments/:id
Response 200: `{"id": "uuid", "status": "deleted"}`

---

## Phase 2 — Voice

### POST /voice/capture/start
Response 200: `{"voice_event_id": "uuid", "status": "recording"}`

### POST /voice/capture/stop
Request: `{"voice_event_id": "uuid(required)"}`
Response 200: `{"voice_event_id": "uuid", "audio_path": "string", "duration_seconds": "float"}`

### POST /voice/process
Request: `{"voice_event_id": "uuid(required)"}`
Response 200: `{"voice_event_id": "uuid", "transcript": {"raw": "string", "normalized": "string", "quality_score": "float(0-1)"}, "intent": {"primary_intent": "string", "secondary_intent": "string?", "workspace_candidate": "string", "conversation_action": "string", "entities": {"curso": "string?", "concorrente": "string?", "tema": "string?"}, "confidence_score": "float(0-1)", "requires_confirmation": "bool", "suggested_title": "string?"}}`

### POST /intent/resolve-conversation
Request: `{"intent_event_id": "uuid(required)"}`
Response 200: `{"resolved_conversation_id": "uuid?", "action_taken": "string", "created_new_conversation": "bool", "title_final": "string?", "workspace_final": "string"}`

### POST /voice/confirm
Request: `{"intent_event_id": "uuid(required)", "confirmed_action": "string(required)", "confirmed_workspace": "string?", "confirmed_title": "string?"}`
Response 200: `{"conversation_id": "uuid", "action_taken": "string"}`

---

## Phase 3+ — Orchestration, Domains, Verification, Writing

### POST /orchestrator/classify-request
Request: `{"envelope_id": "uuid(required)"}`
Response 200: `{"decision_type": "string", "should_create_workflow": "bool", "workflow_type": "string?", "routed_to_executive": "bool"}`

### POST /orchestrator/create-workflow-from-voice
Request: `{"envelope_id": "uuid(required)", "workflow_type": "string(required)"}`
Response 201: `{"workflow_id": "uuid", "seed_id": "uuid", "initial_tasks": [{"id": "uuid", "title": "string", "status": "pending"}], "status": "created"}`

### GET /workflows/:id
Response 200: `{"id": "uuid", "conversation_id": "uuid", "workflow_type": "string", "status": "string", "priority": "string", "goal_statement": "string", "seed": {...}, "tasks": [{...}], "checkpoints": [{...}], "created_at": "ISO8601"}`

### PATCH /workflows/:id
Request: `{"status": "paused|queued?", "priority": "string?"}`
Response 200: `{...updated workflow}`
Error 409: `{"error": "invalid_state_transition"}`

### POST /executive/route
Request: `{"routing_pack_id": "uuid(required)"}`
Response 200: `{"routing_plan_id": "uuid", "case_taxonomy": "string", "domains": ["string"], "strategy": "string", "verification_required": "bool"}`

### POST /domains/:assignment_id/execute
Response 200: `{"domain_result_id": "uuid", "result_status": "ok|partial|blocked|conflicted", "quality_state": "string", "executive_summary": "string"}`

### POST /verification/check
Request: `{"domain_result_id": "uuid(required)", "stage": "intake|domain_output|cross_domain|pre_writing|final_release(required)"}`
Response 200: `{"verification_status": "green|yellow|red", "confidence_score": "float", "sufficiency_score": "float", "approved_for_writing": "bool", "human_review_required": "bool"}`

### POST /writing/request
Request: `{"workflow_id": "uuid(required)", "output_type": "chat_executive|structured_note|formal_document(required)", "document_type": "string?", "content_blocks_json": "string(required)"}`
Response 201: `{"writing_output_id": "uuid", "output_type": "string", "release_status": "draft"}`

### POST /documents/:id/export
Query: `?format=pdf|docx`
Response 200: `{"file_path": "string", "file_name": "string", "format": "string", "size_bytes": "int"}`
