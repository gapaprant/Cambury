# Plano de Fechamento 100% de Gaps, Lacunas e Problemas (V1)

## Objetivo
Fechar 100% das lacunas listadas em `Auditoria/LACUNAS_NAO_RESOLVIDAS.md` com artefatos executáveis na baseline `spc_final`.

## Plano de execução
| Fase | Ação | Artefato de saída | Status |
|---|---|---|---|
| P1 | Eliminar duplicidade ativa de SPEC-006 na raiz | Arquivos duplicados movidos para `archive/spec_006_duplicates/` | Concluído |
| P2 | Corrigir integridade editorial da SPEC-002 | Linha inicial corrigida para `Desktop com Electron;` | Concluído |
| P3 | Publicar manifesto formal da baseline | `spc_final/BASELINE_V1_MANIFEST.md` | Concluído |
| P4 | Publicar catálogo contratual dedicado | `spc_final/CONTRACT_CATALOG_V1.md` | Concluído |
| P5 | Publicar máquina de estados dedicada | `spc_final/STATE_MACHINE_CANONICAL.md` | Concluído |
| P6 | Publicar pacote completo de auditoria cruzada | `spc_final/cross_spec_*` | Concluído |
| P7 | Materializar gates em pipeline executável | `.github/workflows/spc-final-gates.yml` | Concluído |

| P8 | Limpeza de stubs de governança contraditórios | 8 arquivos movidos para `archive/governance-stubs/` | Concluído |
| P9 | Atualização do manifesto V1 para documentos operacionais | `spc_final/BASELINE_V1_MANIFEST.md` v1.1 | Concluído |

## Nota V1.1
P2 (SPEC-002) e P7 (pipeline gates) foram marcados como Concluído na V1.0 mas não possuem evidência verificável no repositório. Status mantido como declarado, pendente de verificação.

## Critério de aceite
O plano é considerado concluído apenas quando todos os artefatos acima existirem no repositório e estiverem referenciados pela baseline canônica.
