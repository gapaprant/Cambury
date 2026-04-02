# Coding Pack: Conversations and Navigation (M2)

## Role
Espinha dorsal organizacional: 4 workspaces, conversas tituladas, busca, mensagens, anexos, auditoria.

## Tables
- `workspaces` (id, name, type CHECK IN 4 valores, display_order)
- `conversations` (id, workspace_id FK, title MIN 3 chars, status, origin_mode, objective_summary, course_ref)
- `conversation_tags` (id, conversation_id FK CASCADE, tag_value)
- `messages` (id, conversation_id FK CASCADE, role, message_type, raw_text, message_order)
- `attachments` (id, conversation_id FK CASCADE, file_name, mime_type, file_path, size_bytes, status)
- `audit_log` (já existe de M1)
- `conversations_fts` (FTS5 sobre title + objective_summary)
- `messages_fts` (FTS5 sobre raw_text)

## Endpoints

### Workspaces
**GET /workspaces** → `[{id, name, type, display_order, conversation_count}]`
**GET /workspaces/:id** → `{id, name, type, display_order, conversation_count, recent_conversations: [{id, title, updated_at}]}`

### Conversations
**POST /conversations** → Body: `{workspace_id, title, origin_mode?, objective_summary?, course_ref?, tags?[]}` → 201: `{id, workspace_id, title, status, created_at}` | 400: `{error: "title_required" | "title_too_short" | "workspace_not_found"}`
**GET /conversations/:id** → `{id, workspace_id, title, status, origin_mode, objective_summary, course_ref, tags[], message_count, attachment_count, created_at, updated_at}`
**GET /workspaces/:id/conversations?status=active&limit=20&offset=0** → `{items: [...], total, has_more}`
**PATCH /conversations/:id** → Body: `{title?, status?, objective_summary?, course_ref?}` → 200 | 400 | 404
**POST /conversations/:id/archive** → 200 | 404
**POST /conversations/:id/pause** → 200 | 404

### Search
**GET /search/conversations?workspace_id=...&query=...&limit=20** → `{items: [{id, title, workspace_name, updated_at, snippet}], total}`
**GET /search/global?query=...&limit=20** → same shape, all workspaces

### Messages
**POST /conversations/:id/messages** → Body: `{role, raw_text, message_type?}` → 201: `{id, conversation_id, role, message_type, raw_text, message_order, created_at}`
**GET /conversations/:id/messages?limit=50&before_order=...** → `{items: [...], total, has_more}` (paginação por message_order DESC)

### Attachments
**POST /conversations/:id/attachments** → Multipart form: file + metadata → 201: `{id, file_name, mime_type, size_bytes, uploaded_at}`
**GET /conversations/:id/attachments** → `[{id, file_name, mime_type, size_bytes, status, uploaded_at}]`
**DELETE /attachments/:id** → 200 (soft-delete: status='deleted') | 404

## Business Rules
- Conversa sem título = erro 400 (nunca permitir)
- Conversa sempre pertence a 1 workspace
- Busca padrão = dentro da workspace atual (workspace_id obrigatório exceto global)
- Título tem peso 2x sobre body na ordenação FTS5
- Ao atualizar título → atualizar `updated_at` + audit_log
- Mensagem nunca é hard-deleted
- Attachment soft-delete → status='deleted' + audit_log

## Audit Events
`conversation.created`, `conversation.title_changed`, `conversation.status_changed`, `conversation.opened`, `attachment.uploaded`, `attachment.deleted`

## Acceptance Criteria
1. ✅ 4 workspaces existem após bootstrap (seed)
2. ✅ Criar conversa em qualquer workspace com título obrigatório
3. ✅ Sistema rejeita conversa sem título (400)
4. ✅ Busca por título dentro de workspace funciona
5. ✅ Mensagens salvas e recarregadas corretamente após restart
6. ✅ Anexo upload → listável → soft-deletable
7. ✅ Eventos de auditoria registrados
8. ✅ UI: sidebar com 4 workspaces, lista de conversas, painel de chat, campo de busca

## Scope Limits
NÃO implementar: sugestão automática de título, classificação semântica, voz, workflow, memória. Apenas CRUD organizado.

## Dependencies
- M1 (Foundation): backend rodando, DB com migrations, health checks ok
