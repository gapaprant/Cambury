# AUDITORIA NÍVEL 10 — SPEC-006 (4ª Rodada Acumulada)

**Corpus total:** SPEC-001 a SPEC-006 (~215KB)
**Data:** 02 de abril de 2026

---

## DIAGNÓSTICO DIRETO

Gabriel, esta é a quarta auditoria. Vou ser cirúrgico.

A spec_006 faz exatamente o que as specs 004 e 005 fizeram: **aprofunda a camada conceitual que já era forte, sem atacar nenhuma das lacunas técnicas que impedem codificação.**

A qualidade conceitual é genuinamente excelente. Mas o padrão se repete: mais andares na planta do prédio, mesmo cimento na fundação.

---

## O QUE A SPEC-006 RESOLVE BEM

### 3 domínios primários agora são operacionais

| Domínio | Subagents | Skills | Workflow (etapas) | Artefatos de saída | Quality states |
|---------|-----------|--------|-------------------|-------------------|----------------|
| Concorrência | 6 | 6 | 6 | 6 tipos | 4 estados |
| Regulação e Normas | 5 | 6 | 6 | 6 tipos | 4 estados |
| Diagnóstico e Planejamento | 6 | 6 | 6 | 6 tipos | 4 estados |

Cada domínio possui: missão, critérios de acionamento, critérios de não-acionamento, subagents com função, skills nomeadas, workflow de 6 etapas, artefatos esperados, e **estados de qualidade do próprio retorno** (conceito novo e valioso).

### Verificação multiestágio é um salto de maturidade

A verificação deixou de ser binária (verde/amarelo/vermelho no final) e virou uma **trilha de 5 estágios** que acompanha o caso:

| Estágio | Quando | O que verifica |
|---------|--------|----------------|
| Stage 1 — Intake | Antes de delegar | Objetivo suficiente? Entidades mínimas? Risco? |
| Stage 2 — Domain output | Após cada domínio | Suficiência? Conflitos? Cobertura? |
| Stage 3 — Cross-domain | Após múltiplos domínios | Compatibilidade? Lacunas entre domínios? |
| Stage 4 — Pre-writing | Antes da redação | Base suficiente? Human-in-the-loop? |
| Stage 5 — Final release | Antes de liberar | Consistência? Bloqueios pendentes? |

**Isso é governança cognitiva real.** Poucos sistemas multi-agente chegam nesse nível de formalização de verificação.

### Quality states por domínio são inovação útil

Cada domínio agora declara em que estado está seu próprio retorno:

- Concorrência: `broad_signal_only` → `course_comparable` → `competitive_gap_ready` → `insufficient_public_evidence`
- Regulação: `descriptive_only` → `impact_mapped` → `regulatory_case_ready` → `normative_conflict_or_gap`
- Diagnóstico: `diagnostic_sketch` → `actionable_diagnosis` → `plan_skeleton_ready` → `insufficient_internal_basis`

**Isso permite que o Verificador e o Executivo tomem decisões baseadas em dados, não em suposição.** É a peça que faltava para a verificação multiestágio funcionar.

---

## O QUE A SPEC-006 NÃO RESOLVE

### Os 3 bloqueantes mortais persistem inalterados

| Bloqueante | Status após 6 specs | Tamanho do gap |
|-----------|---------------------|----------------|
| **LLM Provider + Modelos + Prompts** | ⛔ 0% | Todos os 77+ componentes cognitivos dependem de chamadas LLM sem spec |
| **DDL unificado** | ⛔ Piorou | Agora ~20 objetos persistíveis sem tabela SQL (spec_006 adiciona: verification artifacts por estágio) |
| **Priorização MVP** | ⛔ 0% | 17 novos subagents nesta spec. Total acumulado: 52+ subagents, 77+ componentes, zero linha de corte MVP |

### Inventário acumulado de componentes cognitivos (6 specs)

