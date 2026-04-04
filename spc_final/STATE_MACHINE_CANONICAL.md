# STATE_MACHINE_CANONICAL

## Workflow
| Estado Atual | Evento | Próximo Estado | Guarda |
|---|---|---|---|
| INITIATED | start_execution | RUNNING | tasks >= 1 |
| RUNNING | request_input | WAITING_INPUT | blocker definido |
| WAITING_INPUT | user_reply | RUNNING | input válido |
| RUNNING | partial_failure | DEGRADED | checkpoint salvo |
| DEGRADED | retry_success | RUNNING | healthcheck ok |
| RUNNING | send_for_verification | VERIFICATION_PENDING | evidências mínimas presentes |
| VERIFICATION_PENDING | approve | COMPLETED | decisão assinada |
| VERIFICATION_PENDING | reject | RUNNING | task corretiva criada |
| * | fatal_error | FAILED | erro crítico registrado |
| * | cancel | CANCELLED | ator e motivo registrados |

## Conversation
| Estado Atual | Evento | Próximo Estado |
|---|---|---|
| ACTIVE | pause | PAUSED |
| PAUSED | resume | ACTIVE |
| ACTIVE/PAUSED | archive | ARCHIVED |
| ARCHIVED | reopen | ACTIVE |
| * | close | CLOSED |
