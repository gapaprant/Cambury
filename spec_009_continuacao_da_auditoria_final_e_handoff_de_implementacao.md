### Auditoria final cruzada das SPECs

#### Objetivo deste bloco

Executar a verificação final cruzada entre as SPECs já produzidas, com foco em eliminar contradições, duplicidades, lacunas de contrato e divergências de nomenclatura antes do congelamento definitivo da baseline documental V1.

A auditoria final cruzada não é uma revisão estética. Ela é um mecanismo de redução de risco de implementação.

### Escopo da auditoria cruzada

A auditoria deve cobrir, no mínimo, a relação entre:
- SPEC-001 como base macro consolidada do produto;
- SPEC-003 como base do protocolo de persistência de contexto e voz inicial;
- SPEC-004 como base de workflows iniciados por voz e continuidade de trabalho;
- SPEC-005 como base de coordenação cognitiva central;
- SPEC-006 como base dos domínios primários, domínios transversais e monitoramento contínuo;
- SPEC-007 como base de milestones, gathering results e auditoria final de consistência;
- SPEC-008 como base do congelamento documental e do pacote final de implementação.

### Eixos obrigatórios da auditoria cruzada

#### 1. Nomenclatura
Verificar se os mesmos conceitos usam o mesmo nome em todas as SPECs.

Itens críticos:
- conversa;
- guia/workspace;
- workflow;
- task;
- session ledger;
- compact summary;
- resume bundle;
- Voice Execution Envelope;
- Execution Context Pack;
- Executive Routing Pack;
- Domain Assignment Pack;
- Domain Result Package;
- checkpoint executivo;
- monitoring thread;
- baseline documental V1.

#### 2. Contratos
Verificar se cada contrato citado possui:
- origem explícita;
- destino explícito;
- finalidade operacional;
- campos mínimos coerentes;
- relação com persistência.

#### 3. Estados
Verificar consistência entre:
- estados de conversa;
- estados de workflow;
- estados de verificação;
- estados de aderência institucional;
- estados de release/redação;
- estados de monitoramento.

#### 4. Persistência
Verificar se cada artefato relevante tem:
- ponto claro de criação;
- atualização controlada;
- vínculo com conversa ou workflow;
- política mínima de retenção;
- compatibilidade com a trilha de auditoria.

#### 5. Dependências de implementação
Verificar se nenhum componente depende de outro ainda não suficientemente definido.

#### 6. Critérios de aceite
Verificar se os critérios técnicos e funcionais permanecem coerentes entre fases, milestones e blocos detalhados.

### Matriz de severidade da auditoria cruzada

#### `critical`
- quebra contrato entre módulos;
- gera implementação incompatível;
- permite conclusão errada em caso sensível;
- causa conflito entre duas SPECs sobre o mesmo comportamento central.

#### `major`
- cria ambiguidade importante;
- permite duas interpretações concorrentes do mesmo fluxo;
- dificulta handoff para contractors ou agentes de codificação.

#### `minor`
- diferença editorial, redundância leve, nome alternativo ainda recuperável sem risco estrutural.

### Artefatos formais da auditoria cruzada

- `cross_spec_audit_report`
- `cross_spec_glossary`
- `cross_spec_contract_map`
- `cross_spec_state_matrix`
- `cross_spec_dependency_matrix`
- `cross_spec_issue_log`
- `cross_spec_resolution_notes`

### Regras de resolução de inconsistências

#### Regra 1 — Prevalência da versão mais recente e mais específica
Quando duas SPECs tratarem do mesmo bloco, prevalece a versão mais recente e mais operacionalmente detalhada, salvo decisão explícita em contrário.

#### Regra 2 — Correção sempre registrada
Toda resolução deve entrar em `cross_spec_resolution_notes` com:
- item afetado;
- SPEC de origem;
- SPEC prevalente;
- justificativa;
- impacto.

#### Regra 3 — Volta ao glossário canônico
Toda correção de termo deve atualizar o glossário canônico e o catálogo de contratos/estados correspondente.

### Baseline documental V1

#### Objetivo deste bloco

Transformar o conjunto das SPECs auditadas em uma linha base única, estável e pronta para implementação.

A baseline documental V1 é o ponto a partir do qual:
- contractors recebem escopo fechado;
- agentes de codificação recebem contexto segmentado;
- futuras mudanças passam a ser tratadas como change requests e não como continuação informal da especificação.

### Conteúdo mínimo da baseline V1

