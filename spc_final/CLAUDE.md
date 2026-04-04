# Giuseppe Executive Assistant

Sistema executivo local com memória institucional, agentes especializados, produção documental e monitoramento estratégico para gestão de IES. Single-user, local-first, voice-first.

## Tech Stack
- **Backend:** Python 3.12 + FastAPI 0.110+ (porta 8741)
- **Frontend:** React 18 + TypeScript 5.4+ + Vite 5
- **Desktop:** Electron 28+ (Electron Builder)
- **DB:** SQLite 3.45+ via aiosqlite + SQLAlchemy 2.0 async
- **Migrations:** Alembic
- **STT:** faster-whisper (small model, pt)
- **LLM:** Claude API (Sonnet 4 padrão, Opus 4 para raciocínio complexo)
- **Vector:** ChromaDB embedded
- **Agents:** LangGraph 0.2+
- **Tests:** pytest + pytest-asyncio (backend), Vitest (frontend)
- **Logging:** structlog (JSON structured)

## Conventions
- Code in English, UI in pt-BR
- All IDs: UUID v4
- Timestamps: ISO 8601 UTC in DB, Brasília timezone in UI
- Python: snake_case functions/vars, PascalCase classes
- TypeScript: camelCase vars/functions, PascalCase components
- SQL: snake_case tables and columns
- API URLs: kebab-case; JSON body: camelCase
- Electron ↔ Python: HTTP REST via localhost:8741

## Project Structure
```
giuseppe-executive-assistant/
├── CLAUDE.md                    ← you are here
├── docs/
│   ├── tech-stack.md            ← all technical decisions, LLM config, costs
│   ├── unified-ddl.sql          ← complete DB schema (38 tables + 3 FTS5)
│   ├── mvp-scope.md             ← what's real, stub, or future
│   ├── llm-integration.md       ← model per task, prompts strategy, budget
│   └── coding-packs/            ← context per component (read before implementing)
│       ├── foundation.md
│       ├── conversations.md
│       ├── voice.md
│       ├── context-persistence.md
│       ├── orchestration.md
│       ├── institutional-truth.md
│       ├── domain-agents.md
│       ├── monitoring.md
│       └── documents.md
├── src/
│   ├── backend/                 ← Python/FastAPI
│   │   ├── main.py
│   │   ├── config/
│   │   ├── db/
│   │   │   ├── models/
│   │   │   └── migrations/
│   │   ├── routes/
│   │   ├── services/
│   │   ├── agents/
│   │   └── voice/
│   └── frontend/                ← React/TypeScript
│       ├── src/
│       │   ├── components/
│       │   ├── pages/
│       │   ├── hooks/
│       │   ├── services/
│       │   └── types/
│       └── package.json
├── electron/                    ← Electron shell
│   ├── main.ts
│   └── preload.ts
├── tests/
│   ├── backend/
│   └── frontend/
└── data/                        ← local runtime data (gitignored)
    ├── app.db
    ├── logs/
    ├── artifacts/
    ├── backups/
    ├── cache/
    └── config/
```

## Rules (MANDATORY)

1. **Read the relevant coding pack** in `docs/coding-packs/` BEFORE implementing any component
2. **Read `docs/mvp-scope.md`** to know if a component is Real, Stub, or Future
3. **Use `docs/unified-ddl.sql`** as the single source of truth for all tables — never invent schema
4. **Run tests after every implementation**: `cd src/backend && python -m pytest tests/ -v`
5. **Never claim 100% completion** — show output of `grep`, `find`, `pytest` as evidence
6. **Max 8 files per task** — if a task requires more, decompose it
7. **Every new table** needs an Alembic migration file
8. **Every API endpoint** needs at least 1 test
9. **LLM calls** must use retry/fallback as defined in `docs/tech-stack.md`
10. **Never hardcode** API keys, paths, or ports — use config files
11. **Source of truth precedence:** Em caso de conflito entre documentos, a ordem de precedência é: unified-ddl.sql > state-machines.md > api-contracts.md > coding-packs > glossary.md > qualquer outro arquivo
12. **Nunca ler archive/** — contém documentos obsoletos que contradizem os operacionais. Nunca criar novos arquivos de estado, contrato ou glossário fora dos canônicos listados em BASELINE_V1_MANIFEST.md.

## Milestones (implementation order)
M0 (Doc Freeze) → M1 (Foundation) → M2 (Core Data) → M3 (Context) → M4 (Voice) → M5 (Orchestration) → M6 (Institutional Truth) → M7 (Executive Coordination) → M8 (Domains) → M9 (Governance) → M10 (Monitoring) → M11 (Documents) → M12 (Pilot)

## Current Status
Phase: M0 — Documentation freeze and setup
Next: M1 — Local Product Foundation
