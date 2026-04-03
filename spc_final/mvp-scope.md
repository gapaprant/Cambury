# SPEC-IMPL-001C — MVP Scope (Priorização de Componentes)

**Status:** FROZEN V1
**Data:** 02/04/2026
**Regra:** Componentes "Real" devem funcionar end-to-end. "Stub" devem existir como interface/contrato mas retornar placeholder. "Futuro" não existem no MVP.

---

## Mapeamento Componente → Milestone → Categoria

### Infraestrutura e Fundação

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Electron shell + lifecycle | M1 | ✅ Real | Instalador, startup, shutdown, splash |
| FastAPI backend + health checks | M1 | ✅ Real | 6 endpoints de health/system |
| SQLite + migrations (Alembic) | M1 | ✅ Real | Tabelas de Phase 0 |
| Estrutura de diretórios | M1 | ✅ Real | Conforme spec_002 |
| Sistema de logging (structlog) | M1 | ✅ Real | 4 log files rotativos |
| Config (app_config + runtime_config) | M1 | ✅ Real | JSON files |
| Backup automático de DB | M1 | ✅ Real | Cópia diária simples |

### Conversas e Navegação

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| 4 workspaces fixas | M2 | ✅ Real | Bootstrap seeds |
| CRUD de conversas | M2 | ✅ Real | Título obrigatório, status |
| Mensagens (persistência + listagem) | M2 | ✅ Real | — |
| Busca por guia + título (FTS5) | M2 | ✅ Real | — |
| Anexos (upload, listagem, remoção lógica) | M2 | ✅ Real | — |
| Trilha de auditoria básica | M2 | ✅ Real | audit_log |
| UI React: sidebar, lista, painel | M2 | ✅ Real | Layout mínimo funcional |

### Persistência de Contexto

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Session Ledger (CRUD) | M3 | ✅ Real | — |
| Lifecycle events (create, resume, pause, close) | M3 | ✅ Real | — |
| Compaction events | M3 | 🟡 Stub | Grava mas não compacta inteligentemente; compactação manual simples |
| Resume bundle | M3 | 🟡 Stub | Monta bundle básico (último ledger + fatos); sem lógica avançada |
| Agent learnings | M3 | 🔲 Futuro | Só em M8+ com domínios reais |
| Post-session learning extractor | M3 | 🔲 Futuro | — |

### Voz

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Push-to-talk (captura áudio) | M4 | ✅ Real | WAV 16kHz mono |
| faster-whisper STT | M4 | ✅ Real | Modelo small, pt forçado |
| Normalização de transcrição | M4 | ✅ Real | Regex básico (espaços, pontuação) |
| Intent classification (LLM) | M4 | ✅ Real | Claude Sonnet, 9 intents |
| Resolução de conversa por voz | M4 | ✅ Real | Criar nova ou retomar existente |
| Sugestão de título (LLM) | M4 | ✅ Real | — |
| Confirmação curta | M4 | ✅ Real | Quando confiança < 0.7 |
| Persistência de voice events + transcripts + intents | M4 | ✅ Real | — |

### Orquestração e Workflows

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Voice Execution Envelope | M5 | ✅ Real | — |
| Classificação orquestral (7 tipos) | M5 | ✅ Real | LLM-based |
| Criação de workflow por voz | M5 | ✅ Real | 6 tipos |
| Workflow seed | M5 | ✅ Real | — |
| Árvore inicial de tarefas | M5 | 🟡 Stub | Cria 3-5 tarefas template por tipo; sem execução automática |
| Workflow states + transitions | M5 | ✅ Real | 7 estados |
| Resposta incremental (3 camadas) | M5 | ✅ Real | ack + progress + checkpoint |
| Intervenção do usuário (pausar, retomar) | M5 | ✅ Real | — |
| Fairness e prioridade | M5 | 🔲 Futuro | Sem concorrência real no MVP (1 workflow ativo por vez) |
| Lock por conversa | M5 | 🔲 Futuro | — |

### Base de Verdade Institucional

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Tabela de fatos institucionais | M6 | ✅ Real | CRUD + busca FTS5 |
| Ingestão de documentos-fonte | M6 | 🟡 Stub | Upload manual; parsing básico de texto (sem OCR avançado) |
| Precedência de fontes | M6 | 🟡 Stub | Regra simples: confirmado > probable > disputed |
| Views derivadas | M6 | 🟡 Stub | Ficha institucional e ficha de curso como JSON gerado sob demanda |
| Cruzamento institucional transversal | M6 | 🟡 Stub | Busca FTS nos fatos; sem agent dedicado — LLM faz inline |
| Conflito entre fatos | M6 | ✅ Real | Campo conflict_notes + confidence |

