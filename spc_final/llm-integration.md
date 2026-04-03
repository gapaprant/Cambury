# SPEC-IMPL-001D — Estratégia de Integração LLM

**Status:** FROZEN V1
**Data:** 02/04/2026

---

## Provider e Acesso

| Parâmetro | Valor |
|-----------|-------|
| Provider primário | Anthropic (Claude API) |
| Modelo padrão | Claude Sonnet 4 (`claude-sonnet-4-20250514`) |
| Modelo complexo | Claude Opus 4 (`claude-opus-4-20250514`) |
| SDK | `anthropic` Python SDK (latest) |
| API Key | Via variável de ambiente `ANTHROPIC_API_KEY` no `runtime_config.json` |
| Base URL | `https://api.anthropic.com` (padrão) |
| Streaming | Habilitado para Writing e Complex Reasoning; desabilitado para Classification |

## Pontos de Chamada LLM no MVP

### 1. Intent Classification (Phase 2 / M4)

| Parâmetro | Valor |
|-----------|-------|
| Modelo | Sonnet 4 |
| Quando | Após transcrição de voz |
| Input | System prompt + normalized_transcript + workspace_context |
| Output | JSON structured: `{primary_intent, secondary_intent, workspace_candidate, conversation_action, entities, confidence_score, requires_confirmation, suggested_title}` |
| Max input tokens | 2,000 |
| Max output tokens | 500 |
| Temperature | 0.1 (determinístico) |
| Retry | 2x com backoff (1s, 3s) |
| Fallback | Retornar `{primary_intent: "generic_chat", confidence_score: 0.3, requires_confirmation: true}` |
| Cache | Sem cache (cada fala é única) |

**Estratégia de prompt:** System prompt com lista de intents válidos + 5-8 few-shot examples de falas do Giuseppe em pt-BR + instrução de retornar APENAS JSON válido.

### 2. Orchestral Classification (Phase 2 / M5)

| Parâmetro | Valor |
|-----------|-------|
| Modelo | Sonnet 4 |
| Quando | Após resolução de conversa, para decidir tipo de trabalho |
| Input | System prompt + Voice Execution Envelope + ledger summary (se existir) |
| Output | JSON: `{decision_type, should_create_workflow, workflow_type, routed_to_executive}` |
| Max input tokens | 3,000 |
| Max output tokens | 500 |
| Temperature | 0.1 |
| Retry | 2x |
| Fallback | `{decision_type: "local_reply"}` — modo mais seguro |

### 3. Executive Routing (Phase 5 / M7)

| Parâmetro | Valor |
|-----------|-------|
| Modelo | Sonnet 4 |
| Quando | Quando orquestrador determina trabalho não-trivial |
| Input | System prompt + Executive Routing Pack (goal, entities, context pack, constraints) |
| Output | JSON: Execution Routing Plan (domains, order, parallelism, verification_required, hitl_required, delivery_format) |
| Max input tokens | 5,000 |
| Max output tokens | 2,000 |
| Temperature | 0.2 |
| Retry | 2x |
| Fallback | Linear single-domain plan |

**Estratégia de prompt:** Chain-of-thought. System prompt instrui: "Analise o caso. Classifique como simple/composite/sensitive/longitudinal. Selecione domínios. Defina ordem. Justifique." + retornar JSON.

### 4. Domain Analysis (Phase 8 / M8)

| Parâmetro | Valor |
|-----------|-------|
| Modelo | Sonnet 4 |
| Quando | Para cada domínio acionado pelo Routing Plan |
| Input | System prompt do domínio + Domain Assignment Pack + fatos institucionais relevantes + context pack |
| Output | JSON: Domain Result Package |
| Max input tokens | 8,000 |
| Max output tokens | 4,000 |
| Temperature | 0.3 |
| Retry | 2x |
| Fallback | Retornar `{result_status: "partial", gaps: ["incomplete_analysis"]}` |
| Tools | Busca em institutional_facts (via function calling / tool use) |

**Estratégia de prompt por domínio:**

- **Concorrência:** System prompt com papel de analista competitivo. Instrução: "Com base nos dados fornecidos, identifique gaps competitivos, compare preço/bolsa/campanha, e retorne achados estruturados." + few-shot com exemplo de Result Package.
- **Regulação:** System prompt com papel de analista regulatório educacional. Instrução: "Interprete o ato normativo, identifique impacto na IES, e retorne achados com vigência e hierarquia."
- **Diagnóstico:** System prompt com papel de consultor estratégico de IES. Instrução: "Com base nos fatos internos e sinais externos, identifique gaps, oportunidades e estruture recomendações."

