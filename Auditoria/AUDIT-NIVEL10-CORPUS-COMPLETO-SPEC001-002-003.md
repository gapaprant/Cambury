# AUDITORIA NÍVEL 10 — SPEC-001 + SPEC-002 + SPEC-003 (Corpus Completo)

**Corpus auditado:**
- SPEC-001 — Sistema Executivo Local para Gestão de Centro Universitário (Parte 1 — auditada anteriormente)
- SPEC-002 — Continuação da Arquitetura e Detalhamento do MVP (2 versões)
- SPEC-003 — Continuação da Persistência de Contexto e Orquestração Agêntica (3 cópias idênticas)

**Data da auditoria:** 02 de abril de 2026
**Perspectiva:** Equipe completa de 13 departamentos de agentes de codificação
**Método:** Auditoria cruzada de consistência entre TODOS os documentos, com rastreamento de resolução dos 7 bloqueantes originais da SPEC-001

---

## ÍNDICE

1. Mapa documental e problemas de organização
2. Resolução dos 7 bloqueantes críticos da SPEC-001
3. Novos bloqueantes críticos encontrados
4. Falhas graves de consistência cruzada
5. Falhas de ambiguidade que geram divergência entre agentes
6. Análise atualizada por departamento de agente
7. Análise de codificabilidade por fase
8. Checklist consolidado de itens ainda pendentes
9. Recomendações de ação

---

## 1. MAPA DOCUMENTAL E PROBLEMAS DE ORGANIZAÇÃO

### 1.1 Inventário real dos arquivos

| Arquivo | Tamanho | Conteúdo único | Status |
|---------|---------|----------------|--------|
| SPEC-001 (docx) | ~28KB | Background, Requirements, Method, Implementation, Milestones, Gathering Results | Documento-raiz |
| spec_002.md | 27KB | Phase 0 detalhada + Arquitetura Deep Agents/LangGraph | ⚠️ VERSÃO OBSOLETA |
| spec_002__1_.md | 49KB | Tudo do spec_002 + Phase 1 detalhada + Context Persistence Protocol | ✅ Versão canônica |
| spec_003.md | 34KB | Lifecycle events (overlap com spec_002__1_) + Phase 2 detalhada + Voz-Orquestrador | ✅ Versão canônica |
| spec_003__1_.md | 34KB | Idêntico ao spec_003.md (md5 igual) | ❌ Duplicata |
| spec_003__2_.md | 34KB | Idêntico ao spec_003.md (md5 igual) | ❌ Duplicata |

### 1.2 Problemas de organização documental

#### ⛔ DOC-01 — Documento obsoleto misturado com documento corrente

O `spec_002.md` (27KB) é um SUBCONJUNTO do `spec_002__1_.md` (49KB). A única diferença: o primeiro marca Phase 1 como "A aprofundar na continuação desta SPEC", enquanto o segundo contém Phase 1 completa + Context Persistence Protocol. Um agente que pegar o arquivo errado vai trabalhar com uma spec incompleta.

**Ação necessária:** Remover `spec_002.md` do corpus ou renomeá-lo como `spec_002_OBSOLETO.md`. Manter apenas `spec_002__1_.md` como canônico.

#### ⛔ DOC-02 — Três cópias idênticas da SPEC-003

Os três arquivos spec_003 têm hash MD5 idêntico (`49c2bf6088055c97ae667e43058c1856`). Agentes ou humanos podem perder tempo tentando encontrar diferenças que não existem.

**Ação necessária:** Manter apenas 1 cópia.

#### ⛔ DOC-03 — Todos os arquivos estão truncados no início

Todos os .md começam com texto cortado: `"esktop com Electron;"` (faltando "D" de "Desktop") na spec_002, e `"registra contexto base usado na abertura."` na spec_003. Isso indica que a exportação cortou o início dos documentos.

**Risco:** Podem faltar cabeçalhos, versionamento, índice, ou seções introdutórias inteiras que contextualizem o documento para agentes.

**Ação necessária:** Verificar se há conteúdo perdido antes do ponto de corte e restaurar os headers.

#### ⛔ DOC-04 — Sobreposição de conteúdo entre spec_002__1_ e spec_003