#### 1. Documento mestre de índice
Deve conter:
- lista ordenada das SPECs válidas;
- resumo da função de cada SPEC;
- ponto de continuidade entre documentos;
- mapa de leitura por perfil (arquitetura, backend, UI, agentes, documentos, governança).

#### 2. Glossário canônico V1
Deve conter:
- termos consolidados;
- definição curta de cada termo;
- equivalências proibidas ou descontinuadas;
- referência cruzada com contratos e estados.

#### 3. Catálogo de contratos V1
Deve conter:
- contrato;
- origem;
- destino;
- campos mínimos;
- artefato persistido relacionado;
- SPEC de referência principal.

#### 4. Catálogo de estados V1
Deve conter:
- estados de conversa;
- estados de workflow;
- estados de verificação;
- estados de aderência institucional;
- estados de redação/release;
- estados de monitoramento.

#### 5. Mapa de milestones V1
Deve conter:
- milestones consolidados;
- dependências;
- critérios de aceite;
- workstreams afetados.

#### 6. Resolution log V1
Deve conter:
- inconsistências resolvidas;
- blocos que prevaleceram;
- renomeações;
- decisões finais de freeze.

### Regras da baseline V1

- nenhuma decisão central pode ficar apenas em conversa solta;
- nenhum contrato novo pode ser usado por implementação sem entrar no catálogo;
- nenhuma alteração pós-freeze pode ser aplicada sem change log;
- a baseline deve ser suficiente para implementação sem depender do histórico integral do chat.

### Pacote de handoff para implementação humana

#### Objetivo deste bloco

Montar a entrega final voltada a contractors e equipe humana de implementação, com organização prática por responsabilidade de execução.

### Estrutura do pacote de handoff humano

#### 1. Executive Brief
Conteúdo:
- visão do produto;
- objetivo do MVP;
- escopo fechado;
- riscos centrais;
- princípios obrigatórios.

Uso:
- alinhamento inicial com lideranças, sponsor técnico e contractors.

#### 2. Architecture Brief
Conteúdo:
- arquitetura macro;
- topology do runtime local;
- componentes principais;
- interação entre voz, orquestrador, agentes, verdade institucional e documentos.

Uso:
- arquitetos, líderes técnicos, backend leads.

#### 3. Implementation Workstream Pack
Conteúdo:
- workstreams consolidados;
- dependências;
- milestones vinculados;
- critérios mínimos por workstream.

Uso:
- planejamento de execução humana.

#### 4. Contracts and Data Pack
Conteúdo:
- entidades centrais;
- contratos operacionais;
- estados;
- persistência;
- relação entre banco e storage.

Uso:
- backend, integração, persistência, auditoria.

#### 5. UI and Interaction Pack
Conteúdo:
- guias;
- conversas;
- busca;
- anexos;
- voz;
- resposta incremental;
- checkpoints executivos visíveis.

Uso:
- frontend e UX.

#### 6. Cognitive and Governance Pack
Conteúdo:
- Agent Orchestrator;
- Deep Agent Executivo;
- domínios primários e transversais;
- verificação multiestágio;
- aderência institucional;
- HITL.

Uso:
- equipe de agentes, backend cognitivo, governança.

#### 7. Documents and Delivery Pack
Conteúdo:
- modelos documentais;
- checkpoints;
- revisão formal;
- exportação;
- impressão.

Uso:
- document engine e entrega final.

#### 8. Pilot Pack
Conteúdo:
- milestones finais;
- gathering results;
- cenários de demonstração;
- critérios de sucesso mínimo;
- plano de piloto assistido.

Uso:
- validação real do MVP.

### Artefatos do handoff humano

- `contractor_handoff_index`
- `contractor_architecture_brief`
- `contractor_workstream_backlog`
- `contractor_contracts_and_data_pack`
- `contractor_ui_pack`
- `contractor_governance_pack`
- `contractor_pilot_pack`

### Pacote de contexto para agentes de codificação

#### Objetivo deste bloco

Preparar contexto segmentado, enxuto e operacional para agentes de codificação trabalharem por componente sem alucinação por excesso de escopo ou falta de fronteira.

A lógica aqui é diferente da documentação humana: agentes de codificação precisam de contexto menor, mas extremamente estruturado.

### Princípios do pacote para agentes de codificação

- contexto segmentado por componente;
- contratos explícitos;
- entidades e estados mínimos;
- limites do que o agente pode assumir;
- critérios de aceite locais;
- dependências declaradas;
- sem exigir leitura do corpus completo das SPECs para cada tarefa.

### Unidade mínima de contexto para agente de codificação

