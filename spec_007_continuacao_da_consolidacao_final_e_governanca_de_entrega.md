### Consolidação final de Milestones

#### Objetivo deste bloco

Transformar o conjunto das SPECs em uma trilha única de execução, sem retrabalho, sem sobreposição ambígua de fases e sem lacunas entre arquitetura, implementação e critérios de aceite.

Os milestones abaixo não substituem o roadmap macro já definido na SPEC-001. Eles o consolidam e o conectam explicitamente aos blocos detalhados das SPECs de continuação.

### Princípio de consolidação dos milestones

Cada milestone deve obedecer a cinco regras:
- ter escopo fechado;
- ter dependências explícitas;
- ter demonstração prática de aceite;
- ter artefatos concretos entregáveis;
- reduzir incerteza estrutural para o milestone seguinte.

### M0 — Documentation Freeze and Traceability Baseline

#### Objetivo
Congelar a base documental inicial para que o time implemente sem perder coerência entre as SPECs.

#### Entregas
- índice mestre das SPECs;
- mapa de continuidade entre SPEC-001 a SPEC-007;
- glossário canônico de termos;
- matriz de rastreabilidade requisito ↔ componente ↔ fase ↔ aceite;
- lista de pendências abertas, se restarem.

#### Dependências
- conclusão mínima dos blocos estruturais das SPECs.

#### Aceite
- todas as SPECs possuem encadeamento claro;
- nenhum bloco central do produto depende de interpretação informal da conversa.

### M1 — Local Product Foundation

#### Objetivo
Entregar a base executável local do sistema.

#### Escopo consolidado
- shell desktop;
- backend local;
- bootstrap;
- SQLite;
- diretórios;
- health checks;
- logs;
- instalador;
- ícone;
- startup e shutdown controlados.

#### Artefatos de aceite
- instalador funcional;
- vídeo ou demonstração da instalação;
- checklist de bootstrap;
- logs e endpoints de health funcionando.

### M2 — Core Data and Navigation

#### Objetivo
Transformar o app local em ambiente real de trabalho organizado.

#### Escopo consolidado
- guias do MVP;
- conversas tituladas;
- busca por guia e título;
- mensagens;
- anexos;
- auditoria inicial;
- modelo de dados base.

#### Aceite
- criação, busca, retomada e arquivamento de conversa;
- persistência íntegra após reinício.

### M3 — Context Persistence Protocol

#### Objetivo
Estabelecer continuidade real entre sessões e workflows.

#### Escopo consolidado
- session ledger;
- compaction events;
- resume bundle;
- handoff memory protocol;
- workflow checkpoints;
- post-session learning extractor.

#### Aceite
- retomada de conversa longa sem replay integral;
- handoff entre agentes preservando objetivo e contexto;
- compactação em marcos auditáveis.

### M4 — Voice-first Interaction

#### Objetivo
Tornar voz o principal canal operacional do produto.

#### Escopo consolidado
- push-to-talk;
- transcrição local;
- interpretação semântica;
- escolha de guia;
- abertura ou retomada de conversa;
- sugestão de título;
- confirmação curta;
- persistência dos eventos de voz.

#### Aceite
- criação e retomada de conversa por voz com rastreabilidade;
- baixa dependência de comandos rígidos.

### M5 — Voice-to-Orchestration and Workflow Creation

#### Objetivo
Permitir que a fala do Giuseppe gere trabalho cognitivo real.

#### Escopo consolidado
- Voice Execution Envelope;
- classificação orquestral da solicitação;
- criação de workflow por voz;
- workflow seed;
- árvore inicial de tarefas;
- resposta incremental inicial.

#### Aceite
- uma fala complexa gera workflow persistido, com conversa, ledger e status visíveis.

### M6 — Institutional Truth Layer and Internal Grounding

#### Objetivo
Garantir que o sistema opere sobre realidade institucional versionada.