O final da spec_002__1_ (Context Persistence Protocol → lifecycle events → compaction → acceptance criteria) se repete quase integralmente no início da spec_003 (de ConversationResume em diante). São ~4KB de texto duplicado.

**Risco para agentes:** Se ambos documentos forem carregados no contexto, o agente pode tratar como duas versões diferentes de regras que na verdade são idênticas, ou pode tentar "reconciliar" diferenças inexistentes.

**Ação necessária:** Definir ponto de corte limpo. A spec_003 deveria iniciar APÓS o material já coberto na spec_002__1_.

#### ⚠️ DOC-05 — Ausência de sistema de versionamento

Nenhum documento possui: número de versão, changelog, data de última alteração, ou indicação de "este documento substitui a versão X". Para agentes que precisam saber "qual é a verdade atual", isso é perigoso.

**Ação necessária:** Adicionar header padronizado a cada documento com: versão, data, autor, status (draft/review/approved), e relação com outros documentos.

#### ⚠️ DOC-06 — Ausência de índice/mapa mestre

Não existe um documento-índice que diga: "o corpus da SPEC-001 é composto por: Parte 1 (visão), Parte 2A (Phase 0-1 + Agents + Context), Parte 2B (Phase 2 + Voz-Orquestrador)". Um agente precisa navegar entre 3 documentos sem saber a ordem ou a relação.

**Ação necessária:** Criar `SPEC-001-INDEX.md` com mapa de navegação.

---

## 2. RESOLUÇÃO DOS 7 BLOQUEANTES CRÍTICOS DA SPEC-001

Na auditoria anterior, identifiquei 7 bloqueantes que impediam todos os 13 departamentos de trabalhar. Veja como os novos documentos afetam cada um:

### C01 — Tech stack não definida formalmente

| Aspecto | Status anterior | Status atual | Evidência |
|---------|----------------|-------------|-----------|
| Shell desktop | ❌ Implícito | ✅ Confirmado | "Desktop com Electron" (spec_002) |
| Frontend | ❌ Ausente | ✅ Definido | "React + TypeScript" (spec_002) |
| Backend | ❌ Implícito | ✅ Confirmado | "Python executado como processo gerenciado" (spec_002) |
| Banco | ❌ Implícito | ✅ Confirmado | "SQLite com migrações automáticas" (spec_002) |
| Framework backend | ❌ Ausente | ❌ AINDA AUSENTE | FastAPI? Flask? Litestar? Nenhum mencionado |
| Versão Python | ❌ Ausente | ❌ AINDA AUSENTE | 3.11? 3.12? 3.13? |
| Comunicação Electron↔Python | ❌ Ausente | 🟡 Parcial | "API local" mencionada + endpoints HTTP listados, mas sem decisão explícita (REST? IPC? porta?) |
| Agent framework | ❌ Ausente | 🟡 Declarado sem detalhe | "LangChain/LangGraph" mencionado como framework-alvo, sem versão, sem setup |
| Voice engine | ❌ Ausente | ❌ AINDA AUSENTE | "Transcrição local" definida mas engine concreta não nomeada (Whisper? qual?) |
| Vector DB | ❌ Ausente | ❌ AINDA AUSENTE | Não mencionado em nenhum documento novo |
| LLM provider | ❌ Ausente | ❌ AINDA AUSENTE | Nenhum provider, modelo ou API key management |
| Document engine | ❌ Ausente | ❌ AINDA AUSENTE | Template/PDF/DOCX engine não definido |
| Package manager | ❌ Ausente | ❌ AINDA AUSENTE | npm? yarn? pnpm? |
| Instalador | ❌ Ausente | 🟡 Mencionado | "Empacotamento do Electron app" sem tool específico |

**Veredicto: 🟡 PARCIALMENTE RESOLVIDO (40%).** Os componentes macro estão declarados (Electron + React/TS + Python + SQLite + LangGraph). Mas faltam versões, frameworks internos, e TODAS as bibliotecas críticas (voice, LLM, vector, docs).

---

### C02 — Nenhum contrato de interface entre componentes

**Veredicto: 🟢 SIGNIFICATIVAMENTE RESOLVIDO (75%).**

