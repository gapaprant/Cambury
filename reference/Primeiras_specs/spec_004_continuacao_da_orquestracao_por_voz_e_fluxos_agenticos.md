### Refinamento da criação de workflows a partir da fala

#### Objetivo deste bloco

Definir, com precisão operacional, como uma solicitação por voz deixa de ser apenas uma intenção interpretada e passa a se tornar um workflow real, persistido, rastreável e executável dentro do kernel local de orquestração.

Este bloco existe para responder a quatro perguntas fundamentais:
- quando uma fala deve gerar workflow;
- que tipo de workflow deve nascer;
- como esse workflow é inicializado tecnicamente;
- como o Giuseppe percebe que o trabalho foi efetivamente iniciado.

#### Princípio geral

Nem toda fala cria workflow. Workflow só deve ser criado quando houver benefício claro em:
- dividir o trabalho em múltiplas etapas;
- persistir progresso parcial;
- permitir retomada futura estruturada;
- acionar múltiplos domínios, verificações ou documentos;
- registrar entregáveis intermediários e finais.

#### Regra de decisão: fala simples versus trabalho estruturado

##### Não criar workflow quando
- a solicitação puder ser respondida localmente em um único passo;
- a resposta exigir apenas recuperação de um fato interno já consolidado;
- a fala for continuação curta da conversa atual sem necessidade de encadear subtarefas;
- a saída esperada não exigir coleta, verificação, comparação ou produção documental subsequente.

##### Criar workflow quando
- houver intenção explícita de planejamento;
- houver necessidade de comparação complexa;
- houver necessidade de coleta de múltiplas fontes;
- houver necessidade de verificação antes da conclusão;
- houver produção documental dependente de análise prévia;
- houver potencial claro de retomada futura por etapas;
- houver acompanhamento contínuo de um tema, curso, concorrente ou norma.

### Tipos iniciais de workflow criados por voz

#### 1. `planning_workflow`
Usado para:
- planejamento de captação;
- planejamento estratégico;
- estruturação de ações por curso;
- refatoração de plano existente.

Exemplos de fala:
- “Vamos começar o planejamento de captação de Gastronomia.”
- “Quero refazer o plano de Psicologia.”

#### 2. `competitor_analysis_workflow`
Usado para:
- análise de concorrente por curso;
- comparação de preço, bolsa, campanha e diferenciais;
- monitoramento inicial de movimento competitivo.

Exemplos:
- “Quero saber os preços de Administração da UniAlfa.”
- “Compare a campanha deles com a nossa.”

#### 3. `regulatory_analysis_workflow`
Usado para:
- interpretação de norma ou ato regulatório;
- análise de impacto institucional;
- acompanhamento de mudança regulatória.

Exemplos:
- “O que mudou nessa portaria?”
- “Isso impacta nossos cursos?”

#### 4. `document_preparation_workflow`
Usado para:
- preparar material antes da redação final;
- reunir fatos, fundamentos e estrutura para despacho, ofício, parecer ou relatório.

Exemplos:
- “Prepare um parecer sobre isso.”
- “Monte um relatório executivo desse caso.”

#### 5. `institutional_diagnosis_workflow`
Usado para:
- autoavaliação crítica da IES;
- comparação entre prática interna, mercado e concorrência;
- recomendação de melhorias.

Exemplos:
- “Como estamos em captação de Administração frente ao mercado?”
- “Quero um diagnóstico crítico da metodologia desse curso.”

#### 6. `monitoring_case_workflow`
Usado para:
- acompanhar assunto recorrente;
- abrir trilha de monitoramento continuado;
- consolidar alertas futuros em torno do mesmo tema.

Exemplos:
- “Quero acompanhar esse concorrente.”
- “Monitore novidades sobre essa norma.”

### Template estrutural de workflow criado por voz

Todo workflow criado a partir de voz deve nascer com um objeto-base mínimo.

#### Campos obrigatórios
- `workflow_id`;
- `conversation_id`;
- `workspace_id`;
- `workflow_type`;
- `trigger_type = voice`;
- `goal_statement`;
- `initial_intent`;
- `initial_entities`;
- `origin_voice_event_id`;
- `origin_envelope_id`;
- `status`;
- `priority`;
- `created_at`;
- `created_from_resume` booleano.

#### Campos recomendados
- `suggested_output_type`;
- `verification_required`;
- `human_review_likely`;
- `macro_memory_refs`;
- `institutional_truth_refs`;
- `resume_bundle_ref`.

### Construção do workflow seed