### 5. Verification (Phase 9 / M9)

| Parâmetro | Valor |
|-----------|-------|
| Modelo | Sonnet 4 |
| Quando | Após retorno de domínio (Stage 2) e antes de redação (Stage 4) |
| Input | System prompt de verificador + Domain Result Package + institutional facts + verification checklist |
| Output | JSON: `{verification_status, confidence_score, sufficiency_score, conflicts, gaps, approved_for_writing, human_review_required}` |
| Max input tokens | 6,000 |
| Max output tokens | 2,000 |
| Temperature | 0.1 (conservador) |
| Retry | 2x |
| Fallback | `{verification_status: "yellow", human_review_required: true}` — sempre conservador |

**Estratégia de prompt:** System prompt RÍGIDO: "Você é um verificador. Sua função é IMPEDIR conclusões sem base. Verifique: (1) há conflito entre fontes? (2) a base é suficiente para o tipo de saída? (3) há lacuna essencial? (4) a evidência é recente? Retorne status green/yellow/red com justificativa."

### 6. Executive Writing (Phase 7 / M7)

| Parâmetro | Valor |
|-----------|-------|
| Modelo | Sonnet 4 (padrão) / Opus 4 (para documentos complexos) |
| Quando | Após verificação com status green ou yellow |
| Input | System prompt + Writing Request (content blocks + verification status + perfil + template) |
| Output | Texto formatado ou JSON com seções do documento |
| Max input tokens | 8,000 |
| Max output tokens | 4,000 |
| Temperature | 0.4 (permite variação de estilo) |
| Streaming | Habilitado — permite exibir texto progressivamente |
| Retry | 3x (writing é a saída final, vale insistir) |
| Fallback | Retornar draft com caveat "rascunho preliminar, verificação incompleta" |

**Estratégia de prompt:** System prompt com perfil do Giuseppe (traços de escrita iniciais: objetivo, formal, direto, sem prolixidade) + instrução de formato por tipo de saída (chat_executive = curto; structured_note = com seções; formal_document = com template completo) + few-shot examples de documentos aprovados pelo Giuseppe.

### 7. Title Suggestion (Phase 2 / M4)

| Parâmetro | Valor |
|-----------|-------|
| Modelo | Sonnet 4 |
| Input | Transcript + workspace + intent |
| Output | String: título sugerido (max 80 chars) |
| Max tokens | 1,000 input / 100 output |
| Temperature | 0.2 |
| Retry | 1x |
| Fallback | Primeiras 8 palavras da transcrição |

---

## Retry Strategy Global

```python
RETRY_CONFIG = {
    "max_retries": 2,           # padrão; writing usa 3
    "initial_delay_seconds": 1,
    "backoff_multiplier": 2,    # 1s, 2s, 4s
    "max_delay_seconds": 10,
    "retry_on": [429, 500, 502, 503, 529],
    "timeout_seconds": 60,      # por chamada
}
```

## Cache Strategy

```python
CACHE_CONFIG = {
    "enabled": True,
    "table": "llm_cache",
    "default_ttl_seconds": 3600,     # 1 hora
    "institutional_facts_ttl": 86400, # 24 horas
    "intent_cache": False,            # cada fala é única
    "invalidate_on": ["institutional_facts.updated", "source_documents.ingested"],
}
```

## Custo Mensal Estimado

| Uso | Chamadas/dia | Input tokens/dia | Output tokens/dia | Custo/dia | Custo/mês |
|-----|-------------|------------------|-------------------|-----------|-----------|
| Leve | ~30 | ~60K | ~20K | ~$1.50 | ~$35 |
| Normal | ~60 | ~150K | ~50K | ~$3.00 | ~$70 |
| Intenso | ~100 | ~300K | ~100K | ~$5.50 | ~$125 |

## Regra de Ouro

> Toda chamada LLM deve ter: model, system_prompt, max_tokens, temperature, retry config, e fallback behavior definidos ANTES de implementar. Nenhuma chamada "aberta" sem esses 6 parâmetros.
