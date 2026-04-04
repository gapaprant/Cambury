# BASELINE_V1_MANIFEST

```yaml
baseline_id: cambury-v1
version: 1.1.0
updated_at: 2026-04-03
canonical_root: spc_final/
reason: Limpeza estrutural — stubs de governança contraditórios movidos para archive/
canonical_documents:
  - spc_final/CLAUDE.md
  - spc_final/tech-stack.md
  - spc_final/unified-ddl.sql
  - spc_final/mvp-scope.md
  - spc_final/llm-integration.md
  - spc_final/api-contracts.md
  - spc_final/system-prompts.md
  - spc_final/state-machines.md
  - spc_final/glossary.md
  - spc_final/seed-data.sql
  - spc_final/foundation.md
  - spc_final/conversations.md
  - spc_final/voice.md
  - spc_final/packs-4-to-9.md
supplementary_documents:
  - spc_final/BASELINE_V1_MANIFEST.md
  - spc_final/PLANO_FECHAMENTO_GAPS_V1.md
  - spc_final/cross_spec_issue_log.md
  - spc_final/cross_spec_resolution_notes.md
archived_documents:
  - archive/governance-stubs/ (8 arquivos — stubs que contradiziam a camada operacional)
source_of_truth_precedence:
  1. unified-ddl.sql
  2. state-machines.md
  3. api-contracts.md
  4. coding-packs (foundation.md, conversations.md, voice.md, packs-4-to-9.md)
  5. glossary.md
  6. qualquer outro arquivo
change_policy:
  breaking: requer atualização do BASELINE + commit com justificativa
  non_breaking: PR com review
```