#### Escopo consolidado
- fatos canônicos;
- ingestão documental interna;
- precedência de fontes;
- views derivadas;
- cruzamento com base institucional.

#### Aceite
- respostas institucionais rastreáveis a fatos e documentos;
- conflitos internos sinalizados.

### M7 — Executive Coordination and Domain Agents

#### Objetivo
Colocar em operação a coordenação cognitiva central do sistema.

#### Escopo consolidado
- Deep Agent Executivo;
- Domain Assignment Pack;
- Domain Result Package;
- checkpoints executivos;
- Redação Executiva como finalizador controlado.

#### Aceite
- caso composto com dois ou mais domínios coordenados de forma consistente.

### M8 — Primary Domains Operationalization

#### Objetivo
Entregar os domínios primários como Deep Agents operacionais reais.

#### Escopo consolidado
- Concorrência;
- Regulação e Normas;
- Diagnóstico e Planejamento Interno.

#### Aceite
- cada domínio com missão, subagents, skills, workflow, artefatos e estados de qualidade.

### M9 — Transversal Governance and Verification

#### Objetivo
Fechar a camada de governança cognitiva e factual.

#### Escopo consolidado
- Cruzamento com Base de Verdade Institucional;
- Verificação de Evidências;
- verificação multiestágio;
- política de liberação, bloqueio e HITL.

#### Aceite
- nenhuma conclusão sensível chega à redação final sem passar pela governança definida.

### M10 — Monitoring, Curadoria and Alert-triggered Cases

#### Objetivo
Colocar o sistema em estado de inteligência contínua.

#### Escopo consolidado
- monitoring threads;
- radar regulatório;
- radar da concorrência;
- radar de mercado;
- radar interno-comparativo;
- alertas executivos;
- abertura automática ou semiautomática de casos.

#### Aceite
- o sistema acompanha tema, emite alerta útil e abre caso apenas quando houver justificativa.

### M11 — Document Production and Controlled Release

#### Objetivo
Entregar a produção documental executiva e institucional com segurança.

#### Escopo consolidado
- geração final de documentos;
- checkpoints parciais;
- revisão formal;
- impressão/exportação;
- bloqueios por verificação.

#### Aceite
- parecer, relatório, plano ou despacho gerados com base controlada e formato adequado.

### M12 — Pilot Readiness and Hardening

#### Objetivo
Fechar o ciclo documental com condições reais de uso assistido.

#### Escopo consolidado
- desempenho local;
- retomada após falha;
- estabilidade de voz;
- consistência de memória;
- calibragem de concorrência;
- backup;
- runbook curto de operação.

#### Aceite
- o produto suporta piloto assistido com Giuseppe sem depender de improviso arquitetural.

### Mapa de dependência entre milestones

A ordem recomendada, sem retrabalho, é:

M0 → M1 → M2 → M3 → M4 → M5 → M6 → M7 → M8 → M9 → M10 → M11 → M12

#### Regras de dependência
- M3 depende de M2;
- M4 depende de M2 e M3;
- M5 depende de M4;
- M6 pode começar em paralelo ao final de M4, mas só sustenta M7 em diante quando estabilizado;
- M7 depende de M5 e M6;
- M8 depende de M7;
- M9 depende de M6 e M8;
- M10 depende de M8 e M9;
- M11 depende de M7 e M9;
- M12 depende de todos os anteriores em estado minimamente estável.

### Critério de “não retrabalho” entre milestones

Nenhum milestone deve começar em modo de implementação plena se o anterior ainda não definiu:
- entidades centrais;
- contratos de entrada e saída;
- estados do workflow;
- critérios mínimos de aceite;
- persistência correspondente.

### Consolidação final de Gathering Results

#### Objetivo deste bloco

Definir como o sucesso do produto será avaliado após implementação e piloto, usando critérios observáveis, comparáveis e úteis para decisão.

### Eixos de avaliação