Os documentos novos trazem avanço substancial:

- ✅ Contratos de entrada/saída entre Deep Agents definidos (spec_002: 4 contratos estruturados)
- ✅ Voice Execution Envelope como contrato formal voz→orquestrador (spec_003)
- ✅ Session Ledger como contrato de estado entre sessões (spec_002__1_)
- ✅ Handoff protocol entre domínios (spec_002__1_)
- 🟡 Faltam contratos entre Memory Engine ↔ outros componentes
- 🟡 Faltam contratos entre Document Engine ↔ outros componentes
- ❌ Falta contrato Frontend ↔ Backend (existe lista de endpoints mas não existe request/response schema com tipos)

---

### C03 — Schema de banco de dados ausente

**Veredicto: 🟢 SIGNIFICATIVAMENTE RESOLVIDO (70%).**

Tabelas agora definidas com DDL concreto:

| Fase | Tabelas definidas | DDL com tipos? | FKs? |
|------|-------------------|----------------|------|
| Phase 0 | system_metadata, migrations, audit_log (mencionadas sem DDL) | ❌ | ❌ |
| Phase 1 | workspaces, conversations, conversation_tags, messages, attachments, audit_log | ✅ | ✅ |
| Phase 2 | voice_events, voice_transcripts, intent_events, voice_execution_envelopes, orchestrator_decisions | ✅ | ✅ |
| Context | session_ledgers, workflow_checkpoints, compaction_events, context_packs, agent_learnings, resume_events, handoff_artifacts | ❌ Nome apenas | ❌ |

**O que ainda falta:**
- DDL da Phase 0 (system_metadata, migrations)
- DDL das 7 tabelas de Context Persistence (listadas apenas por nome, sem colunas)
- DDL de Phases 3-11 (institutional_facts, profile_traits, etc.)
- Indexes explícitos (FTS5 mencionado mas nunca declarado)
- Política de IDs (TEXT PRIMARY KEY — UUID? ULID? formato?)
- ON DELETE / ON UPDATE nas FKs
- Política de soft-delete vs hard-delete

---

### C04 — Integração com LLM completamente indefinida

**Veredicto: ⛔ AINDA BLOQUEANTE (10% resolvido).**

O framework LangChain/LangGraph foi declarado como escolha arquitetural. Mas NENHUM detalhe de integração com LLM existe:

- ❌ Provider não definido (Claude? GPT? Local?)
- ❌ Modelo por tarefa não definido
- ❌ API key management ausente
- ❌ System prompts ausentes
- ❌ Token budget ausente
- ❌ Streaming vs. batch não definido
- ❌ Retry/fallback strategy ausente
- ❌ Custo estimado por operação ausente
- ❌ Caching de respostas ausente

Isso é especialmente grave porque o Intent Interpretation Layer (Phase 2), o Agent Orchestrator, todos os Deep Agents e a Redação Executiva DEPENDEM de chamadas a LLM. O componente mais caro e mais crítico do sistema continua sem spec.

---

### C05 — Agentes mencionados mas nunca definidos

**Veredicto: 🟢 SIGNIFICATIVAMENTE RESOLVIDO (80%).**

Os documentos trazem:

- ✅ Hierarquia de 5 camadas (Kernel → Roteador → Domínios → Subagents → Skills)
- ✅ 6 Deep Agents de domínio com nomes e responsabilidades
- ✅ 35+ subagents listados com nomes descritivos
- ✅ 30+ skills nomeadas por domínio
- ✅ 6 workflows explícitos (um por domínio)
- ✅ Contratos de entrada/saída para agentes
- ✅ Critérios de escalonamento (simples, paralelo, cadeia, aprofundamento, sensível)
- ✅ Verificador com estados verde/amarelo/vermelho

**O que ainda falta:**
- ❌ System prompts de cada agente
- ❌ Tools/APIs que cada agente usa concretamente
- ❌ Limites de autonomia por agente (o que pode fazer sem confirmar)
- ❌ Token budget por agente/chamada
- ❌ Critérios de sucesso mensuráveis por agente

---

### C06 — Fluxo de voz sem especificação de pipeline

**Veredicto: 🟢 RESOLVIDO (85%).**