### Coordenação Cognitiva

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Agent Orchestrator (classificar + rotear) | M7 | ✅ Real | Decide tipo de resposta |
| Deep Agent Executivo Roteador | M7 | ✅ Real | Produz Execution Routing Plan via LLM |
| Executive Routing Pack → Plan | M7 | ✅ Real | — |
| Domain Assignment Pack | M7 | ✅ Real | Delegação formal |
| Domain Result Package | M7 | ✅ Real | Retorno formal |
| Checkpoints executivos (5 tipos) | M7 | ✅ Real | — |
| Taxonomia de casos (4 tipos) | M7 | ✅ Real | simple/composite/sensitive/longitudinal |
| Estratégias de decomposição (4) | M7 | 🟡 Stub | Implementar apenas Linear e Paralela; Exploratória e Longitudinal → fallback para Linear |

### Domínios Primários

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| **Domínio Concorrência** (completo) | M8 | 🟡 Stub MVP | 1 agent LLM que recebe Assignment Pack + fatos do DB + input do Giuseppe e retorna Result Package. Sem subagents separados. Sem web crawling — dados manuais. |
| **Domínio Regulação e Normas** (completo) | M8 | 🟡 Stub MVP | Mesmo padrão: 1 agent LLM. Fatos regulatórios inseridos manualmente. |
| **Domínio Diagnóstico e Planejamento** (completo) | M8 | ✅ Real | Prioridade — é o domínio mais usado no dia a dia do Giuseppe |
| **Domínio Mercado Educacional** | — | 🔲 Futuro | Absorvido por Concorrência + Diagnóstico no MVP |
| Subagents internos por domínio (35+) | M8 | 🔲 Futuro | No MVP, cada domínio é 1 LLM call com prompt rico, não 6 subagents |
| Skills por domínio (30+) | M8 | 🔲 Futuro | No MVP, lógica inline no prompt do domínio |

### Governança e Verificação

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Verificação multiestágio (5 stages) | M9 | 🟡 Parcial | Implementar Stage 2 (domain output) e Stage 4 (pre-writing). Stages 1, 3, 5 como pass-through no MVP |
| Aderência institucional | M9 | ✅ Real | Busca em institutional_facts antes de redigir |
| HITL (human-in-the-loop) | M9 | ✅ Real | Para verification_status=red ou sensitive_case |
| Política de bloqueio/liberação | M9 | ✅ Real | Red bloqueia redação conclusiva |

### Redação Executiva

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Redação como finalizador | M7/M9 | ✅ Real | 1 LLM call com context pack + perfil |
| 3 formatos (chat, note, document) | M7 | ✅ Real | — |
| Revisão formal interna | M9 | 🟡 Stub | Checklist simples, não LLM-review separado |
| Bloqueio por red verification | M9 | ✅ Real | — |
| Subagents de redação (6) | — | 🔲 Futuro | No MVP, 1 prompt rico faz tudo |

### Monitoramento

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Monitoring threads (CRUD) | M10 | 🟡 Stub | Giuseppe cria thread manual; sistema registra |
| Alertas executivos | M10 | 🟡 Stub | Giuseppe insere dados; sistema compara com fatos e gera alerta |
| Coleta automática (web scraping/APIs) | M10 | 🔲 Futuro | No MVP, toda coleta é manual |
| Abertura automática de casos | M10 | 🔲 Futuro | — |

### Documentos e Entrega

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Templates documentais (despacho, ofício, parecer, relatório, plano) | M11 | ✅ Real | Markdown templates convertidos para PDF/DOCX |
| Renderização PDF | M11 | ✅ Real | WeasyPrint |
| Exportação DOCX | M11 | 🟡 Stub | Markdown → pandoc → DOCX |
| Versionamento de documentos | M11 | ✅ Real | document_versions |
| Impressão | M11 | ✅ Real | Via PDF |
| Perfil executivo adaptativo | M11 | 🟡 Stub | 5-10 traços fixos iniciais; sem aprendizado automático |

### Piloto e Hardening

| Componente | Milestone | Categoria | Notas |
|-----------|-----------|-----------|-------|
| Testes de falha e recuperação | M12 | ✅ Real | — |
| Backup verificado | M12 | ✅ Real | — |
| Performance baseline | M12 | ✅ Real | — |
| Runbook de operação | M12 | ✅ Real | — |

---

## Resumo Quantitativo

| Categoria | Quantidade | % do total |
|-----------|-----------|------------|
| ✅ Real | 52 componentes | 55% |
| 🟡 Stub | 22 componentes | 23% |
| 🔲 Futuro | 21 componentes | 22% |
| **Total** | **95** | 100% |

## Decisão Arquitetural Chave do MVP

> **No MVP, cada "domínio" é 1 chamada LLM com prompt rico, não uma árvore de subagents.**

Os 35+ subagents e 30+ skills definidos nas specs são design pós-MVP. No MVP:
- Domínio Concorrência = 1 função Python que monta prompt + context → chama Claude → retorna Domain Result Package
- Domínio Regulação = mesmo padrão
- Domínio Diagnóstico = mesmo padrão (mas com mais profundidade porque é o mais usado)
- Verificação = 1 função Python que recebe results → chama Claude com checklist de verificação → retorna status
- Redação = 1 função Python que recebe results verificados + perfil → chama Claude → retorna output formatado

Isso reduz 77+ componentes cognitivos para ~8-10 funções Python reais + contratos tipados entre elas. Expansão para subagents acontece quando o MVP provar valor.