#### Eixo 1 — Usabilidade executiva
Pergunta central:
- o Giuseppe consegue operar o sistema com naturalidade e controle?

Indicadores sugeridos:
- taxa de criação correta de conversa por voz;
- taxa de retomada correta de conversa;
- quantidade de confirmações curtas por sessão;
- tempo até iniciar um caso útil;
- necessidade de correção manual do título ou da guia.

#### Eixo 2 — Continuidade de contexto
Pergunta central:
- o sistema realmente preserva contexto útil entre sessões?

Indicadores sugeridos:
- taxa de retomada bem-sucedida sem replay bruto;
- proporção de casos com ledger consistente;
- taxa de handoffs sem perda de objetivo;
- frequência de reexplicação manual pelo usuário.

#### Eixo 3 — Qualidade cognitiva e factual
Pergunta central:
- o sistema raciocina com base suficiente e governança adequada?

Indicadores sugeridos:
- taxa de conclusões bloqueadas corretamente por conflito ou lacuna;
- taxa de outputs aceitos sem correção factual relevante;
- número de conflitos detectados antes da redação;
- taxa de aderência à Base de Verdade Institucional.

#### Eixo 4 — Qualidade documental
Pergunta central:
- os documentos produzidos são utilizáveis com padrão executivo?

Indicadores sugeridos:
- taxa de documentos aprovados com pouca ou nenhuma reescrita;
- tempo até obter versão final utilizável;
- quantidade média de revisões por tipo documental;
- aderência a template e objetividade.

#### Eixo 5 — Inteligência externa útil
Pergunta central:
- o monitoramento gera valor executivo real?

Indicadores sugeridos:
- quantidade de alertas considerados úteis;
- taxa de sinais fracos descartados corretamente;
- taxa de alertas que geraram decisão, documento ou workflow;
- percepção de utilidade dos radares regulatório, concorrencial e de mercado.

#### Eixo 6 — Segurança operacional e governança
Pergunta central:
- o sistema reduz improvisação em temas sensíveis?

Indicadores sugeridos:
- taxa de casos sensíveis enviados a verificação e/ou HITL;
- ausência de documentos conclusivos liberados com `verification_status = red`;
- rastreabilidade entre saída e evidência;
- conformidade com política de bloqueio e liberação.

#### Eixo 7 — Desempenho e robustez local
Pergunta central:
- o sistema é estável no computador real do Giuseppe?

Indicadores sugeridos:
- tempo de abertura do app;
- tempo médio de transcrição;
- tempo médio de montagem de contexto;
- recuperação após reinício;
- consumo de recursos em uso prolongado.

### Métodos de coleta para Gathering Results

- logs estruturados;
- trilha de auditoria;
- amostras de documentos gerados;
- histórico de aprovação/rejeição;
- análise de checkpoints;
- revisão supervisionada do piloto;
- entrevistas curtas com o usuário principal após uso real.

### Janela mínima de avaliação

A avaliação do MVP não deve ser concluída apenas em demonstração pontual. Recomenda-se uma janela mínima de observação de uso real, com casos distribuídos entre:
- planejamento;
- captação;
- regulação;
- documentos;
- monitoramento.

### Critérios de sucesso mínimo do MVP

O MVP pode ser considerado bem-sucedido quando:
- o Giuseppe conseguir operar o sistema por voz em casos reais;
- a retomada de contexto reduzir reexplicações;
- os documentos gerados economizarem trabalho de redação;
- os alertas e análises externas forem percebidos como úteis;
- a governança evitar conclusões frágeis em casos sensíveis;
- o sistema se mostrar estável o suficiente para uso assistido recorrente.

### Auditoria final de consistência entre SPEC-001, SPEC-003, SPEC-004, SPEC-005, SPEC-006 e SPEC-007

#### Objetivo deste bloco

Garantir que o conjunto documental final possa ser entregue a contratados e agentes de codificação sem contradição estrutural, sem lacunas de contrato e sem ambiguidade de nomenclatura.