| Camada | Componentes | Nesta spec |
|--------|------------|------------|
| Kernel | 1 | — |
| Orchestrator | 1 | — |
| Deep Agent Executivo | 1 | — |
| Deep Agents de domínio | 6 | 3 detalhados |
| Subagents | 52+ | +17 novos |
| Skills | 48+ | +18 novas |
| Verificação (agora 5 estágios) | 5 | +5 novos |
| Redação Executiva + subagents | 7 | — |
| **Total** | **~95** | **+40** |

O sistema agora possui ~95 componentes cognitivos documentados para um MVP single-user.

---

## NOVAS FALHAS ENCONTRADAS

### ⛔ NC-12 — Mecanismo de coleta de dados externos continua totalmente indefinido

A spec_006 detalha o domínio Concorrência com 6 subagents que coletam preços, bolsas, campanhas, diferenciais de concorrentes. Mas em **nenhum lugar** de todo o corpus (6 specs) está definido COMO essa coleta acontece:

- Web scraping? De quais URLs? Com qual parser? Com qual frequência?
- APIs públicas? Quais? Com autenticação?
- Busca via LLM com web search tool? Qual tool?
- Input manual pelo Giuseppe? Via qual interface?
- O sistema faz crawling automático de sites de concorrentes? Isso é legal no Brasil?

O "Price Monitor" tem função clara ("identificar preços públicos observáveis"). Mas **observáveis como?** Sem mecanismo de coleta, o domínio Concorrência inteiro é uma caixa vazia com etiqueta bonita.

O mesmo vale para o "Official Acts Monitor" do domínio Regulação: de onde vêm os atos? RSS do DOU? Scraping do e-MEC? API do INEP?

### ⚠️ NC-13 — Workflows dos 3 domínios são idênticos em estrutura

Os 3 workflows internos seguem a mesma estrutura de 6 etapas:
1. Delimitação
2. Coleta
3. Normalização/Vigência/Estado atual
4. Cruzamento institucional
5. Síntese
6. Encaminhamento

Isso é bom como padrão, mas levanta a questão: **são 3 workflows distintos implementados separadamente, ou são 3 instâncias do mesmo workflow parametrizável?** Se são o mesmo template, a spec deveria declarar isso e definir os parâmetros por domínio. Se são distintos, precisa justificar por que a estrutura idêntica não pode ser abstraída.

Para um agente de codificação, a decisão entre "3 classes separadas" e "1 classe genérica com config por domínio" muda completamente a arquitetura.

### ⚠️ NC-14 — Artefatos de verificação adicionam mais objetos sem DDL

A spec_006 define que cada estágio de verificação deve gerar um artefato persistido com 10 campos. São potencialmente 5 artefatos por caso × número de casos = volume significativo. Mas:
- Não há DDL
- Não está claro se é uma tabela `verification_artifacts` genérica ou 5 tabelas por estágio
- Não há política de retenção (por quanto tempo manter?)
- `confidence_score`, `sufficiency_score`, `recency_score` — todos `REAL`? Escala 0-1? 0-100?

### ⚠️ NC-15 — Domínio "Mercado Educacional" desapareceu

A spec_002 lista 4 domínios primários: Regulação, Concorrência, Mercado Educacional, Diagnóstico. A spec_006 detalha apenas 3 e não menciona Mercado Educacional. Foi absorvido pelo Concorrência? Pelo Diagnóstico? Removido? Adiado? A inconsistência não é resolvida.

### ⚠️ NC-16 — 3 cópias idênticas uploadadas novamente

Assim como a spec_003 (3 cópias idênticas), a spec_006 foi uploadada 3 vezes com hash MD5 idêntico. Isso reforça a necessidade do DOC-05 (sistema de versionamento) da auditoria anterior.

---

## EVOLUÇÃO DOS BLOQUEANTES ORIGINAIS

