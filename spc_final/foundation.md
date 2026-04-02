# Coding Pack: Foundation (M1)

## Role
Base executável local: Electron → spawna FastAPI → SQLite → health checks → logs → instalação.

## Tables (from unified-ddl.sql)
- `system_metadata` (key/value)
- `migrations_applied` (version tracking)
- `audit_log` (event_type, target_type, target_id, actor, event_data)
- `llm_cache` (cache_key, task_type, response_json, expires_at)

## Endpoints

### GET /health/live
Response 200: `{"status": "alive", "timestamp": "<ISO>"}`

### GET /health/ready
Response 200: `{"status": "ready", "checks": {"db": true, "dirs": true, "config": true, "storage_writable": true, "migrations_current": true}}`
Response 503: `{"status": "not_ready", "checks": {...}, "failing": ["db"]}`

### GET /health/dependencies
Response 200: `{"backend": true, "sqlite": true, "disk_space_mb": 5200, "disk_min_mb": 500, "whisper_model_loaded": false}`

### GET /system/info
Response 200: `{"app_name": "Giuseppe Executive Assistant", "schema_version": "1", "python_version": "3.12.x", "uptime_seconds": 142}`

### GET /system/version
Response 200: `{"version": "0.1.0", "build_date": "<ISO>", "schema_version": "1"}`

### POST /system/shutdown
Response 200: `{"status": "shutting_down"}`
Behavior: Backend finaliza tasks em andamento, flush logs, fecha DB, retorna 200, encerra processo.

## Bootstrap Sequence (first run)
1. Detectar diretório-base → 2. Criar dirs (logs/, data/, artifacts/*, cache/, backups/, config/) → 3. Criar app_config.json + runtime_config.json com defaults → 4. Iniciar FastAPI → 5. Conectar SQLite → 6. Criar DB se não existir → 7. Rodar Alembic migrations → 8. Seed system_metadata → 9. Health check all → 10. Informar frontend ready → 11. Liberar UI.

## Startup Sequence (normal run)
1. Electron inicia → 2. Splash screen → 3. Spawna Python (`subprocess.Popen`) → 4. Polling GET /health/ready (max 30s, interval 500ms) → 5. Se ready → libera UI principal → 6. Se timeout → tela de erro.

## Shutdown Sequence
1. Frontend chama POST /system/shutdown → 2. Backend flush logs → 3. Fecha DB connections → 4. Processo Python encerra → 5. Electron verifica encerramento (max 10s) → 6. Se timeout → kill process → 7. App fecha.

## Config Files

**app_config.json:** `{app_name, language: "pt-BR", base_path, export_preferences, feature_flags, expected_schema_version, backup_policy: {enabled, frequency_hours: 24, retention_days: 30}}`

**runtime_config.json:** `{port: 8741, timeouts: {startup: 30, shutdown: 10, llm: 60}, log_max_mb: 50, whisper_model: "small", anthropic_api_key: "sk-..."}`

## Logging (structlog)
Files: `logs/app.log`, `logs/backend.log`, `logs/bootstrap.log`, `logs/error.log`
Fields per entry: `timestamp, level (INFO/WARN/ERROR), component, operation, correlation_id, message, context`
Rotation: 10MB per file, keep 5 rotations.

## Acceptance Criteria
1. ✅ Instalador funciona em Windows 10/11 com ícone na área de trabalho
2. ✅ Clique no ícone → splash → backend sobe → UI principal em <15s
3. ✅ GET /health/live retorna 200
4. ✅ GET /health/ready retorna 200 com todos checks true
5. ✅ DB criado automaticamente com tabelas de Phase 0
6. ✅ Dirs criados automaticamente
7. ✅ Fechar app → sem processos zumbis (verificar com `tasklist`)
8. ✅ Logs gerados em logs/
9. ✅ Erro de bootstrap → tela de erro guiada, não crash silencioso
10. ✅ Reinstalação preserva data/

## Scope Limits
NÃO implementar: voz, conversas, agentes, workflows, monitoramento. Apenas o shell que os sustenta.

## Dependencies
- External: Electron 28+, Python 3.12, SQLite (bundled)
- Internal: nenhuma (este é o primeiro milestone)