### Escopo da auditoria final

A auditoria deve verificar:
- coerência de nomenclatura entre componentes;
- coerência entre fases e milestones;
- coerência entre entidades de dados;
- coerência entre eventos de lifecycle;
- coerência entre estados de workflow;
- coerência entre tipos de saída;
- coerência entre regras de verificação e bloqueio;
- coerência entre monitoramento, alertas, workflows e redação final.

### Checklist mínimo de auditoria

#### 1. Glossário canônico
Validar termos como:
- conversa;
- guia;
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
- checkpoint executivo.

#### 2. Contratos
Conferir se todos os contratos citados possuem:
- origem definida;
- destino definido;
- campos mínimos coerentes;
- uso operacional claro.

#### 3. Estados
Conferir consistência entre estados de:
- conversa;
- workflow;
- verificação;
- alinhamento institucional;
- liberação de redação.

#### 4. Persistência
Conferir se cada artefato relevante possui:
- ponto de criação;
- ponto de atualização;
- relação com conversa e workflow;
- política de retenção mínima.

#### 5. Dependências de implementação
Conferir se nenhum bloco depende de outro ainda não definido documentalmente.

### Artefatos esperados da auditoria final

- `cross_spec_glossary`
- `traceability_matrix`
- `contract_catalog`
- `state_model_catalog`
- `consistency_issue_log`
- `resolution_notes`

### Política de resolução de inconsistência

Quando houver inconsistência entre SPECs:
- prevalece a versão mais recente e mais detalhada do bloco, salvo decisão explícita em contrário;
- a correção deve ser registrada no `resolution_notes`;
- a nomenclatura consolidada deve retornar ao glossário canônico.

### Preparação do pacote final de documentação para implementação

#### Objetivo deste bloco

Preparar a entrega final da arquitetura para equipes humanas e agentes de codificação, minimizando interpretação subjetiva e reduzindo retrabalho de implementação.

### Conteúdo do pacote final

#### 1. Master index
- ordem das SPECs;
- ponto de continuidade entre elas;
- mapa de leitura recomendado.

#### 2. Architecture pack
- visão macro;
- componentes;
- runtime topology;
- fluxos principais;
- taxonomia dos agentes;
- domínios primários e transversais.

#### 3. Contracts pack
- catálogo de envelopes, packs, bundles, results e checkpoints.

#### 4. Data pack
- entidades centrais;
- tabelas;
- índices;
- eventos persistidos;
- artefatos documentais.

#### 5. Workflow pack
- tipos de workflow;
- critérios de criação;
- seeds;
- checkpoints;
- milestones internos;
- regras de bloqueio.

#### 6. Verification and governance pack
- política multiestágio;
- HITL;
- aderência institucional;
- release rules.

#### 7. Delivery pack
- tipos de documento;
- templates;
- checkpoints executivos;
- política de resposta incremental.

#### 8. Pilot pack
- plano de aceite;
- plano de gathering results;
- cenários de demonstração;
- checklist de hardening.

### Próximos passos após a consolidação documental

1. executar auditoria final de consistência;
2. congelar a versão documental V1 do produto;
3. derivar backlog de implementação por workstream;
4. derivar backlog de codificação agentic por componente;
5. preparar pacote de handoff para contractors;
6. preparar pacote de contexto para agentes de codificação.

### Critérios de conclusão documental do projeto

O projeto pode ser considerado 100% especificado quando:
- os blocos centrais do produto estiverem definidos sem lacunas críticas;
- milestones e gathering results estiverem consolidados;
- o pacote final de implementação estiver montado;
- a auditoria entre SPECs tiver sido executada;
- o conjunto puder ser entregue a um time sem depender de explicação oral complementar.

### Próximos blocos previstos para continuidade

- congelamento final da linha documental;
- geração do pacote final consolidado para implementação;
- eventual normalização editorial das SPECs para entrega externa.

