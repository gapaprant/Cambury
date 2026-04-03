# SPEC-IMPL-001A — Decisões Técnicas (Tech Stack)

**Projeto:** Giuseppe Executive Assistant
**Status:** FROZEN V1 — mudanças apenas via change log
**Data:** 02/04/2026

---

## Stack Principal

| Camada | Tecnologia | Versão | Justificativa |
|--------|-----------|--------|---------------|
| Desktop Shell | Electron | 28+ | Único framework maduro para app desktop com web tech |
| Empacotamento | Electron Builder | latest | Mais maduro que Forge para produção Windows |
| Frontend | React + TypeScript | React 18 / TS 5.4+ | Ecossistema maduro, tipagem forte |
| Build frontend | Vite | 5+ | Rápido, boa integração com React/TS |
| Backend | Python + FastAPI | Python 3.12 / FastAPI 0.110+ | Async nativo, tipagem com Pydantic, documentação auto |
| DB | SQLite | 3.45+ (via aiosqlite) | Local-first, zero config, FTS5 nativo |
| Migrations | Alembic | 1.13+ | Padrão para SQLAlchemy/SQLite, versionamento robusto |
| ORM/Query | SQLAlchemy 2.0 (async) | 2.0+ | Type-safe, async com aiosqlite, migration via Alembic |
| Agent Framework | LangGraph | 0.2+ | Workflows com estado, checkpoints nativos |
| STT (voz→texto) | faster-whisper | latest (modelo: small) | Local, offline, bom pt-BR, ~2GB RAM |
| Vector DB | ChromaDB embedded | 0.5+ | Embedded, zero infra, compatível SQLite |
| LLM Provider | Anthropic (Claude API) | Claude Sonnet 4 / Opus 4 | Melhor structured output, tool use maduro |
| Testes backend | pytest + pytest-asyncio | latest | Padrão Python, suporte async |
| Testes frontend | Vitest | latest | Compatível Vite, rápido |
| Logging | structlog | latest | JSON structured, rotação de arquivos |

## Convenções de Código

| Convenção | Decisão |
|-----------|---------|
| Idioma do código | Inglês (variáveis, funções, classes, comentários) |
| Idioma da UI | Português brasileiro |
| Formato de IDs | UUID v4 (`uuid.uuid4()` / `crypto.randomUUID()`) |
| Timestamps | ISO 8601 UTC em banco, convertido para Brasília na UI |
| Naming Python | snake_case para funções/variáveis, PascalCase para classes |
| Naming TypeScript | camelCase para variáveis/funções, PascalCase para componentes/tipos |
| Naming SQL | snake_case para tabelas e colunas |
| Naming API | kebab-case para URLs, camelCase para JSON body |
| Porta backend local | 8741 |
| Comunicação Electron↔Python | HTTP REST via localhost:8741 (não IPC) |
| JSON serialization | Pydantic V2 model_dump(mode="json") |

## LLM — Modelo por Tarefa

| Tarefa | Modelo | Max tokens input | Max tokens output | Retry | Fallback |
|--------|--------|---------|---------|-------|----------|
| Intent classification (voz) | Claude Sonnet 4 | 2,000 | 500 | 2x com backoff | Classificar como `generic_chat` |
| Conversation resolution | Claude Sonnet 4 | 3,000 | 500 | 2x | Perguntar ao usuário |
| Executive routing | Claude Sonnet 4 | 5,000 | 2,000 | 2x | Fallback para single-domain |
| Domain analysis | Claude Sonnet 4 | 8,000 | 4,000 | 2x | Retornar `partial` status |
| Verification | Claude Sonnet 4 | 6,000 | 2,000 | 2x | Retornar `yellow` (conservador) |
| Executive writing | Claude Sonnet 4 | 8,000 | 4,000 | 3x | Retornar draft com caveat |
| Complex reasoning | Claude Opus 4 | 10,000 | 6,000 | 2x | Downgrade para Sonnet |
| Transcript normalization | Regra local (regex) | — | — | — | Manter raw transcript |
| Title suggestion | Claude Sonnet 4 | 1,000 | 100 | 1x | Usar primeiras palavras da fala |

### Prompt Strategy

| Padrão | Uso |
|--------|-----|
| System prompt + structured output (JSON) | Intent classification, routing, verification |
| System prompt + tool use | Domain analysis (tools = consulta DB, busca vetorial) |
| System prompt + few-shot examples | Executive writing (exemplos de estilo do Giuseppe) |
| System prompt + chain of thought | Complex reasoning, cross-domain verification |

