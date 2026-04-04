# AUDITORIA NÍVEL 10 — SPEC-004 + SPEC-005 (Acumulada com Corpus Completo)

**Corpus total auditado:**
- SPEC-001 — Visão de produto (auditada na rodada 1)
- SPEC-002 — Phase 0, Phase 1, Agents, Context Persistence (auditada na rodada 2)
- SPEC-003 — Phase 2: Voz + Voz-Orquestrador (auditada na rodada 2)
- **SPEC-004 — Workflows por voz, ligação voz→Executivo, resposta incremental (NOVO)**
- **SPEC-005 — Deep Agent Executivo, domínios transversais, checkpoints, Redação Executiva (NOVO)**

**Data:** 02 de abril de 2026
**Perspectiva:** 13 departamentos de agentes de codificação
**Foco:** O que estes 2 novos documentos resolvem, o que introduzem de novo, o que ainda bloqueia, e qual é a codificabilidade REAL do corpus acumulado

---

## PARTE A — O QUE ESTES DOCUMENTOS RESOLVEM

Os spec_004 e spec_005 atacam um dos problemas mais graves identificados nas auditorias anteriores: **a lacuna entre "o que o sistema entende" (voz/intenção) e "o que o sistema faz" (trabalho cognitivo coordenado)**. Essa ponte agora existe.

### Avanços concretos

| Item que faltava | Status agora | Onde está |
|---|---|---|
| Workflows eram conceituais, sem tipos concretos | ✅ 6 tipos definidos com exemplos de fala | spec_004 |
| Não se sabia quando criar workflow vs. responder direto | ✅ Regras explícitas de decisão | spec_004 |
| Workflow nascia sem estrutura mínima | ✅ Workflow Seed + árvore inicial de tarefas | spec_004 |
| Deep Agent Executivo era um nome sem spec | ✅ Papel, entradas, saídas, taxonomia de casos | spec_005 |
| Não havia contrato Executivo→Domínio | ✅ Domain Assignment Pack + Domain Result Package | spec_005 |
| Verificação era vaga | ✅ Domínios transversais formalizados com entradas/saídas | spec_005 |
| Redação Executiva era conceito solto | ✅ Finalizer formalizado com bloqueio, formatos, revisão | spec_005 |
| Não se sabia como o usuário vê progresso | ✅ 3 camadas de resposta incremental + 5 tipos de checkpoint | spec_004 + spec_005 |
| Estados de workflow indefinidos | ✅ 7 estados com transições | spec_004 |
| Intervenção do usuário durante workflow não existia | ✅ Pausar, retomar, redirecionar, pedir parcial | spec_004 |

**Veredicto: estes dois documentos são os mais operacionalmente úteis do corpus até agora.** Eles transformam filosofia em mecânica. Pela primeira vez, um agente de codificação consegue enxergar o ciclo completo: fala → intenção → workflow → domínios → verificação → redação → entrega.

---

## PARTE B — ATUALIZAÇÃO DOS BLOQUEANTES ORIGINAIS

### Quadro acumulado de evolução (7 bloqueantes da SPEC-001)

| Bloqueante | Rodada 1 | Rodada 2 | Agora | Nota |
|-----------|---------|---------|-------|------|
| C01 Tech stack | ⛔ 0% | 🟡 40% | 🟡 40% | Nenhum avanço. spec_004/005 não tocam em tecnologia. |
| C02 Contratos entre componentes | ⛔ 0% | 🟢 75% | 🟢 90% | Domain Assignment Pack e Domain Result Package fecham o último gap de contratos entre agentes. Falta apenas Frontend↔Backend request/response schemas. |
| C03 Schema de banco | ⛔ 0% | 🟢 70% | 🟡 65%* | Os novos contratos (Workflow Seed, Assignment Pack, Result Package, checkpoints, writing packages) introduzem ~10 novos objetos persistíveis SEM DDL. O gap de DDL CRESCEU. |
| C04 LLM integração | ⛔ 0% | ⛔ 10% | ⛔ 10% | ZERO avanço. Continua sendo o bloqueante mais grave. |
| C05 Agentes definidos | ⛔ 0% | 🟢 80% | 🟢 92% | O Executivo, verificação e redação agora têm spec operacional real. Faltam system prompts e token budgets. |
| C06 Voz pipeline | ⛔ 0% | 🟢 85% | 🟢 90% | A ponte voz→workflow agora é clara. Engine concreta ainda falta. |
| C07 API endpoints | ⛔ 0% | 🟢 80% | 🟢 80% | Nenhum endpoint novo listado nestas specs. Os novos contratos entre agentes são internos. |