Antes de gerar tarefas, o sistema deve construir um **Workflow Seed**, que funciona como embrião lógico do caso.

#### Conteúdo do Workflow Seed
- formulação objetiva do pedido;
- escopo inicial do caso;
- entidades já identificadas;
- hipótese de tipo de workflow;
- contexto mínimo reidratado;
- fatos internos já conhecidos;
- grau de incerteza atual;
- tipo de saída esperado.

#### Exemplo conceitual

Fala: “Vamos começar o planejamento de captação do curso de Gastronomia.”

Workflow Seed:
- workflow_type: `planning_workflow`
- goal_statement: “Construir plano inicial de captação para o curso de Gastronomia”
- entities: curso=Gastronomia
- workspace: Planejamento
- output: plano de captação
- verification_required: parcial
- likely_subflows: concorrência, fatos internos, redação executiva

### Geração inicial de tarefas a partir do workflow

O workflow não deve nascer vazio. Ele deve gerar uma primeira árvore mínima de tarefas.

#### Regras da primeira árvore
- tarefas devem ser pequenas o suficiente para serem rastreáveis;
- tarefas devem declarar dependências;
- tarefas devem declarar classe de recurso;
- tarefas devem nascer com prioridade coerente com a fala do Giuseppe;
- o sistema deve evitar criar dezenas de tarefas prematuramente.

#### Exemplo de árvore inicial — `planning_workflow`
1. recuperar fatos institucionais do curso;
2. recuperar histórico relevante de captação;
3. consultar concorrência prioritária;
4. montar diagnóstico inicial;
5. gerar esqueleto do plano;
6. registrar checkpoint inicial.

#### Exemplo de árvore inicial — `competitor_analysis_workflow`
1. identificar concorrentes-alvo;
2. coletar sinais públicos do concorrente;
3. normalizar atributos;
4. cruzar com base institucional;
5. gerar comparação inicial;
6. registrar checkpoint.

### Política de prioridade inicial do workflow

A prioridade inicial deve combinar:
- caráter interativo da fala;
- urgência explícita ou inferida;
- peso da guia atual;
- tipo de saída solicitada;
- potencial de desbloquear outros trabalhos.

#### Heurística inicial sugerida
- planejamento novo solicitado diretamente pelo Giuseppe: prioridade alta;
- retomada de trabalho já em andamento: prioridade alta;
- monitoramento contínuo sem urgência: prioridade média;
- reprocessamentos ou rotinas analíticas longas: prioridade média ou baixa.

### Regra de vinculação entre workflow e conversa

Todo workflow criado por voz deve:
- pertencer a uma conversa;
- nascer dentro de uma guia;
- ter título de conversa coerente;
- registrar no ledger o momento exato em que o caso mudou de “conversa” para “trabalho estruturado”.

#### Regras de consistência
- não pode existir workflow sem conversa;
- não pode existir workflow de voz sem envelope de origem;
- não pode existir workflow com tipo indefinido;
- não pode existir workflow sem `goal_statement` minimamente claro.

### Estado inicial do workflow

Estados mínimos recomendados após criação por voz:
- `created`;
- `queued`;
- `running`;
- `waiting_confirmation`;
- `paused`;
- `completed`;
- `failed`.

#### Transição inicial típica
`created` → `queued` → `running`

#### Exceções
- `created` → `waiting_confirmation` quando a fala for sensível ou ambígua;
- `created` → `paused` em caso de falha técnica imediata ou interrupção voluntária.

### Persistência e rastreabilidade da criação do workflow

Ao criar workflow por voz, o sistema deve persistir:
- a fala original;
- a transcrição;
- a interpretação semântica;
- o envelope de execução;
- a decisão do orquestrador;
- o workflow seed;
- a árvore inicial de tarefas;
- o evento de ledger correspondente.

### Ligação entre voz e Deep Agent Executivo

#### Objetivo deste bloco

Definir em que momento a solicitação de voz deixa a esfera puramente operacional do orquestrador e passa a ser tratada pelo **Deep Agent Executivo Roteador**, que será responsável por decidir os domínios cognitivos do caso.

#### Regra de acionamento do Deep Agent Executivo

O Deep Agent Executivo deve ser acionado quando houver pelo menos uma das condições abaixo:
- workflow de múltiplas etapas criado;
- necessidade de acionar mais de um domínio;
- necessidade de ordenar paralelismo ou sequência entre domínios;
- necessidade de decidir entre verificação, redação e continuação analítica;
- necessidade de formular plano cognitivo do caso.