A spec_003 traz um pipeline de 6 camadas detalhado:

- ✅ Audio Capture Layer
- ✅ Speech-to-Text Layer
- ✅ Transcript Normalization Layer
- ✅ Intent Interpretation Layer
- ✅ Conversation Resolution Layer
- ✅ Persistence Layer
- ✅ Voice Execution Envelope como contrato formal
- ✅ Integração com Session Ledger e lifecycle events
- ✅ 9 categorias de intenção primária
- ✅ 5 ações sobre conversa
- ✅ 8 tipos de entidades
- ✅ Regras de escolha de guia por intenção
- ✅ Política de confirmação curta
- ✅ DDL de 5 tabelas de voz

**O que ainda falta:**
- ❌ Engine concreta de STT (Whisper? faster-whisper? qual modelo?)
- ❌ Formato de áudio (WAV? PCM? sample rate?)
- ❌ VAD (voice activity detection) — decisão ausente
- ❌ Hardware requirements para rodar STT local
- ❌ Latência esperada por etapa

---

### C07 — Nenhuma especificação de API/endpoints

**Veredicto: 🟢 RESOLVIDO (80%).**

Endpoints agora listados por fase:

| Fase | Endpoints definidos | Request/Response schema? |
|------|--------------------|-----------------------|
| Phase 0 | 6 (health/live, health/ready, etc.) | ❌ Nomes apenas |
| Phase 1 | 14 (workspaces, conversations, search, messages, attachments) | ❌ Nomes apenas |
| Phase 2 | 11 (voice, intent, orchestrator) | ❌ Nomes apenas |

**Gap restante:** Os endpoints existem como lista de rotas, mas NENHUM possui request schema (quais campos? quais tipos? quais obrigatórios?) ou response schema. Um agente de frontend não consegue construir as chamadas corretas sem esses schemas.

---

### Quadro resumo da evolução

| Bloqueante | Antes | Agora | % Resolução |
|-----------|-------|-------|-------------|
| C01 Tech stack | ⛔ | 🟡 | 40% |
| C02 Contratos | ⛔ | 🟢 | 75% |
| C03 Schema DB | ⛔ | 🟢 | 70% |
| C04 LLM | ⛔ | ⛔ | 10% |
| C05 Agentes | ⛔ | 🟢 | 80% |
| C06 Voz | ⛔ | 🟢 | 85% |
| C07 API | ⛔ | 🟢 | 80% |

**Evolução global: de 2/10 para ~5.5/10 em codificabilidade.** Avanço real e significativo, mas 2 bloqueantes persistem (tech stack parcial + LLM totalmente indefinido) e impedem execução autônoma.

---

## 3. NOVOS BLOQUEANTES CRÍTICOS ENCONTRADOS

Os documentos novos, ao detalhar mais, também introduzem novas questões críticas:

### ⛔ NC-01 — LangChain/LangGraph declarado mas sem setup concreto

A spec declara "LangGraph custom workflow" como solução para workflows por domínio. Mas:
- Não há versão de LangChain/LangGraph especificada
- Não há exemplo de graph definition
- Não há definição de state schema do LangGraph
- Não há definição de como os Deep Agents são implementados (são classes Python? são LangGraph nodes? são processos separados?)
- Não há definição de como skills são carregadas ("sob demanda" como?)

**Impacto:** Um agente de codificação não sabe se deve criar classes Python com `@tool` decorators, funções simples, ou LangGraph nodes com state machines. A decisão arquitetural mais fundamental da camada cognitiva está declarada mas não especificada.

### ⛔ NC-02 — 7 tabelas de Context Persistence sem DDL

As seguintes tabelas foram listadas por nome mas NÃO possuem DDL:
- session_ledgers
- workflow_checkpoints
- compaction_events
- context_packs
- agent_learnings
- resume_events
- handoff_artifacts

O Session Ledger possui campos detalhados em texto (session_id, conversation_id, etc.), mas nunca foram traduzidos para SQL. Um agente de banco de dados não pode criar essas tabelas.

### ⛔ NC-03 — Profundidade de agentes inviável para MVP

A hierarquia definida totaliza:
- 1 Kernel de orquestração
- 1 Deep Agent Executivo Roteador
- 6 Deep Agents de domínio
- 35+ subagents
- 30+ skills
- 6 workflows