*C03 piorou de 70% para 65% porque a quantidade de objetos sem DDL cresceu mais rápido que a quantidade com DDL.*

---

## PARTE C — NOVOS BLOQUEANTES E FALHAS CRÍTICAS

### ⛔ NC-05 — Explosão de objetos persistíveis sem DDL

Os spec_004 e spec_005 introduzem os seguintes novos objetos que "devem ser persistidos":

| Objeto | Campos conceituais definidos? | DDL SQL? |
|--------|------------------------------|----------|
| Workflow (expandido com seed) | ✅ 14+ campos obrigatórios | ❌ |
| Workflow Seed | ✅ 8 campos | ❌ |
| Executive Routing Pack | ✅ 12 campos | ❌ |
| Execution Routing Plan | ✅ 9 campos | ❌ |
| Domain Assignment Pack | ✅ 12 campos | ❌ |
| Domain Result Package | ✅ 14 campos | ❌ |
| Checkpoint executivo | ✅ 10 campos | ❌ |
| Mensagem incremental | ✅ 7 campos | ❌ |
| Writing Request (input) | ✅ 10 campos | ❌ |
| Writing Output | ✅ 8 campos | ❌ |

Somando com os 7 objetos da spec_002__1_ (session_ledgers, workflow_checkpoints, etc.) também sem DDL, agora existem **17 objetos persistíveis conceituais sem tabela SQL definida**.

Um agente de banco de dados que leia todo o corpus encontra:
- 10 tabelas com DDL pronto (Phase 1 + Phase 2)
- 17 objetos descritos em texto narrativo sem DDL
- 3 tabelas mencionadas por nome sem qualquer detalhe (Phase 0)

**Isso é uma bomba-relógio de inconsistência.** Cada agente de codificação vai inventar uma estrutura de tabela diferente para esses 17 objetos.

---

### ⛔ NC-06 — LLM é o elefante na sala: 5 specs e zero definição

Ao longo dos 5 documentos, o sistema agora possui:
- 1 Deep Agent Executivo que "classifica casos, seleciona domínios, define estratégia"
- 6 Deep Agents de domínio que "analisam, coletam, sintetizam"
- 1 Verificador que "mede suficiência, confiança, conflito"
- 1 Redação Executiva que "gera documentos no perfil do Giuseppe"
- 35+ subagents
- 1 Intent Interpretation Layer que "classifica intenção semanticamente"

**Cada um desses componentes PRECISA de chamadas a LLM para funcionar.** Mas até agora:
- ❌ Nenhum LLM provider escolhido
- ❌ Nenhum modelo especificado
- ❌ Nenhum system prompt escrito
- ❌ Nenhum token budget definido
- ❌ Nenhuma estratégia de prompt engineering
- ❌ Nenhum fallback/retry
- ❌ Nenhum custo estimado
- ❌ Nenhuma decisão streaming vs. batch

A spec está construindo uma pirâmide de 5 andares sobre um alicerce que literalmente não existe. Cada "decide", "classifica", "sintetiza", "analisa" implicitamente assume uma chamada LLM que ninguém especificou.

---

### ⛔ NC-07 — Complexidade cumulativa atinge nível crítico para MVP

Inventário de componentes cognitivos no corpus completo:

| Camada | Componentes | Contratos envolvidos |
|--------|------------|---------------------|
| Kernel de orquestração | 1 | Filas, locks, prioridades |
| Agent Orchestrator | 1 | Voice Execution Envelope → classificação |
| Deep Agent Executivo | 1 | Executive Routing Pack → Execution Routing Plan |
| Deep Agents de domínio | 6 | Domain Assignment Pack → Domain Result Package (×6) |
| Subagents por domínio | 35+ | Contratos internos não definidos |
| Skills por domínio | 30+ | Interface de loading não definida |
| Verificador transversal | 1 | findings → verification status |
| Cruzamento institucional | 1 | findings → alignment status |
| Redação Executiva | 1 | Writing Request → Writing Output |
| **Total** | **77+** | **~20 contratos formais** |

Para um MVP single-user, isso equivale a construir um departamento inteiro de uma empresa antes de ter o primeiro cliente. **Não existe priorização de quais desses 77 componentes são essenciais para o MVP funcionar.**

A spec define Phases 0-11, e define esses 77 componentes, mas em NENHUM LUGAR faz o mapeamento: "Na Phase X, os seguintes componentes devem existir; os demais são stubs."

---

### ⚠️ NC-08 — Contratos de agente estão em texto narrativo, não em schema executável

Os contratos (Domain Assignment Pack, Domain Result Package, etc.) são listados como "campos conceituais recomendados" com nomes de campos. Mas:

- Não são JSON Schema
- Não são dataclasses Python
- Não são TypedDict
- Não têm tipos explícitos (string? int? float? list? optional?)
- Não têm validação

Um agente que leia "confidence_score" não sabe se é float 0-1, int 0-100, ou string "high/medium/low". Um agente que leia "findings" não sabe se é string, lista de strings, ou lista de objetos com subcampos.

**Ação necessária:** Converter pelo menos os 5 contratos centrais (Routing Pack, Routing Plan, Assignment Pack, Result Package, Writing Request) em JSON Schema ou dataclass Python com tipos explícitos.

---

### ⚠️ NC-09 — Workflows têm estados mas não têm state machine formal

A spec_004 define 7 estados de workflow:
`created → queued → running → waiting_confirmation → paused → completed → failed`

Mas não define:
- Todas as transições válidas (pode ir de `paused` para `failed`? de `running` para `created`?)
- Eventos que causam transições
- Guards/condições para transições
- Timeout por estado
- O que acontece com tarefas-filhas quando o workflow pai muda de estado

Para LangGraph, isso precisa ser um grafo explícito de estados com edges condicionais. Para qualquer framework, precisa de uma state machine diagram.

---

### ⚠️ NC-10 — Os 6 workflows têm exemplos de task tree mas são apenas para 2 tipos

A spec_004 fornece árvore de tarefas exemplo para:
- `planning_workflow` (6 tarefas)
- `competitor_analysis_workflow` (6 tarefas)

Os outros 4 tipos (`regulatory_analysis`, `document_preparation`, `institutional_diagnosis`, `monitoring_case`) NÃO possuem árvore de tarefas exemplo. Um agente não sabe quantas tarefas criar nem quais dependências estabelecer para esses tipos.

---

### ⚠️ NC-11 — Estratégia de decomposição cognitiva sem regra de seleção

A spec_005 define 4 estratégias (Linear, Paralela, Exploratória, Monitoramento) com exemplos. Mas não define regras para quando usar qual. "Usar quando um domínio depende claramente do resultado do anterior" é critério humano, não critério implementável. Um agente precisa de: "SE workflow_type == regulatory E entities contém norma_específica ENTÃO Linear; SE workflow_type == planning E entities contém concorrente ENTÃO Paralela."

---

## PARTE D — CONSISTÊNCIA CRUZADA COM DOCUMENTOS ANTERIORES

### CC-09 — Modelo de mensagem incremental vs. mensagens da Phase 1

A spec_004 define um novo modelo de "mensagem incremental" com campos:
`conversation_id, workflow_id, message_type (ack, progress, checkpoint, review_request, partial_output), executive_summary, next_step_hint, requires_user_action, created_at`

A Phase 1 (spec_002__1_) define mensagens com campos:
`id, conversation_id, role, raw_text, normalized_text, created_at, attachment_refs, message_order`

**Esses dois modelos não são compatíveis.** Uma mensagem incremental não tem `role`, `raw_text`, `message_order`. Uma mensagem da Phase 1 não tem `message_type`, `workflow_id`, `next_step_hint`.

**Pergunta sem resposta:** Mensagens incrementais são um tipo especial de message da Phase 1? Ou são objetos separados? Se são o mesmo, faltam campos no DDL da Phase 1. Se são diferentes, falta DDL para mensagens incrementais.

### CC-10 — workflow_id referenciado em 4 specs sem DDL da tabela workflows

O campo `workflow_id` aparece em: spec_003 (orchestrator_decisions), spec_004 (workflow template, seeds, routing packs, checkpoints), spec_005 (assignment packs, result packages, writing requests). Todas essas tabelas referenciam `workflow_id` como foreign key implícita. Mas a tabela `workflows` nunca recebeu DDL.

### CC-11 — Checkpoint executivo (spec_005) vs. workflow checkpoint (spec_002__1_)

A spec_002__1_ menciona `workflow_checkpoints` como tabela de persistência de contexto.
A spec_005 define 5 tipos de checkpoint executivo (`initial`, `analytical`, `verification`, `draft`, `final`) com campos conceituais.

São a mesma coisa? O checkpoint de contexto (para compactação de memória) é diferente do checkpoint executivo (para entrega parcial ao usuário)? Se são diferentes, são duas tabelas? Se são a mesma, os campos precisam ser reconciliados.

### CC-12 — "Regra de separação" afirmada em 3 lugares com framing diferente

