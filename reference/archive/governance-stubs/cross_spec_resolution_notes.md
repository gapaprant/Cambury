# cross_spec_resolution_notes

## Resolução V1.0 (original)
- Duplicatas de SPEC-006 movidas para archive/spec_006_duplicates/.

## Resolução V1.1 (limpeza estrutural - 2026-04-03)
- 8 stubs de governança movidos para archive/governance-stubs/ por contradizer a camada operacional.
- Motivo: STATE_MACHINE_CANONICAL usava estados incompatíveis com o DDL (INITIATED vs created, DEGRADED, CANCELLED). CONTRACT_CATALOG renomeava contratos definidos no DDL (RedactionPackageV1 vs writing_requests). SPEC_FINAL era índice vazio referenciando Docker/K8s fora do escopo.
- SPEC prevalente para implementação: documentos listados em spc_final/BASELINE_V1_MANIFEST.md.
- Source of truth: unified-ddl.sql > state-machines.md > api-contracts.md > coding-packs > glossary.md.
