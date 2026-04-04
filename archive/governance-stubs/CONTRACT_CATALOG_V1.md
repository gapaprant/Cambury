# CONTRACT_CATALOG_V1

| Contrato | Origem | Destino | Campos mínimos |
|---|---|---|---|
| VoiceExecutionEnvelopeV1 | Frontend | API Local | schema_version, envelope_id, conversation_id, workspace_id, utterance, locale, created_at |
| ExecutionContextPackV1 | API Local | Orchestration Core | schema_version, conversation_id, workspace_id, intent, risk_level, trace_id |
| ExecutiveRoutingPackV1 | Orchestration Core | Deep Agent Executivo | schema_version, workflow_id, goals, constraints, priority, trace_id |
| DomainAssignmentPackV1 | Deep Agent Executivo | Domain Runtime | schema_version, workflow_id, domain, tasks, evidence_policy, trace_id |
| DomainResultPackageV1 | Domain Runtime | Orchestration Core | schema_version, workflow_id, findings, evidence_refs, confidence, trace_id |
| VerificationDecisionV1 | Verification Engine | Orchestration Core | schema_version, workflow_id, status, rationale, approver, trace_id |
| RedactionPackageV1 | Orchestration Core | Document Engine | schema_version, workflow_id, target_doc_type, approved_facts, trace_id |
