# State Machines Formais V1

## 1. Conversation States

```
States: active, paused, archived, draft
Initial: draft (se criada sem mensagem) ou active (se criada com mensagem/voz)

Transitions:
  draft     → active     [trigger: primeira mensagem adicionada]
  active    → paused     [trigger: user pausa OU sistema pausa por inatividade]
  active    → archived   [trigger: user arquiva]
  paused    → active     [trigger: user retoma OU nova voz resolve para esta conversa]
  paused    → archived   [trigger: user arquiva]
  archived  → active     [trigger: user desarquiva]

Transições PROIBIDAS:
  draft     → archived   (não faz sentido arquivar vazio)
  draft     → paused     (não faz sentido pausar vazio)
  archived  → paused     (desarquivar vai direto para active)
  ANY       → draft      (draft é apenas estado inicial)
```

## 2. Workflow States

```
States: created, queued, running, waiting_confirmation, paused, completed, failed
Initial: created

Transitions:
  created              → queued                [trigger: seed + tasks criados com sucesso]
  created              → waiting_confirmation  [trigger: caso sensível, precisa aprovação para começar]
  created              → failed                [trigger: erro fatal na criação do seed]
  queued               → running               [trigger: scheduler pega workflow da fila]
  running              → waiting_confirmation  [trigger: HITL necessário OU checkpoint com requires_user_action=true]
  running              → paused                [trigger: user pausa OU erro recuperável]
  running              → completed             [trigger: todas as tasks finalizadas + final_checkpoint emitido]
  running              → failed                [trigger: erro irrecuperável OU 3 falhas consecutivas na mesma task]
  waiting_confirmation → running               [trigger: user aprova/confirma]
  waiting_confirmation → paused                [trigger: user não responde em 24h OU pausa explícita]
  waiting_confirmation → failed                [trigger: user rejeita caso inteiro]
  paused               → queued                [trigger: user retoma]
  paused               → failed                [trigger: user cancela]
  paused               → completed             [trigger: user aceita saída parcial como final]

Transições PROIBIDAS:
  completed → ANY        (workflow fechado é imutável; novo trabalho = novo workflow)
  failed    → running    (deve criar novo workflow, não reabrir o falhado)
  queued    → completed  (não pode completar sem executar)

Comportamento em crash do app:
  Se status era 'running' quando app fechou → volta para 'queued' no startup
  Se status era 'waiting_confirmation' → mantém (não perde pergunta ao user)
  Tasks com status 'running' no crash → voltam para 'queued'
```

## 3. Workflow Task States

```
States: pending, queued, running, completed, failed, skipped
Initial: pending

Transitions:
  pending   → queued     [trigger: todas as dependências completadas]
  pending   → skipped    [trigger: workflow cancelado OU dependência falhou e task não é obrigatória]
  queued    → running    [trigger: scheduler inicia task]
  running   → completed  [trigger: resultado produzido com sucesso]
  running   → failed     [trigger: erro após retries]
  running   → queued     [trigger: crash recovery — running no shutdown volta para queued]
  failed    → queued     [trigger: retry manual OU workflow retry policy]
  failed    → skipped    [trigger: skip manual pelo user/orchestrator]

Transições PROIBIDAS:
  completed → ANY        (task completa é imutável)
  skipped   → ANY        (decisão de skip é final)
```

## 4. Verification Status (por estágio)

```
States: green, yellow, red
Não é uma state machine com transições — cada estágio produz um status independente.

Regras de propagação:
  Se Stage 2 (domain_output) = red     → Stage 4 (pre_writing) NÃO é executado, caso volta ao domínio
  Se Stage 2 = yellow                  → Stage 4 é executado com flag 'partial_basis=true'
  Se Stage 3 (cross_domain) = red      → Stage 4 bloqueado, checkpoint com conflito emitido
  Se Stage 4 (pre_writing) = red       → Writing bloqueada, HITL obrigatório
  Se Stage 4 = yellow                  → Writing permitida com caveats no output
  Se Stage 5 (final_release) = red     → Output NÃO é entregue ao user como conclusão final

Regra conservadora: em caso de dúvida, classificar como yellow (nunca suprimir para green).
```

## 5. Writing Output Release Status

```
States: draft, review, approved, blocked, released
Initial: draft

Transitions:
  draft     → review     [trigger: writing completa, self-check passa]
  draft     → blocked    [trigger: verification_status=red OU institutional_alignment=conflicted]
  review    → approved   [trigger: self-check + profile compliance ok]
  review    → blocked    [trigger: conflito detectado na revisão]
  review    → draft      [trigger: reescrita necessária]
  approved  → released   [trigger: user aprova OU auto-release se não sensível]
  approved  → draft      [trigger: user pede reescrita]
  blocked   → draft      [trigger: causa do bloqueio resolvida, nova tentativa]
  blocked   → review     [trigger: HITL aprova release com caveat]

Transições PROIBIDAS:
  blocked   → released   (nunca liberar output bloqueado sem resolver)
  released  → ANY        (release é final; nova versão = novo writing_output)
```

## 6. Voice Event Status

```
States: captured, transcribing, transcribed, interpreted, failed
Initial: captured

Transitions:
  captured     → transcribing  [trigger: STT pipeline iniciou]
  transcribing → transcribed   [trigger: transcript gerado com sucesso]
  transcribing → failed        [trigger: STT falhou (áudio corrompido, modelo indisponível)]
  transcribed  → interpreted   [trigger: intent classification executada]
  transcribed  → failed        [trigger: LLM falhou na classificação]

Transição PROIBIDA:
  failed → ANY  (evento de voz falhado fica registrado para debug; user fala de novo)
```

## 7. Monitoring Thread Status

```
States: active, paused, concluded
Initial: active

Transitions:
  active    → paused      [trigger: user pausa OU sistema detecta inatividade prolongada]
  active    → concluded   [trigger: user encerra OU objetivo atingido]
  paused    → active      [trigger: user reativa]
  paused    → concluded   [trigger: user encerra]

Transição PROIBIDA:
  concluded → ANY  (thread concluída é histórica; novo monitoramento = novo thread)
```