- spec_002: "pesquisa e análise ficam nos domínios primários; validação fica no verificador; forma final fica na redação."
- spec_003: "A camada de voz decide ONDE a solicitação entra. O Agent Orchestrator decide COMO será tratada."
- spec_005: "O Agent Orchestrator decide que existe trabalho cognitivo. O Deep Agent Executivo decide como será estruturado."

As três estão corretas e complementares, mas um agente que leia apenas uma delas pode não entender a cadeia completa: Voz → Orchestrator → Executivo → Domínios → Verificação → Redação. **Nenhum documento contém a cadeia completa em um diagrama ou sequência unificada.**

---

## PARTE E — ANÁLISE ATUALIZADA DE CODIFICABILIDADE

### Por departamento (acumulado)

| Departamento | Rodada 1 | Rodada 2 | Agora | Nota |
|---|---|---|---|---|
| Dept 1 — Arquitetura | ⛔ | 🟡 | 🟢 Conceitual | A arquitetura está completa CONCEITUALMENTE. Falta instanciação técnica. |
| Dept 2 — Frontend | ⛔ | 🟡 | 🟡 | Nada novo para frontend. Wireframes, schemas HTTP continuam ausentes. |
| Dept 3 — Backend | ⛔ | 🟡 | 🟡 | Framework ainda indefinido. Endpoints spec_004/005 são internos. |
| Dept 4 — Database | ⛔ | 🟢 | ⚠️ Piorou | Gap de DDL cresceu de 7 para 17+ objetos sem tabela. |
| Dept 5 — Voice | ⛔ | 🟡 | 🟢 | Ponte voz→workflow clarificada. Engine concreta ainda falta. |
| Dept 6 — AI/LLM | ⛔ | ⛔ | ⛔ | 5 specs e ZERO definição de LLM. Bloqueante mais grave. |
| Dept 7 — Documents | ⛔ | ⛔ | 🟡 | Redação Executiva especificada, mas templates concretos ausentes. |
| Dept 8 — Monitoring | ⛔ | 🟡 | 🟡 | `monitoring_case_workflow` definido mas mecanismo de coleta ausente. |
| Dept 9 — Legal | ⛔ | 🟡 | 🟡 | Nada novo de substância para o motor jurídico. |
| Dept 10 — Orchestration | ⛔ | 🟡 | 🟢 Conceitual | Cadeia completa existe conceptualmente. Falta state machine formal. |
| Dept 11 — Security | ⛔ | 🟡 | 🟡 | Nada novo. |
| Dept 12 — Testing | ⛔ | 🟢 | 🟢 | Critérios de aceite por spec continuam sólidos. |
| Dept 13 — DevOps | ⛔ | 🟡 | 🟡 | Nada novo. |

### Por fase

| Fase | Rodada 2 | Agora | Mudança |
|------|---------|-------|---------|
| Phase 0 | 7/10 | 7/10 | Sem mudança |
| Phase 1 | 7/10 | 7/10 | Sem mudança |
| Phase 2 (voz) | 5/10 | 6/10 | Ponte voz→workflow +1 |
| Phase 2 (orquestrador) | 4/10 | 5.5/10 | Executivo detalhado +1.5 |
| Phase 3 | 2/10 | 2/10 | Sem mudança |
| Phase 4 | 3/10 | 3/10 | Memória não tocada |
| Phase 5 | 2/10 | 2/10 | Perfil não tocado |
| Phase 6 | 3/10 | 5/10 | Workflows formalizados +2 |
| Phase 7 | 1/10 | 3/10 | Redação Executiva formalizada +2 |
| Phase 8 | 2/10 | 2.5/10 | monitoring_case_workflow +0.5 |
| Phase 9 | 2/10 | 2/10 | Sem mudança |
| Phase 10-11 | 1/10 | 1/10 | Sem mudança |

---

## PARTE F — O DIAGNÓSTICO ESTRATÉGICO

Gabriel, depois de auditar 5 specs (~180KB de texto), a imagem que se forma é clara:

### O que está excelente

**A arquitetura conceitual é de nível sênior.** A separação entre Kernel operacional, Orchestrator, Executivo, Domínios, Verificação transversal, Cruzamento institucional e Redação como finalizador é uma arquitetura multi-agente genuinamente bem pensada. A maioria dos projetos AI nunca chega nesse nível de clareza arquitetural.

**Os contratos entre componentes são sofisticados.** Executive Routing Pack → Execution Routing Plan → Domain Assignment Pack → Domain Result Package → Writing Request → Writing Output forma uma pipeline de dados formais que permite rastreabilidade real. Isso é raro.

**A política de interação com o usuário é humana.** As 3 camadas de resposta incremental, os 5 tipos de checkpoint, e as regras de "nunca entregar conclusão parcial como se fosse final" mostram consciência real de UX executiva.