Isso são **70+ componentes cognitivos** para um MVP single-user. Cada Deep Agent com subagents implica: prompts, state management, token budget, error handling, persistence. Não há priorização de quais agentes são MVP vs. pós-MVP.

**Risco:** Um agente de codificação vai tentar implementar tudo de uma vez, ou não vai saber por onde começar. A SPEC-001 define Phases 0-11, mas os Deep Agents não estão mapeados a fases específicas. Em qual fase cada agente entra?

### ⛔ NC-04 — Inconsistência entre modelo de memória da SPEC-001 e da spec_002__1_

A SPEC-001 define 5 tipos de memória:
1. Micro
2. Macro
3. Snapshot factual
4. Snapshot executivo
5. Snapshot de perfil

A spec_002__1_ define 6 tipos de memória DIFERENTES:
1. Session Ledger Memory
2. Case Memory
3. Macro Memory
4. Institutional Truth Memory
5. Agent Operational Memory
6. Executive Preference Memory

**Nenhum documento faz a correspondência entre os dois modelos.** São complementares? O segundo substitui o primeiro? "Micro memory" da SPEC-001 é igual a "Session Ledger + Case Memory" da spec_002? Um agente não sabe.

---

## 4. FALHAS GRAVES DE CONSISTÊNCIA CRUZADA

### ⚠️ CC-01 — Phase 2 declarada com escopo diferente entre documentos

Na SPEC-001, Phase 2 é: "Push-to-talk, transcrição local, intenção semântica, entidades, sugestão de título e confirmação curta."

Na spec_003, Phase 2 INCLUI TAMBÉM: integração com Agent Orchestrator, Voice Execution Envelope, classificação orquestral em 7 categorias, criação de workflows a partir de voz, e DDL de orchestrator_decisions.

Isso são duas fases de complexidade muito diferente. A Phase 2 da spec_003 inclui trabalho que na SPEC-001 estaria mais próximo de Phase 6 (Orchestration).

### ⚠️ CC-02 — audit_log definido duas vezes com campos diferentes

Na spec_002__1_ (Phase 1):
```sql
audit_log (id, event_type, target_type, target_id, event_data, created_at)
```

Na SPEC-001 (modelo de dados resumido):
```
audit_log (mencionada sem campos)
```

Na Phase 0, há "tabela mínima de auditoria técnica" — mas sem DDL. Há 3 referências diferentes ao mesmo conceito sem schema unificado. Falta: quem criou o evento? qual foi a ação? qual o estado anterior?

### ⚠️ CC-03 — Modelo de conversa da Phase 1 inconsistente com "guias"

A SPEC-001 fala em "quatro guias iniciais: Planejamento, Captação, Normas e Regulação e Documentos."

A spec_002__1_ implementa "guias" como `workspaces` no banco. Mas no DDL de workspaces, o campo é `type TEXT NOT NULL` — sem enum ou check constraint. Um agente pode criar workspace com type="qualquer_coisa".

### ⚠️ CC-04 — Contratos de agentes usam nomes de campos inconsistentes

O contrato de entrada do Deep Agent usa `workspace`, mas o DDL de conversations usa `workspace_id`. O Voice Execution Envelope usa `workspace_final`. Três nomes para o mesmo conceito. Agentes de diferentes fases vão usar nomes diferentes, causando bugs de integração.

### ⚠️ CC-05 — Regra de precedência de memória sem implementação

A spec_002__1_ define hierarquia de precedência:
1. Verdade institucional canônica
2. Estado validado do caso
3. Memória macro
4. Memória operacional dos agentes
5. Preferências executivas
6. Hipóteses temporárias

Mas não existe: função que resolve conflito, campo que marca qual memória tem precedência, ou mecanismo que detecta quando duas memórias conflitam. Isso é filosofia excelente sem código possível.

### ⚠️ CC-06 — Suficiência loop definido sem métricas