### Custo Estimado

| Cenário | Chamadas/dia | Custo/dia | Custo/mês |
|---------|-------------|-----------|-----------|
| Uso leve (5-10 interações) | ~30 | ~$1.50 | ~$35 |
| Uso normal (15-25 interações) | ~60 | ~$3.00 | ~$70 |
| Uso intenso (30+ interações) | ~100 | ~$5.00 | ~$115 |

### Cache Strategy

- Respostas de fatos institucionais: cache 24h (SQLite table `llm_cache`)
- Intent classification: sem cache (cada fala é única)
- Domain analysis: cache por (entities + goal_hash), TTL 1h
- Invalidação: qualquer mudança em institutional_facts invalida cache relacionado

## STT — Configuração

| Parâmetro | Valor | Motivo |
|-----------|-------|--------|
| Engine | faster-whisper | Offline, local, gratuito |
| Modelo inicial | small | Equilíbrio qualidade/velocidade (~2GB RAM) |
| Idioma | pt (forçado, não auto-detect) | Reduz erro em pt-BR |
| Formato áudio | WAV 16kHz mono PCM | Formato nativo do Whisper |
| VAD | Silero VAD (embutido no faster-whisper) | Corta silêncio, melhora qualidade |
| Critério de upgrade | Se erro > 20% em 50 frases-teste | Subir para modelo medium |
| Fallback cloud | Whisper API (OpenAI) | Se hardware não suportar local |

## Hardware Mínimo (máquina do Giuseppe)

| Recurso | Mínimo | Recomendado |
|---------|--------|-------------|
| SO | Windows 10 64-bit | Windows 11 |
| RAM | 8 GB | 16 GB |
| CPU | 4 cores, 2.5 GHz | 8 cores, 3.0 GHz |
| Disco | SSD, 10 GB livres | SSD, 50 GB livres |
| GPU | Não necessária (CPU inference) | NVIDIA com CUDA (acelera STT 3-5x) |
| Microfone | Qualquer integrado | Headset USB ou microfone dedicado |

## Backup Strategy

| Item | Frequência | Destino | Retenção |
|------|-----------|---------|----------|
| app.db (SQLite) | Diário automático + antes de migration | `backups/db/app_YYYYMMDD_HHMMSS.db` | Últimos 30 dias |
| artifacts/ | Não copiado automaticamente (volume grande) | Manual pelo Giuseppe quando desejar | Indefinida |
| config/ | A cada mudança | `backups/config/` | Últimas 10 versões |
| Método | cp do arquivo SQLite quando backend idle | — | — |
| Restore | Copiar backup sobre app.db, rodar migration check | — | — |

## Error Handling Baseline

| Componente | Tipo de falha | Comportamento |
|-----------|--------------|---------------|
| Backend não inicia | Crítico | Splash screen com mensagem de erro + log detalhado |
| SQLite locked | Recuperável | Retry 3x com backoff, depois erro ao usuário |
| Migration falha | Crítico | Bloqueia app, mostra erro, preserva backup pré-migration |
| LLM API timeout | Recuperável | Retry conforme tabela acima, fallback por tarefa |
| LLM API 429 (rate limit) | Recuperável | Backoff exponencial, max 60s espera |
| LLM API 500 | Recuperável | Retry 2x, depois retornar erro graceful ao usuário |
| STT falha (áudio ruim) | Recuperável | Retornar "não entendi", pedir nova fala |
| STT falha (modelo) | Crítico | Fallback para input texto, log do erro |
| Disco cheio | Crítico | Bloquear operações de escrita, alertar usuário |
| Voice device ausente | Recuperável | Desabilitar botão push-to-talk, habilitar só texto |

## Testes — Mínimo por Milestone

| Milestone | Tipo de teste | Framework | Critério de passe |
|-----------|--------------|-----------|-------------------|
| M1 | Unit + integration | pytest | Todos os endpoints respondem, DB cria e migra |
| M2 | Unit + integration | pytest + Vitest | CRUD completo funciona, busca retorna correto |
| M3 | Unit | pytest | Ledger cria/compacta/restaura sem perda |
| M4 | Integration | pytest | Transcrição de 10 frases-teste com >80% acerto |
| M5+ | Unit + integration + manual | pytest | Workflow cria, persiste, retoma corretamente |