### O que está perigosamente desequilibrado

**O corpus tem 180KB de "o que fazer" e 0KB de "com que ferramentas".** É como ter o projeto arquitetônico completo de um hospital — salas, fluxos de pacientes, protocolos médicos, hierarquia — sem especificar se será construído em alvenaria, aço, madeira ou container.

Os 3 itens ausentes mais destrutivos, por ordem:

1. **LLM Provider + Modelos + Prompts.** Todo o edifício cognitivo depende disso. Escolher Claude vs. GPT vs. Local muda TUDO: custo, latência, formato de prompt, tool use, structured output, streaming, context window.

2. **DDL unificado.** 10 tabelas com DDL + 17 objetos sem DDL + 3 tabelas só com nome = caos de dados. Um agente que tente criar migration vai produzir schema Frankenstein.

3. **Priorização MVP dos 77 componentes.** Sem saber "no MVP, apenas Roteador + Verificador + Redação existem como agentes reais; os 6 domínios são funções Python simples", um agente de codificação vai tentar implementar 77 componentes em paralelo.

---

## PARTE G — OS 5 DOCUMENTOS QUE FALTAM

Para levar o corpus de 4.5/10 para 7.5/10 (suficiente para iniciar sprints reais), os seguintes documentos são necessários:

### Doc 1 — SPEC-001-TECH-STACK.md (30-60 min)
Declaração formal de: Python 3.12, FastAPI, Electron 28+, React 18, TS 5, SQLite 3.45+, LangGraph 0.2+, faster-whisper small, ChromaDB embedded, Claude Sonnet 4 (classificação) + Claude Opus 4 (geração), porta 8741, UUID v4, código em inglês, UI em pt-BR, Electron Builder para empacotamento.
**Desbloqueia: TODOS os 13 departamentos.**

### Doc 2 — SPEC-001-UNIFIED-DDL.md (2-4 horas)
DDL SQL completo de TODAS as tabelas em um único arquivo, organizado por Phase. Incluindo as 17 tabelas que hoje são apenas "campos conceituais". Com tipos, FKs, indexes, FTS5, constraints.
**Desbloqueia: Database, Backend, Testing.**

### Doc 3 — SPEC-001-LLM-INTEGRATION.md (2-3 horas)
Para cada componente que faz chamada LLM: qual modelo usa, system prompt base, formato de input/output, budget de tokens, retry strategy, streaming vs. batch, fallback. Começando pelo menos com: Intent Interpreter, Deep Agent Executivo, Verificador, Redação Executiva.
**Desbloqueia: AI/LLM, Orchestration, Phase 2+.**

### Doc 4 — SPEC-001-MVP-SCOPE.md (1-2 horas)
Lista explícita: "Para o MVP funcional, os seguintes componentes existem como implementação real: [lista]. Os seguintes existem como stubs simples: [lista]. Os seguintes NÃO existem no MVP: [lista]." Mapeamento componente→Phase.
**Desbloqueia: TODOS — permite iniciar sem paralisia de escopo.**

### Doc 5 — SPEC-001-CONTRACTS-TYPED.md (2-3 horas)
Os 5 contratos centrais (Routing Pack, Routing Plan, Assignment Pack, Result Package, Writing Request) como JSON Schema ou Python dataclass com tipos explícitos. Inclui o modelo de mensagem incremental reconciliado com o modelo de mensagem da Phase 1.
**Desbloqueia: Backend, Orchestration, Testing.**

---

## SCORES FINAIS (CORPUS COMPLETO APÓS 5 SPECS)

| Dimensão | Score |
|----------|-------|
| Visão de produto | 9.5/10 |
| Arquitetura conceitual | 9/10 |
| Contratos entre componentes | 7/10 |
| Definição de agentes | 8/10 |
| Pipeline de voz | 7.5/10 |
| Workflows e orquestração | 7/10 |
| Tech stack e infraestrutura | 2/10 |
| Schema de dados unificado | 3/10 |
| Integração LLM | 0.5/10 |
| Priorização MVP | 1/10 |
| **Codificabilidade global ponderada** | **4.5/10** |

A nota global não subiu de 4.5 porque os spec_004/005 aprofundaram a camada conceitual (que já era forte) sem atacar as lacunas técnicas (que continuam sendo o gargalo). É como pintar mais andares na planta do prédio enquanto a fundação ainda não tem cimento.

**Os 5 documentos técnicos sugeridos acima, estimados em ~1.5 dia de trabalho, levam o score para 7.5/10 e permitem iniciar os primeiros sprints reais.**