O "Iterative retrieval and sufficiency loop" define "máximo 3 ciclos por tentativa". Mas o que constitui "suficiente" para cada domínio? As regras de suficiência por tipo (radar regulatório: 1 fonte, radar concorrência: 2 evidências, etc.) são bom começo, mas faltam: scoring function, threshold numérico, e o que acontece quando 3 ciclos não bastam (falha silenciosa? escalonamento? retorno parcial com caveat?).

### ⚠️ CC-07 — Workflows por domínio sem estados ou condições de transição

Os 6 workflows são listados como passos sequenciais (1→2→3...) mas não possuem: estados formais de LangGraph, condições de transição entre passos, pontos de decisão (branch), tratamento de falha por passo, ou timeout por passo. Para codificar em LangGraph, o agente precisa de um state graph, não de uma lista numerada.

### ⚠️ CC-08 — Falta de integração entre Phase 0 e agents

Phase 0 define: bootstrap, startup, shutdown, health checks, API local básica. Os Deep Agents são definidos na mesma spec_002. Mas não há indicação de QUANDO a infraestrutura de agents é instalada. Phase 0 prepara "base para workers, orquestração e runtime de modelos" — mas como? O backend Python da Phase 0 já precisa ter LangChain instalado? Ou isso é Phase posterior?

---

## 5. FALHAS DE AMBIGUIDADE

| ID | Localização | Ambiguidade | Impacto |
|----|-------------|-------------|---------|
| A01 | spec_002 Phase 0 | "porta local do backend" — qual porta? | Agentes vão escolher portas diferentes |
| A02 | spec_002 Phase 0 | "Python executado como processo gerenciado" — child_process? subprocess? | Mecanismo de spawn indefinido |
| A03 | spec_002 Phase 1 | "busca deve ter peso superior ao título" — qual peso? TF-IDF? Boost factor? | Implementações de busca divergentes |
| A04 | spec_002 Phase 1 | "tamanho mínimo configurável" de título — qual default? 3 chars? 10? | Validação inconsistente |
| A05 | spec_002__1_ | "compactação em marcos lógicos" — quem decide que é um marco lógico? | Compactação arbitrária ou nunca executada |
| A06 | spec_003 Phase 2 | "score básico de qualidade" do STT — qual score? WER? Confidence da API? | Métrica de qualidade indefinida |
| A07 | spec_003 Phase 2 | "limpar ruído textual evidente" — quais regras? Regex? LLM? | Normalização não determinística |
| A08 | spec_003 | "classificar intenção com rastreabilidade básica" — o que é rastreabilidade de intenção? | Critério de aceite não testável |
| A09 | spec_002 Agents | "skills sob demanda" — carregadas como? Módulos Python? Prompt templates? Ferramentas LangChain? | Modelo de deployment de skills indefinido |
| A10 | spec_002 Agents | "heurísticas úteis por domínio" em Agent Operational Memory — formato? | Memória de aprendizado sem schema |

---

## 6. ANÁLISE ATUALIZADA POR DEPARTAMENTO

| Departamento | Antes | Agora | Pode iniciar? | Bloqueio restante |
|---|---|---|---|---|
| **Dept 1 — Arquitetura** | ⛔ | 🟡 | Parcialmente | Falta framework backend, LangGraph setup concreto, reconciliação dos modelos de memória |
| **Dept 2 — Frontend** | ⛔ | 🟡 | Parcialmente | React+TS confirmado, wireframes ausentes, request/response schemas ausentes |
| **Dept 3 — Backend** | ⛔ | 🟡 | Phase 0 apenas | Framework ausente, mas endpoints + health checks permitem skeleton |
| **Dept 4 — Database** | ⛔ | 🟢 | Phase 0-2 | DDL de Phase 1-2 existe, Phase 0 e Context Persistence faltam |
| **Dept 5 — Voice/NLP** | ⛔ | 🟡 | Pipeline definido, engine indefinida | STT engine concreta, formato áudio, VAD, hardware |
| **Dept 6 — AI/LLM** | ⛔ | ⛔ | Não | LLM provider, prompts, budget — TUDO ausente |
| **Dept 7 — Documents** | ⛔ | ⛔ | Não | Templates, engine de PDF/DOCX — TUDO ausente |
| **Dept 8 — Monitoring** | ⛔ | 🟡 | Arquitetura definida | Mecanismo de coleta, parser, frequência, legalidade de scraping |
| **Dept 9 — Legal** | ⛔ | 🟡 | Estrutura existe | Regras verde/amarelo/vermelho sem critérios implementáveis |
| **Dept 10 — Orchestration** | ⛔ | 🟡 | Conceitual | Workflows sem state graphs, LangGraph sem setup |
| **Dept 11 — Security** | ⛔ | 🟡 | Baseline existe | "API em loopback" + separação canônico/cache são bom início |
| **Dept 12 — Testing** | ⛔ | 🟢 | Phase 0-2 | Critérios de aceite técnicos e funcionais por fase existem |
| **Dept 13 — DevOps** | ⛔ | 🟡 | Parcial | Empacotamento Electron mencionado sem tool, SO-alvo ainda implícito |