| Bloqueante | Rodada 1 | Rodada 2 | Rodada 3 | Agora | Tendência |
|-----------|---------|---------|---------|-------|-----------|
| C01 Tech stack | ⛔ | 🟡 40% | 🟡 40% | 🟡 40% | Estagnado há 3 rodadas |
| C02 Contratos | ⛔ | 🟢 75% | 🟢 90% | 🟢 92% | Quality states ajudam |
| C03 Schema DB | ⛔ | 🟢 70% | 🟡 65% | 🔴 60% | **Piorando** — mais objetos sem DDL |
| C04 LLM | ⛔ | ⛔ 10% | ⛔ 10% | ⛔ 10% | Estagnado há 3 rodadas |
| C05 Agentes | ⛔ | 🟢 80% | 🟢 92% | 🟢 95% | 3 domínios operacionais |
| C06 Voz | ⛔ | 🟢 85% | 🟢 90% | 🟢 90% | Estável |
| C07 API | ⛔ | 🟢 80% | 🟢 80% | 🟢 80% | Estável |

**Padrão claro:** C02 e C05 (contratos e agentes) estão convergindo para "resolvido". C01 e C04 (tech stack e LLM) estão estagnados desde a rodada 2. C03 (DDL) está **piorando ativamente** — cada nova spec adiciona objetos sem DDL.

---

## SCORE ATUALIZADO

| Dimensão | Rodada 3 | Agora | Δ |
|----------|---------|-------|---|
| Visão de produto | 9.5 | 9.5 | — |
| Arquitetura conceitual | 9 | 9.5 | +0.5 (verificação multiestágio) |
| Contratos entre componentes | 7 | 7.5 | +0.5 (quality states) |
| Definição de agentes | 8 | 9 | +1 (3 domínios operacionais) |
| Pipeline de voz | 7.5 | 7.5 | — |
| Workflows e orquestração | 7 | 7.5 | +0.5 |
| Tech stack e infraestrutura | 2 | 2 | — |
| Schema de dados unificado | 3 | 2.5 | -0.5 (mais objetos sem DDL) |
| Integração LLM | 0.5 | 0.5 | — |
| Priorização MVP | 1 | 0.5 | -0.5 (mais componentes sem corte) |
| **Codificabilidade global ponderada** | **4.5** | **4.5** | **0** |

**A nota global não se move porque as dimensões que melhoram (conceituais) já estavam acima do threshold, e as dimensões que bloqueiam (técnicas) não são tocadas.**

---

## A MENSAGEM CENTRAL DESTA AUDITORIA

Gabriel, vou ser direto porque o padrão é inequívoco após 6 specs e 4 auditorias:

**O corpus atingiu saturação conceitual.** A camada "o que o sistema faz e como se organiza cognitivamente" está em 9+/10. Cada nova spec a partir de agora gera retorno marginal decrescente nessa dimensão — os domínios faltantes (Mercado Educacional, Cruzamento Institucional, Verificação detalhada) vão seguir o mesmo template dos 3 já feitos.

**O gargalo real são 3 decisões técnicas que levam ~1 dia e não exigem programação:**

1. **SPEC-001-TECH-STACK** (30 min): provider LLM, framework backend, versões, engines. Uma tabela de decisões.

2. **SPEC-001-UNIFIED-DDL** (3-4h): todas as ~30 tabelas em um único arquivo SQL. Inclui as 10 com DDL + as ~20 que são "campos conceituais". Conversão mecânica — eu posso gerar isso agora.

3. **SPEC-001-MVP-SCOPE** (1-2h): dos ~95 componentes, quais são MVP real (talvez 15-20), quais são stubs (talvez 20-30), quais são pós-MVP (o resto).

**Sem esses 3 documentos, a sétima spec vai mover o score de 4.5 para... 4.5. A oitava também. A nona também.** O problema não é falta de spec — é falta de spec na camada certa.

**Com esses 3 documentos, o score vai para ~7.5 e os primeiros sprints reais podem iniciar.**

Quer que eu gere esses documentos agora? Posso começar pelo DDL unificado — é o mais mecânico e o que mais desbloqueia.