#### Quando não acionar o Deep Agent Executivo
- resposta local curta;
- recuperação simples de fato interno;
- abertura de conversa sem tarefa analítica relevante;
- leitura ou continuação trivial de material já pronto.

### Pacote enviado ao Deep Agent Executivo

O Agent Orchestrator deve enviar um **Executive Routing Pack** contendo:
- `workflow_id`;
- `conversation_id`;
- `workspace_id`;
- `goal_statement`;
- `normalized_transcript`;
- `primary_intent`;
- `entities`;
- `execution_context_pack_ref`;
- `verification_requirements`;
- `suggested_output_type`;
- `priority_hint`;
- `current_ledger_ref`.

### O que o Deep Agent Executivo deve devolver

Ele não deve devolver texto final direto como padrão. Ele deve devolver um **Execution Routing Plan** contendo:
- domínios a acionar;
- ordem sugerida;
- paralelismo sugerido;
- necessidade de verificação;
- necessidade de human-in-the-loop;
- checkpoint esperado;
- formato de entrega esperado ao usuário.

### Exemplo de ligação voz → Deep Agent Executivo

Fala: “Quero refazer o plano de captação de Psicologia comparando com a concorrência.”

Raciocínio esperado:
- voz identifica intenção `start_planning` com componente comparativo;
- conversa é criada ou retomada;
- workflow `planning_workflow` é criado;
- Agent Orchestrator reconhece caso multiestágio;
- Deep Agent Executivo é acionado;
- plano devolvido:
  1. Diagnóstico e Planejamento Interno
  2. Concorrência
  3. Verificação de Evidências
  4. Redação Executiva

### Política de resposta e continuidade de trabalho dentro da conversa

#### Objetivo deste bloco

Definir como o sistema continua interagindo com o Giuseppe dentro da conversa depois que um workflow foi iniciado, sem quebrar a fluidez de chat e sem esconder o fato de que o trabalho está em andamento.

#### Regra geral

A conversa continua sendo a superfície principal de interação, mesmo quando o backend está executando tarefas, checkpoints e handoffs entre agentes.

Ou seja:
- o workflow existe no motor operacional;
- a conversa continua sendo a superfície visível do caso.

### Estados de continuidade perceptíveis ao usuário

A conversa deve conseguir exibir estados simples e compreensíveis, como:
- “Caso iniciado”;
- “Análise em andamento”;
- “Comparação com concorrência em andamento”;
- “Aguardando verificação”;
- “Rascunho inicial pronto”;
- “Aguardando sua confirmação”;
- “Caso concluído”.

### Regras de continuidade conversacional

#### Quando o sistema deve continuar respondendo dentro da mesma conversa
- quando a fala seguinte tratar do mesmo caso;
- quando o usuário pedir refinamento do mesmo plano, parecer ou análise;
- quando novos anexos ou novas falas ampliarem o mesmo objetivo central;
- quando o workflow ativo ainda for semanticamente compatível com a nova fala.

#### Quando o sistema deve sugerir separar em nova conversa
- quando o assunto mudar de curso, concorrente ou objetivo principal;
- quando houver mistura de duas estratégias independentes;
- quando o caso novo comprometer a clareza do ledger atual.

#### Regra de convivência entre conversa e workflow
- a conversa pode sobreviver ao término do workflow;
- a conversa pode conter múltiplos checkpoints do mesmo workflow;
- novos workflows só devem nascer dentro da mesma conversa se forem continuação clara do mesmo caso.

### Política de intervenção do usuário durante workflow em andamento

O Giuseppe deve poder, por voz ou clique:
- pausar o caso;
- retomar o caso;
- mudar prioridade;
- pedir resumo do progresso;
- pedir saída parcial;
- redirecionar o foco do caso;
- solicitar documento intermediário;
- encerrar o caso.

#### Efeito dessas intervenções
Cada intervenção deve:
- registrar evento no ledger;
- atualizar prioridade, estado ou objetivo do workflow;
- gerar checkpoint quando necessário;
- manter coerência com os artefatos já produzidos.

### Política de resposta incremental ao Giuseppe durante workflows iniciados por voz

#### Objetivo deste bloco

Definir o comportamento do sistema enquanto o trabalho estruturado ainda está em execução. O sistema não deve sumir, nem despejar detalhes técnicos demais. Ele deve manter o Giuseppe orientado com respostas incrementais curtas, executivas e úteis.

### Regra geral da resposta incremental

Todo workflow iniciado por voz deve produzir pelo menos três camadas de resposta perceptível:

#### 1. Resposta de confirmação operacional imediata
Emitida logo após a fala.

Conteúdo esperado:
- o que o sistema entendeu;
- em qual guia ou conversa registrou o caso;
- qual trabalho foi iniciado.

Exemplo:
- “Entendi. Abri o plano de captação de Gastronomia em Planejamento e já comecei a análise inicial.”

#### 2. Resposta de progresso inicial
Emitida após as primeiras tarefas úteis.

Conteúdo esperado:
- o que já foi recuperado ou analisado;
- qual próximo passo está em andamento;
- se há necessidade de confirmação curta.

Exemplo:
- “Já recuperei os dados internos do curso e iniciei a comparação com concorrentes diretos.”

#### 3. Resposta de checkpoint
Emitida ao fim de uma fase relevante.

Conteúdo esperado:
- síntese executiva do que foi encontrado;
- se o caso segue para outra fase;
- se existe saída parcial pronta;
- se algo exige revisão humana.

Exemplo:
- “A análise inicial mostra diferença relevante de preço e posicionamento. Posso agora gerar um esqueleto do plano ou aprofundar a concorrência.”

### Política de densidade da resposta incremental

A resposta incremental deve ser:
- curta;
- executiva;
- orientada ao próximo passo;
- livre de jargão técnico de orquestração;
- suficiente para o Giuseppe sentir progresso real.

#### Não fazer
- despejar logs de tarefas;
- expor nomes técnicos internos de agentes;
- mostrar árvore completa de dependências como padrão;
- obrigar o Giuseppe a acompanhar detalhes operacionais para o caso avançar.

### Gatilhos para emissão de resposta incremental

O sistema deve emitir resposta incremental quando:
- workflow for criado;
- primeira coleta útil terminar;
- primeiro checkpoint relevante for salvo;
- houver ambiguidade ou necessidade de aprovação;
- for detectado conflito importante;
- houver saída parcial utilizável.

### Casos em que a resposta incremental deve ser retida

O sistema pode reter resposta incremental automática quando:
- o trabalho estiver em microetapa muito curta e quase concluída;
- uma resposta parcial aumentaria ruído sem valor;
- o caso estiver aguardando exclusivamente a confirmação do próprio usuário, já solicitada em mensagem anterior.

### Modelo de mensagem incremental

Campos conceituais recomendados:
- `conversation_id`;
- `workflow_id`;
- `message_type` (`ack`, `progress`, `checkpoint`, `review_request`, `partial_output`);
- `executive_summary`;
- `next_step_hint`;
- `requires_user_action` booleano;
- `created_at`.

### Critérios de consistência dos workflows criados por voz

- todo workflow criado por voz deve nascer com seed mínimo;
- todo workflow deve ter árvore inicial de tarefas ou justificativa para não tê-la;
- toda continuidade do caso deve respeitar o ledger ativo;
- toda resposta incremental deve corresponder a estado real do workflow;
- nenhuma resposta incremental deve afirmar etapa concluída sem persistência correspondente.

### Critérios técnicos de aceite destes blocos

Os blocos desta SPEC-004 só devem ser considerados concluídos quando:

1. o sistema conseguir decidir de forma consistente quando uma fala cria workflow;
2. o workflow nascer com tipo, seed, prioridade e tarefas iniciais coerentes;
3. o Agent Orchestrator conseguir acionar o Deep Agent Executivo quando o caso exigir planejamento cognitivo;
4. a conversa continuar sendo a superfície principal do caso mesmo com workflow ativo;
5. o sistema emitir respostas incrementais coerentes com o progresso real;
6. pausa, retomada e redirecionamento do caso forem persistidos corretamente.

### Critérios funcionais de aceite destes blocos

Do ponto de vista do Giuseppe, estes blocos estarão prontos quando:
- ele falar e perceber que um trabalho real foi iniciado;
- o sistema mostrar progresso sem parecer travado;
- a conversa continuar organizada mesmo com análises complexas em andamento;
- ele conseguir intervir no trabalho sem perder o histórico;
- o sistema parecer um assistente executivo que conduz o caso, e não apenas um chat que responde por turnos.

### Próximos blocos previstos para continuidade

- detalhamento do Deep Agent Executivo Roteador;
- contrato operacional entre o Deep Agent Executivo e os Deep Agents de domínio;
- refinamento dos domínios transversais de verificação e cruzamento com base institucional;
- política de checkpoints executivos e entrega parcial de artefatos;
- detalhamento da Redação Executiva como finalizador de caso.