**Evolução: de 0/13 para 2/13 departamentos podem iniciar trabalho completo (Database Phase 0-2, Testing Phase 0-2). 8 podem iniciar trabalho parcial. 3 continuam bloqueados (AI/LLM, Documents, Orchestration concreta).**

---

## 7. ANÁLISE DE CODIFICABILIDADE POR FASE

| Fase | Codificável? | Score | O que falta |
|------|-------------|-------|-------------|
| **Phase 0** | 🟢 Sim, com ressalvas | 7/10 | Framework backend, porta, versão Python, tool de empacotamento |
| **Phase 1** | 🟢 Sim, com ressalvas | 7/10 | Request/response schemas dos endpoints, wireframes, FTS5 config |
| **Phase 2 (voz)** | 🟡 Parcial | 5/10 | STT engine concreta, formato áudio, hardware specs |
| **Phase 2 (orquestrador)** | 🟡 Parcial | 4/10 | LLM provider, LangGraph setup, state graphs |
| **Phase 3** | ❌ Não | 2/10 | Schema de fatos, parser, precedência — spec_002 não cobre |
| **Phase 4** | ❌ Não | 3/10 | Modelo de memória em conflito entre docs, DDL ausente |
| **Phase 5** | ❌ Não | 2/10 | Algoritmo de aprendizado de perfil continua ausente |
| **Phase 6** | ❌ Não | 3/10 | Workflows sem state graphs, limites de concorrência |
| **Phase 7** | ❌ Não | 1/10 | Templates documentais TOTALMENTE ausentes |
| **Phase 8** | ❌ Não | 2/10 | Mecanismo de coleta/scraping/API indefinido |
| **Phase 9** | ❌ Não | 2/10 | Regras determinísticas jurídicas ausentes |
| **Phase 10-11** | ❌ Não | 1/10 | Dependem de tudo anterior |

---

## 8. CHECKLIST CONSOLIDADO DE ITENS PENDENTES

### P0 — Bloqueantes imediatos (impedem codificação)

| # | Item | Resolvido? | Impacto |
|---|------|-----------|---------|
| 1 | Framework backend Python (FastAPI/Flask/Litestar) | ❌ | Todo backend |
| 2 | Versão Python | ❌ | Setup, CI |
| 3 | LLM provider + modelo + API keys | ❌ | Phases 2-11 |
| 4 | STT engine concreta + modelo | ❌ | Phase 2 |
| 5 | Vector DB local | ❌ | Phase 4+ |
| 6 | LangGraph versão + setup + state schemas | ❌ | Phase 2+ orquestração |
| 7 | Reconciliação dos 2 modelos de memória | ❌ | Phase 4 |
| 8 | DDL das 7 tabelas de Context Persistence | ❌ | Phase 4 |

### P1 — Graves (causam retrabalho significativo)

| # | Item | Status |
|---|------|--------|
| 9 | Request/response JSON schemas para TODOS os endpoints | ❌ |
| 10 | Mapeamento fase↔agente (quais agents entram em qual Phase) | ❌ |
| 11 | State graphs dos 6 workflows em formato LangGraph | ❌ |
| 12 | Priorização: quais dos 70+ componentes são MVP | ❌ |
| 13 | Nomenclatura unificada (workspace vs workspace_id vs workspace_final) | ❌ |
| 14 | DDL de Phase 0 (system_metadata, migrations) | ❌ |
| 15 | System prompts dos agentes principais (pelo menos Roteador + Verificador) | ❌ |
| 16 | Error handling por etapa do pipeline de voz | ❌ |

