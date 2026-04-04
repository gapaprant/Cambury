# cross_spec_dependency_matrix

| Componente | Depende de |
|---|---|
| Frontend | API Local |
| API Local | Orchestration Core, SQLite |
| Orchestration Core | Domain Runtime, Verification Engine, Document Engine |
| Domain Runtime | SQLite/EventStore |
| Verification Engine | Domain Result Package |
| Document Engine | VerificationDecisionV1 aprovado |