Cada pacote de contexto deve conter:
- nome do componente;
- papel do componente;
- inputs aceitos;
- outputs obrigatórios;
- entidades relevantes;
- estados relevantes;
- contratos envolvidos;
- persistência necessária;
- dependências externas e internas;
- critérios de aceite locais;
- limites de escopo.

### Tipos de Coding Context Pack

#### 1. Foundation Coding Pack
Para:
- shell desktop;
- bootstrap;
- health checks;
- logs;
- config;
- lifecycle do app.

#### 2. Conversation Coding Pack
Para:
- workspaces;
- conversas;
- mensagens;
- busca;
- anexos;
- auditoria inicial.

#### 3. Voice Coding Pack
Para:
- captura de áudio;
- STT;
- normalização;
- intenção;
- resolução de conversa;
- envelopes de voz.

#### 4. Context Persistence Coding Pack
Para:
- ledgers;
- compaction;
- resume bundle;
- handoff artifacts;
- workflow checkpoints.

#### 5. Orchestration Coding Pack
Para:
- Agent Orchestrator;
- workflow seed;
- tasks;
- prioridade;
- fairness;
- pause/resume/cancel.

#### 6. Institutional Truth Coding Pack
Para:
- fatos canônicos;
- documentos-fonte;
- precedência;
- conflito;
- views derivadas.

#### 7. Domain Agent Coding Pack
Para:
- Deep Agent Executivo;
- Concorrência;
- Regulação e Normas;
- Diagnóstico e Planejamento Interno;
- Verificação;
- Redação Executiva.

#### 8. Monitoring Coding Pack
Para:
- monitoring threads;
- radares;
- classificação de sinais;
- alertas;
- gatilhos de caso.

#### 9. Documents Coding Pack
Para:
- templates;
- renderização;
- revisão formal;
- exportação;
- impressão.

### Regras do contexto para agentes de codificação

#### Regra 1 — Escopo fechado por pacote
O agente não deve inferir funcionalidades fora do pacote entregue.

#### Regra 2 — Contrato acima de improviso
Se um contrato estiver definido, o agente não deve substituí-lo por estrutura alternativa sem registrar proposta de alteração.

#### Regra 3 — Critério de aceite local obrigatório
Cada pacote precisa terminar com critérios verificáveis.

#### Regra 4 — Dependências explícitas
O agente deve saber exatamente do que depende antes de implementar.

### Artefatos do pacote para agentes

- `coding_context_pack_foundation`
- `coding_context_pack_conversations`
- `coding_context_pack_voice`
- `coding_context_pack_context_persistence`
- `coding_context_pack_orchestration`
- `coding_context_pack_institutional_truth`
- `coding_context_pack_domain_agents`
- `coding_context_pack_monitoring`
- `coding_context_pack_documents`

### Consolidação editorial final em versão única externa

#### Objetivo deste bloco

Opcionalmente produzir uma versão única, mais limpa e linear, para consumo externo por parceiros, consultores ou equipes que não precisam navegar por múltiplas SPECs em sequência.

Essa consolidação editorial não substitui a baseline fragmentada e indexada. Ela é uma camada derivada de apresentação.

### Estrutura recomendada da versão única externa

1. visão geral do produto;
2. requisitos consolidados;
3. arquitetura macro;
4. arquitetura operacional por camadas;
5. persistência de contexto;
6. voz e interação;
7. orquestração e workflows;
8. domínios primários e transversais;
9. governança e verificação;
10. monitoramento e alertas;
11. documentos e entrega;
12. milestones e gathering results.

### Regras da versão externa

- linguagem editorialmente uniforme;
- sem duplicidade entre seções;
- sem referências confusas ao histórico do chat;
- com índice claro;
- com glossário anexo;
- com apêndice opcional de contratos e estados.

### Critérios de conclusão desta continuação

A SPEC-009 estará concluída quando:
- a auditoria final cruzada estiver definida operacionalmente;
- a baseline documental V1 estiver descrita como linha base formal;
- o pacote de handoff humano estiver estruturado;
- o pacote de contexto para agentes de codificação estiver estruturado;
- a consolidação editorial externa estiver modelada como derivado opcional;
- os próximos passos finais até o handoff completo estiverem claros.

### Próximos passos previstos para continuidade

- executar a auditoria final cruzada na prática;
- gerar a baseline documental V1;
- derivar os packs finais de handoff humano;
- derivar os coding context packs por componente;
- montar a versão editorial externa, se desejado;
- fechar o pacote final para implementação.