### P2 — Moderados (causam divergência de implementação)

| # | Item | Status |
|---|------|--------|
| 17 | Wireframes ou mockups da UI | ❌ |
| 18 | Hardware specs do Giuseppe | ❌ |
| 19 | SO target confirmado | ❌ |
| 20 | Porta local do backend | ❌ |
| 21 | Formato de IDs (UUID v4? ULID?) | ❌ |
| 22 | Idioma de variáveis/código (pt-BR? en?) | ❌ |
| 23 | Glossário unificado | ❌ |
| 24 | Documento-índice do corpus | ❌ |
| 25 | Limpeza de duplicatas e truncamentos | ❌ |

---

## 9. RECOMENDAÇÕES DE AÇÃO

### Prioridade imediata: 3 documentos que desbloqueiam tudo

**Documento 1 — SPEC-001-TECH-DECISIONS.md**
Uma página com: Python 3.12, FastAPI, Electron 28+, React 18, TypeScript 5, SQLite 3.45+, LangGraph 0.2+, faster-whisper (small), ChromaDB, Claude API (Sonnet para classificação, Opus para geração), porta 8741, UUID v4, código em inglês, UI em pt-BR.
Estimativa: 30 minutos. Desbloqueia: TODOS os departamentos.

**Documento 2 — SPEC-001-API-CONTRACTS.md**
JSON Schema para cada endpoint das Phases 0, 1 e 2. Request body, response body, error codes.
Estimativa: 2-3 horas. Desbloqueia: Frontend + Backend + Testing.

**Documento 3 — SPEC-001-MEMORY-RECONCILIATION.md**
Mapa que diz: "Micro memory da SPEC-001 = Session Ledger + Case Memory da spec_002. Macro memory = Macro Memory. Snapshot factual = parte do Session Ledger accepted_facts. Snapshot executivo = compact summary. Snapshot de perfil = Executive Preference Memory." + DDL das 7 tabelas de contexto.
Estimativa: 1-2 horas. Desbloqueia: Database + Memory Engine + Orchestration.

### Prioridade seguinte

**4 — Redução de escopo agente-MVP:** Definir quais dos 6 Deep Agents são Phase 2 (provavelmente só o Roteador), quais são Phase 6+ (Regulação, Concorrência, etc.), e quais são Phase 8+ (Mercado, Diagnóstico).

**5 — Limpeza documental:** Remover spec_002.md (versão obsoleta), remover 2 cópias da spec_003, restaurar headers truncados, criar SPEC-001-INDEX.md com mapa de navegação.

---

## CONCLUSÃO FINAL

A evolução documental entre a SPEC-001 e as specs 002/003 é **real e substancial**. A Phase 0 está quase pronta para codificação. A Phase 1 está próxima. A Phase 2 (voz isolada) avançou muito. A arquitetura de agentes em Deep Agents é conceitualmente sólida e bem organizada.

Porém, dois problemas estruturais persistem:

1. **O LLM é o coração do sistema e não tem spec.** É como projetar um carro com motor, câmbio, suspensão — mas sem definir qual combustível usa.

2. **A riqueza da spec de agentes está desconexa da realidade do MVP.** 70+ componentes cognitivos para um MVP single-user é over-engineering que vai paralisar a implementação. Precisa de uma linha clara: "no MVP, o Roteador + Verificador + Redação existem; os demais domínios são stubs com prompts simples."

**Score atualizado:**

| Dimensão | Score |
|----------|-------|
| Visão de produto | 9/10 |
| Arquitetura conceitual | 8.5/10 |
| Codificabilidade Phase 0 | 7/10 |
| Codificabilidade Phase 1 | 7/10 |
| Codificabilidade Phase 2 | 5/10 |
| Codificabilidade Phases 3-11 | 2/10 |
| **Codificabilidade global ponderada** | **4.5/10** |

A distância entre 4.5 e 7.0 (suficiente para iniciar sprints) pode ser coberta com os **3 documentos técnicos sugeridos acima** — trabalho estimado de um dia focado, sem precisar programar.
