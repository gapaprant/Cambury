registra contexto base usado na abertura.

#### `ConversationResume`

- localiza último ledger válido;
- carrega último compact summary;
- reconstrói o estado ativo do caso.

#### `WorkflowCheckpoint`

- salva estado parcial de fase;
- registra decisões aceitas;
- prepara artefato para handoff ou continuação.

#### `PreCompaction`

- salva estado imediatamente anterior à compactação;
- preserva o material necessário para auditoria ou rollback lógico.

#### `ConversationPause`

- registra ponto seguro de retomada;
- marca blockers e próximo passo esperado.

#### `ConversationClose`

- fecha ledger ativo;
- salva resumo final do caso no estado atual;
- dispara avaliação de aprendizado quando aplicável.

#### `SessionEnd`

- executa reflexão pós-sessão;
- atualiza agent operational memory;
- atualiza preferências executivas quando houver evidência suficiente.

#### `DailyRollover`

- consolida sessões do dia;
- reduz contexto residual;
- preserva apenas resumos necessários para retomadas futuras.

### Strategic compaction and rehydration policy

A compactação não deve ocorrer em pontos arbitrários. Ela deve respeitar marcos lógicos do trabalho.

#### Quando compactar

- após exploração e antes da execução;
- ao concluir checkpoint relevante;
- antes de handoff entre domínios;
- ao encerrar sessão;
- antes de reabrir um caso antigo com muito histórico bruto.

#### Quando não compactar

- no meio de coleta crítica ainda não consolidada;
- no meio de verificação de conflito;
- antes de registrar evidências mínimas do caso;
- durante etapa de escrita final ainda não confirmada pelo verificador.

#### O que entra no compact summary

- objetivo atual;
- fatos aceitos;
- evidências aprovadas;
- decisões;
- blockers;
- abordagens tentadas;
- abordagens que falharam;
- próximo passo recomendado;
- estado de verificação.

#### O que entra no resume bundle

- último session ledger;
- último compact summary;
- macro memory relevante;
- fatos institucionais do tema;
- estado atual de verificação;
- aprendizados operacionais pertinentes;
- traços do perfil executivo relevantes para a tarefa.

#### Regra anti-poluição

- memória antiga não entra automaticamente em caso novo;
- memórias de casos distintos só podem ser reutilizadas se houver vínculo semântico e operacional claro;
- hipóteses rejeitadas não devem voltar como contexto ativo padrão;
- resumos antigos devem carregar validade temporal e escopo.

### Agent handoff memory protocol

Todo handoff entre agentes ou domínios deve transportar mais do que a pergunta literal. O handoff deve sempre carregar:

- query imediata;
- objetivo maior do caso;
- resumo do caso até o momento;
- fatos institucionais relevantes;
- estado de verificação;
- restrições do output;
- lacunas conhecidas;
- referências de evidência já aceitas.

#### Regra de handoff

Sem objetivo maior + estado atual + restrições, o subagent tende a devolver resumo incompleto. Portanto, nenhum handoff deve ocorrer apenas com o texto bruto da solicitação.

### Iterative retrieval and sufficiency loop

O orquestrador não deve aceitar a primeira resposta de um subagent como suficiente por padrão.

Regra:

1. o orquestrador avalia a suficiência do retorno;
2. se o retorno estiver incompleto, gera follow-up orientado;
3. o subagent volta à fonte ou ao seu workflow interno;
4. retorna com novo resumo;
5. no máximo 3 ciclos por tentativa, salvo override explícito do workflow.

Esse padrão vale especialmente para:

- coleta regulatória;
- pesquisa de concorrência;
- consolidação de sinais de mercado;
- verificação de conflito;
- comparação com a base institucional.

### Post-session learning extractor

Ao final de sessões ou checkpoints relevantes, o sistema deve executar uma reflexão operacional para extrair:

- o que funcionou de forma verificável;
- o que falhou;
- que correções foram necessárias;
- que heurísticas devem ser lembradas;
- que padrões devem virar memória de agente;
- que sinais devem atualizar o perfil do Giuseppe.

#### Regra de promoção de aprendizado

- aprendizados operacionais só viram memória reutilizável se houver recorrência, validação ou forte evidência contextual;
- preferências executivas só devem ser atualizadas quando o padrão aparecer com consistência suficiente;
- memória operacional dos agentes nunca pode sobrescrever verdade institucional.

### Persistence-aware workflow rules

Todos os workflows relevantes devem obedecer às seguintes regras:

- cada fase gera um artefato persistido;
- cada output validado vira input formal da próxima fase;
- nenhum workflow longo deve depender apenas de contexto em memória efêmera;
- checkpoints devem existir em fluxos de múltiplas etapas;
- reentrada após pausa ou falha deve reconstruir o estado a partir do ledger e não da conversa bruta.

### Schema additions for context persistence

O modelo de dados desta SPEC deve receber os seguintes artefatos persistidos:

- `session_ledgers`;
- `workflow_checkpoints`;
- `compaction_events`;
- `context_packs`;
- `agent_learnings`;
- `resume_events`;
- `handoff_artifacts`.

### Acceptance criteria for context persistence

O protocolo só deve ser considerado corretamente implementado quando:

- uma conversa longa puder ser retomada sem replay completo do histórico bruto;
- o sistema souber o que funcionou, o que falhou e o que falta fazer;
- handoffs entre agentes preservarem objetivo e contexto suficiente;
- compactações ocorrerem em marcos lógicos e auditáveis;
- aprendizados operacionais reaparecerem em casos futuros relevantes;
- memória operacional jamais sobrescrever a verdade institucional canônica.

### Phase 2 - Voice-first Interaction

#### Objetivo da Phase 2

Transformar voz no principal canal operacional do produto, permitindo que o Giuseppe inicie, continue, redirecione e recupere trabalhos por fala, sem depender de comandos rígidos por palavra-chave e sem comprometer organização, contexto e rastreabilidade.

A Phase 2 deve fazer a ponte entre:

- a estrutura organizada de conversas da Phase 1;
- o modelo de persistência de contexto;
- o futuro Agent Orchestrator;
- a experiência prática de uso por um usuário que prefere falar em vez de digitar.

#### Escopo da Phase 2

A Phase 2 deve entregar:

- captura de voz local com push-to-talk;
- transcrição local offline;
- normalização da transcrição;
- interpretação semântica inicial da intenção;
- identificação de entidades básicas;
- sugestão de guia de destino;
- sugestão de criação ou continuação de conversa;
- sugestão automática de título quando necessário;
- confirmação curta apenas em baixa confiança ou ambiguidade;
- persistência do evento de voz, transcrição e intenção;
- integração com Session Ledger e ConversationStart/ConversationResume.

A Phase 2 ainda não precisa entregar:

- resposta por voz sintetizada madura;
- roteamento agentic completo entre domínios;
- verificação de suficiência avançada;
- classificação profunda multietapas;
- comando por escuta contínua sempre ativa;
- autonomia plena de criação de workflows complexos sem confirmação em casos ambíguos.

#### Resultado esperado da Phase 2

Ao final desta fase, o Giuseppe deve conseguir dizer frases como:

- “Vamos começar o planejamento de captação do curso de Gastronomia.”
- “Quero saber os preços de Administração da UniAlfa.”
- “Abra a conversa do plano de Psicologia.”
- “Continuar o parecer sobre regulação.”

E o sistema deve conseguir:

- entender a intenção geral;
- sugerir ou escolher a guia correta;
- localizar ou criar a conversa correta;
- sugerir um título consistente;
- registrar o evento de voz de forma persistente;
- continuar o caso no lugar certo.

### Princípio de design da voz

A voz não deve ser tratada como sistema de comandos por gatilhos rígidos. O sistema não deve depender de uma lista cadastrada de palavras como “captação”, “preço” ou “planejamento” para funcionar.

A abordagem correta nesta fase é:

- capturar a fala;
- transcrever com fidelidade;
- interpretar semanticamente o desejo do Giuseppe;
- classificar intenção, assunto, escopo e provável guia;
- só pedir confirmação quando a confiança for insuficiente.

### Modelo funcional da interação por voz

#### Push-to-talk como padrão do MVP

Nesta fase, o modo principal deve ser push-to-talk.

Razões:

- reduz acionamentos involuntários;
- dá controle claro ao usuário;
- simplifica privacidade e UX;
- reduz ruído e custo operacional;
- facilita o entendimento do momento exato em que a fala deve ser processada.

#### Ciclo de voz

1. usuário aciona o botão de microfone;
2. o sistema grava o trecho de fala;
3. o áudio é persistido temporariamente;
4. a fala é transcrita localmente;
5. a transcrição é normalizada;
6. o classificador semântico gera hipótese de intenção;
7. o sistema decide se:
   - abre conversa existente;
   - cria nova conversa;
   - pede confirmação curta;
   - ou apenas responde dentro da conversa já aberta;
8. o evento é persistido no ledger e no histórico da conversa.

### Pipeline técnico da voz

#### 1. Audio Capture Layer

Responsabilidades:

- iniciar e parar gravação;
- validar existência do dispositivo de áudio;
- persistir arquivo temporário;
- anexar metadados do evento de captura;
- reportar falha de microfone com mensagem simples.

#### 2. Speech-to-Text Layer

Responsabilidades:

- transcrever localmente em português brasileiro;
- produzir transcrição crua;
- produzir score básico de qualidade quando disponível;
- retornar falha explícita quando o áudio não for inteligível.

#### 3. Transcript Normalization Layer

Responsabilidades:

- limpar ruído textual evidente;
- padronizar espaços, pontuação e capitalização mínima;
- preservar sentido original;
- não “corrigir” o texto a ponto de distorcer a intenção do usuário.

#### 4. Intent Interpretation Layer

Responsabilidades:

- identificar intenção principal;
- detectar intenção secundária quando aplicável;
- detectar entidades centrais;
- sugerir guia provável;
- estimar confiança;
- decidir se há necessidade de confirmação.

#### 5. Conversation Resolution Layer

Responsabilidades:

- localizar conversa em andamento semanticamente compatível;
- avaliar se deve reabrir conversa existente;
- criar nova conversa quando não houver correspondência suficiente;
- sugerir título quando necessário.

#### 6. Persistence Layer

Responsabilidades:

- salvar áudio, transcrição, intenção, entidades, confiança e ação escolhida;
- registrar evento de lifecycle correspondente;
- atualizar Session Ledger.

### Modelo semântico de interpretação

A interpretação semântica da fala deve gerar pelo menos os seguintes campos:

- `primary_intent`
- `secondary_intent`
- `workspace_candidate`
- `conversation_action`
- `entities`
- `confidence_score`
- `requires_confirmation`

#### Intenções primárias iniciais recomendadas

- `start_planning`
- `continue_work`
- `retrieve_conversation`
- `ask_competitor_question`
- `ask_regulatory_question`
- `request_document`
- `request_summary`
- `request_comparison`
- `generic_chat`

#### Ações possíveis sobre conversa

- `create_new`
- `resume_existing`
- `reply_in_current`
- `ask_for_confirmation`
- `reject_due_to_low_signal`

#### Entidades básicas iniciais

- curso;
- concorrente;
- cidade;
- tema;
- documento;
- período;
- programa;
- órgão regulatório.

### Regras de escolha da guia

#### Planejamento

Usar quando a fala indicar:

- início de plano;
- definição de estratégia;
- organização de ação futura;
- avaliação global de um tema;
- desenho de plano por curso.

#### Captação

Usar quando a fala indicar:

- concorrência;
- preço;
- bolsa;
- campanha;
- posicionamento;
- captação por curso;
- comparação de mercado orientada a ingresso.

#### Normas e Regulação

Usar quando a fala indicar:

- lei;
- norma;
- ato;
- MEC;
- e-MEC;
- INEP;
- portaria;
- interpretação regulatória;
- conformidade.

#### Documentos

Usar quando a fala indicar:

- produzir documento;
- revisar texto;
- gerar despacho;
- gerar ofício;
- gerar parecer;
- imprimir/exportar material.

### Política de criação, retomada e continuação de conversa

#### Quando criar nova conversa

- não houver conversa semanticamente compatível;
- o objetivo for claramente novo;
- o título sugerido representar assunto distinto do histórico recente;
- a confiança na abertura de conversa nova for superior à de reuso.

#### Quando retomar conversa existente

- houver correspondência forte por título, tema ou entidades;
- houver caso ativo ou pausado semanticamente próximo;
- a fala indicar continuidade, retomada, revisão ou aprofundamento.

#### Quando responder na conversa atual

- o usuário já estiver dentro de uma conversa aberta;
- a nova fala for continuação natural;
- não houver evidência de mudança de caso.

### Política de sugestão de título

Quando a fala criar nova conversa, o sistema deve sugerir título automaticamente.

#### Regras do título sugerido

- deve ser objetivo;
- deve refletir o caso principal;
- deve incluir curso ou tema quando relevante;
- deve evitar títulos genéricos demais como “conversa nova” ou “assunto importante”;
- deve poder ser confirmado ou ajustado rapidamente.

#### Exemplos de títulos sugeridos

- “Plano de captação — Gastronomia”;
- “Preços de Administração — UniAlfa”;
- “Parecer regulatório — alteração normativa”;
- “Revisão do plano de Psicologia”.

### Política de confirmação curta

A confirmação curta deve ser exceção, não padrão.

#### Confirmar quando

- duas guias tiverem pontuação muito próxima;
- houver mais de uma conversa plausível para retomada;
- a transcrição estiver incompleta ou de baixa qualidade;
- a ação puder causar organização errada do caso.

#### Não confirmar quando

- a intenção estiver clara;
- a correspondência com a conversa existente for forte;
- a guia estiver evidente;
- o risco de erro organizacional for baixo.

#### Modelos de confirmação curta

- “Deseja abrir isso em Captação?”
- “Deseja continuar a conversa ‘Plano de captação — Gastronomia’?”
- “Deseja criar uma nova conversa com este título?”

### Integração com Session Ledger e lifecycle

A Phase 2 deve integrar voz com os eventos já definidos no protocolo de persistência.

#### Em `ConversationStart`

- registrar áudio de origem quando existir;
- salvar transcrição inicial;
- salvar intenção interpretada;
- salvar título confirmado;
- salvar contexto base da abertura.

#### Em `ConversationResume`

- associar a fala ao ledger existente;
- registrar a intenção de retomada;
- persistir a escolha da conversa reaberta;
- atualizar `updated_at` e próximo passo.

#### Em `WorkflowCheckpoint`

- quando a fala gerar mudança clara de fase, registrar checkpoint resumido.

### Contratos operacionais entre voz, intenção e conversa

#### Contrato de entrada do pipeline de voz

- `audio_event_id`;
- `device_id` opcional;
- `captured_at`;
- `audio_path`;
- `workspace_context` opcional;
- `current_conversation_id` opcional.

#### Contrato de saída da transcrição

- `audio_event_id`;
- `raw_transcript`;
- `normalized_transcript`;
- `transcript_quality_score` opcional;
- `language_detected`.

#### Contrato de saída da interpretação semântica

- `primary_intent`;
- `secondary_intent`;
- `workspace_candidate`;
- `conversation_action`;
- `entities`;
- `confidence_score`;
- `requires_confirmation`;
- `suggested_title` opcional.

#### Contrato de saída da resolução de conversa

- `resolved_conversation_id` opcional;
- `action_taken`;
- `created_new_conversation` booleano;
- `title_final` opcional;
- `workspace_final`;
- `ledger_event_created` booleano.

### Modelo de dados complementar da Phase 2

#### Tabelas ou objetos mínimos adicionais

```sql
voice_events (
  id TEXT PRIMARY KEY,
  conversation_id TEXT,
  audio_path TEXT NOT NULL,
  captured_at DATETIME NOT NULL,
  processed_at DATETIME,
  status TEXT NOT NULL
)

voice_transcripts (
  id TEXT PRIMARY KEY,
  voice_event_id TEXT NOT NULL,
  raw_transcript TEXT,
  normalized_transcript TEXT,
  transcript_quality_score REAL,
  language_detected TEXT,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (voice_event_id) REFERENCES voice_events(id)
)

intent_events (
  id TEXT PRIMARY KEY,
  conversation_id TEXT,
  voice_event_id TEXT,
  primary_intent TEXT NOT NULL,
  secondary_intent TEXT,
  workspace_candidate TEXT,
  conversation_action TEXT NOT NULL,
  confidence_score REAL NOT NULL,
  requires_confirmation INTEGER NOT NULL,
  suggested_title TEXT,
  created_at DATETIME NOT NULL
)
```

### Endpoints mínimos da API local para a Phase 2

#### Voice

- `POST /voice/capture/start`
- `POST /voice/capture/stop`
- `POST /voice/process`
- `GET /voice/events/:id`

#### Intent

- `POST /intent/interpret`
- `POST /intent/resolve-conversation`

#### Conversation by voice

- `POST /voice/open-or-resume`
- `POST /voice/confirm`

### Fluxos principais da Phase 2

#### Fluxo A — Abrir nova conversa por voz

1. usuário aciona push-to-talk;
2. fala é capturada;
3. sistema transcreve e normaliza;
4. classifica intenção como criação de novo caso;
5. escolhe guia provável;
6. sugere título;
7. cria conversa;
8. registra `ConversationStart`;
9. abre conversa no painel principal.

#### Fluxo B — Retomar conversa existente por voz

1. usuário fala intenção de continuidade;
2. sistema transcreve e interpreta;
3. busca conversa compatível;
4. se a confiança for alta, reabre diretamente;
5. registra `ConversationResume`;
6. carrega ledger, compact summary e mensagens básicas.

#### Fluxo C — Ambiguidade com confirmação curta

1. sistema detecta duas conversas ou duas guias plausíveis;
2. gera pergunta curta;
3. usuário confirma por voz ou clique;
4. sistema executa ação final e registra decisão.

### Regras de UX da Phase 2

- o microfone deve ser visível e fácil de acionar;
- a transcrição deve aparecer para inspeção rápida quando útil;
- o sistema deve mostrar discretamente o que entendeu, sem excesso técnico;
- confirmação deve ser curta e rara;
- o usuário deve sentir que o sistema entende intenção, não que exige comandos decorados.

### Regras de consistência da Phase 2

- evento de voz não pode ficar sem status final;
- transcrição deve estar vinculada ao voice\_event;
- interpretação semântica deve ser persistida quando usada para ação;
- criação de conversa por voz deve obedecer à mesma regra de título obrigatório da Phase 1;
- retomada por voz não pode ignorar o ledger existente.

### Critérios técnicos de aceite da Phase 2

A fase só deve ser considerada concluída quando:

1. o sistema capturar áudio localmente com push-to-talk;
2. a transcrição local funcionar de forma consistente em português brasileiro;
3. a interpretação semântica classificar intenção com rastreabilidade básica;
4. o sistema conseguir criar conversa por voz;
5. o sistema conseguir retomar conversa por voz quando houver correspondência forte;
6. a confirmação curta ocorrer apenas em cenários ambíguos;
7. voice events, transcripts e intent events forem persistidos corretamente.

### Critérios funcionais de aceite da Phase 2

Do ponto de vista do Giuseppe, a fase está pronta quando:

- ele consegue iniciar trabalho falando;
- consegue reencontrar e continuar um assunto pela fala;
- não precisa decorar comandos;
- o sistema erra pouco na escolha do lugar onde o assunto deve ficar;
- a experiência parece assistente executivo, não ferramenta técnica de áudio.

### Fora do escopo da Phase 2

Ficam fora desta fase:

- TTS maduro de resposta por voz;
- escuta contínua permanente;
- roteamento multiagente profundo;
- verificação jurídica avançada por voz;
- supervisão macro totalmente automática;
- diálogo multimodal sofisticado com anexos e voz no mesmo turno.

### Pacote de entregáveis esperado dos contratados ao final da Phase 2

O time deve entregar:

- captura local de voz com push-to-talk;
- pipeline de transcrição local;
- normalização básica de transcrição;
- classificador semântico inicial de intenção;
- resolução de conversa por voz;
- criação de conversa com título sugerido;
- confirmação curta em ambiguidade;
- persistência dos eventos de voz e intenção;
- testes funcionais básicos dos fluxos principais.

### Integração aprofundada entre voz e Agent Orchestrator

#### Objetivo deste bloco

Definir como o pipeline de voz da Phase 2 deixa de ser apenas um mecanismo de abertura e retomada de conversas e passa a se tornar a principal porta de entrada para a camada cognitiva do sistema.

A integração com o Agent Orchestrator deve garantir que uma fala do Giuseppe seja capaz de:

- abrir ou retomar a conversa correta;
- registrar a intenção no lugar certo;
- montar o contexto inicial da tarefa;
- decidir se a solicitação exige apenas resposta direta, criação de workflow, consulta interna, consulta externa ou composição multiagente;
- iniciar a execução cognitiva sem perder rastreabilidade.

#### Papel do Agent Orchestrator neste ponto do sistema

O Agent Orchestrator não recebe áudio bruto. Ele recebe um **pacote operacional já resolvido pela camada de voz**, contendo:

- transcrição normalizada;
- intenção principal;
- entidades identificadas;
- guia final ou candidata;
- ação de conversa resolvida;
- título final ou sugerido;
- estado do ledger;
- contexto mínimo reidratado.

Com esse pacote, o Agent Orchestrator passa a decidir:

- se a fala gera apenas resposta local simples;
- se deve acionar o Deep Agent Executivo Roteador;
- se deve criar workflow novo;
- se deve anexar a fala a workflow existente;
- se deve acionar verificação antes da redação;
- se deve aguardar confirmação humana adicional.

### Fronteira entre camada de voz e Agent Orchestrator

#### Responsabilidade da camada de voz

A camada de voz é responsável por:

- capturar áudio;
- transcrever;
- interpretar semanticamente em nível inicial;
- resolver conversa;
- sugerir ou confirmar título;
- persistir evento de voz;
- acionar ConversationStart ou ConversationResume quando aplicável.

#### Responsabilidade do Agent Orchestrator

O Agent Orchestrator é responsável por:

- classificar o tipo de trabalho cognitivo necessário;
- montar context pack orientado à execução;
- decidir profundidade da delegação agentic;
- acionar workflows e Deep Agents;
- coordenar resposta, persistência e próximos passos.

#### Regra de separação

A camada de voz decide **onde** a solicitação entra. O Agent Orchestrator decide **como** a solicitação será tratada cognitivamente.

### Ponto de acoplamento entre voz e orquestração

Após a resolução de conversa, a camada de voz deve produzir um artefato chamado **Voice Execution Envelope**.

#### Campos mínimos do Voice Execution Envelope

- `voice_event_id`;
- `conversation_id`;
- `workspace_final`;
- `normalized_transcript`;
- `primary_intent`;
- `secondary_intent`;
- `entities`;
- `confidence_score`;
- `conversation_action`;
- `title_final` opcional;
- `ledger_ref`;
- `resume_bundle_ref` opcional;
- `requires_confirmation`;
- `confirmation_state`.

Esse envelope é o primeiro artefato aceito pelo Agent Orchestrator.

### Classificação orquestral da solicitação

Ao receber o Voice Execution Envelope, o Agent Orchestrator deve classificar a solicitação em uma das seguintes categorias operacionais:

#### 1. Local reply

A fala pode ser respondida no contexto atual sem abrir fluxo profundo.

Exemplos:

- continuação simples do mesmo assunto;
- pedido de resumo breve da conversa atual;
- ajuste pequeno em texto já aberto.

#### 2. Internal retrieval

A fala exige recuperação de dados internos ou fatos institucionais.

Exemplos:

- “Quais são os laboratórios do curso de Gastronomia?”
- “Qual é o preço atual de Administração?”

#### 3. External intelligence

A fala exige consulta a fontes externas, concorrência, mercado ou regulação.

Exemplos:

- “Quero saber os preços de Administração da UniAlfa.”
- “O que saiu de novo no MEC sobre esse tema?”

#### 4. Workflow creation

A fala abre um trabalho estruturado com múltiplas etapas.

Exemplos:

- “Vamos começar o planejamento de captação do curso de Gastronomia.”
- “Quero refazer o plano de Psicologia.”

#### 5. Workflow continuation

A fala retoma workflow já existente.

Exemplos:

- “Continuar o plano de Gastronomia.”
- “Retomar a análise de concorrência de Psicologia.”

#### 6. Document request

A fala pede produção, revisão ou transformação documental.

Exemplos:

- “Gerar um parecer sobre isso.”
- “Transforme isso em despacho.”

#### 7. Sensitive review path

A fala entra em trilha que exige verificação ou human-in-the-loop.

Exemplos:

- interpretação regulatória sensível;
- recomendação contratual;
- alteração de verdade institucional;
- conclusão jurídica de alto impacto.

### Mapeamento entre intenção da voz e ação do orquestrador

#### `start_planning`

Ação padrão:

- abrir ou criar conversa;
- montar context pack inicial;
- criar workflow do tipo `planning_workflow`;
- anexar ao ledger como novo caso.

#### `continue_work`

Ação padrão:

- localizar workflow/caso atual;
- reidratar estado;
- anexar nova entrada de voz ao ledger;
- retomar execução.

#### `retrieve_conversation`

Ação padrão:

- localizar conversa;
- abrir contexto;
- responder localmente ou aguardar nova instrução.

#### `ask_competitor_question`

Ação padrão:

- classificar como external intelligence;
- decidir se responde pontualmente ou inicia workflow comparativo;
- cruzar com base interna quando relevante.

#### `ask_regulatory_question`

Ação padrão:

- classificar como external intelligence/regulatory;
- acionar verificação quando o risco for elevado;
- considerar human-in-the-loop se a saída for sensível.

#### `request_document`

Ação padrão:

- decidir se há base suficiente para redação;
- se não houver, acionar coleta ou verificação antes;
- se houver, encaminhar para Redação Executiva.

### Construção do context pack a partir da voz

O Voice Execution Envelope, por si só, não é suficiente para execução profunda. O Agent Orchestrator deve montar um **Execution Context Pack** contendo:

- objetivo atual derivado da fala;
- resumo do caso até o momento;
- fatos institucionais relevantes;
- estado de verificação atual;
- memória macro relevante;
- restrições do domínio;
- tipo de saída desejada;
- referências de evidência já aceitas;
- perfil executivo relevante para aquela tarefa.

#### Regra de montagem

- se a fala abrir caso novo, usar context pack mínimo + fatos internos relevantes;
- se a fala retomar caso, usar resume bundle + ledger + macro memory;
- se a fala for sensível, anexar regras de verificação e política de confirmação.

### Integração com o Deep Agent Executivo Roteador

Quando a classificação orquestral indicar trabalho não trivial, o Agent Orchestrator deve acionar o **Deep Agent Executivo Roteador**.

#### O que o Orchestrator envia ao Deep Agent Executivo

- objective statement derivado da fala;
- workspace final;
- conversation\_id;
- execution context pack;
- constraints do caso;
- requested output type;
- verification requirements;
- urgency ou priority hints quando houver.

#### O que o Deep Agent Executivo devolve

- plano de execução do caso;
- domínios a acionar;
- ordem ou paralelismo sugerido;
- necessidade de verificação;
- necessidade de human-in-the-loop;
- output esperado para o próximo estágio.

### Criação de workflow a partir da fala

Nem toda fala gera workflow. Para criar workflow, o orquestrador deve verificar:

- se o objetivo exige múltiplas etapas;
- se há necessidade de coleta, verificação e síntese;
- se a tarefa não pode ser respondida com recuperação simples;
- se existe benefício claro em persistir progresso por etapas.

#### Critérios mínimos para criação automática de workflow

- intenção de planejamento;
- intenção de comparação complexa;
- necessidade de múltiplas fontes;
- necessidade de futura retomada;
- produção documental dependente de análise prévia.

#### Campos mínimos do workflow criado por voz

- `workflow_id`;
- `conversation_id`;
- `workflow_type`;
- `trigger_type = voice`;
- `goal`;
- `initial_entities`;
- `workspace_id`;
- `status`;
- `priority`;
- `created_at`.

### Política de resposta imediata versus execução em background lógico

Após a fala do Giuseppe, o sistema deve decidir entre:

#### Resposta imediata simples

Quando a solicitação for curta, clara e de baixa complexidade.

#### Resposta com preparação curta

Quando a solicitação exigir alguns segundos de análise e montagem de contexto.

#### Início de workflow com retorno inicial

Quando a solicitação abrir trabalho maior. Nesse caso, o sistema deve:

- confirmar internamente o objetivo;
- registrar o caso;
- iniciar etapas iniciais;
- devolver ao Giuseppe um primeiro retorno útil e objetivo.

#### Regra de UX

Mesmo quando um workflow maior for criado, o sistema não deve parecer “travado”. Ele deve sempre devolver ao menos:

- o que entendeu;
- onde registrou o caso;
- qual é o próximo passo já iniciado.

### Persistência da integração voz-orquestrador

Além de `voice_events`, `voice_transcripts` e `intent_events`, esta integração exige persistir:

- `voice_execution_envelopes`;
- relação entre `voice_event_id` e `workflow_id` quando houver;
- classificação orquestral da solicitação;
- decisão de acionamento do Deep Agent Executivo;
- resultado da resolução inicial.

### Modelo de dados complementar deste bloco

```sql
voice_execution_envelopes (
  id TEXT PRIMARY KEY,
  voice_event_id TEXT NOT NULL,
  conversation_id TEXT NOT NULL,
  workspace_final TEXT NOT NULL,
  primary_intent TEXT NOT NULL,
  secondary_intent TEXT,
  conversation_action TEXT NOT NULL,
  confidence_score REAL NOT NULL,
  requires_confirmation INTEGER NOT NULL,
  confirmation_state TEXT,
  ledger_ref TEXT,
  resume_bundle_ref TEXT,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (voice_event_id) REFERENCES voice_events(id),
  FOREIGN KEY (conversation_id) REFERENCES conversations(id)
)

orchestrator_decisions (
  id TEXT PRIMARY KEY,
  envelope_id TEXT NOT NULL,
  decision_type TEXT NOT NULL,
  workflow_id TEXT,
  routed_to_executive_agent INTEGER NOT NULL,
  response_mode TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (envelope_id) REFERENCES voice_execution_envelopes(id)
)
```

### Endpoints mínimos da API local para este bloco

#### Voice orchestration

- `POST /voice/execution-envelope`
- `POST /orchestrator/classify-request`
- `POST /orchestrator/resolve-action`
- `POST /orchestrator/create-workflow-from-voice`
- `GET /orchestrator/decisions/:id`

### Fluxos principais deste bloco

#### Fluxo A — Fala simples com resposta local

1. voz é capturada e interpretada;
2. conversa é resolvida;
3. envelope é criado;
4. orquestrador classifica como `local_reply`;
5. sistema responde no contexto atual;
6. persiste decisão.

#### Fluxo B — Fala que inicia planejamento

1. voz é capturada;
2. intenção `start_planning` é identificada;
3. conversa nova ou existente é resolvida;
4. envelope é criado;
5. orquestrador classifica como `workflow_creation`;
6. cria workflow;
7. aciona Deep Agent Executivo;
8. registra workflow no ledger;
9. devolve retorno inicial ao Giuseppe.

#### Fluxo C — Fala de consulta externa complexa

1. voz é capturada;
2. intenção competitiva ou regulatória é identificada;
3. envelope é criado;
4. orquestrador classifica como `external_intelligence`;
5. monta context pack;
6. aciona Deep Agent Executivo ou domínio específico;
7. retorna ao usuário com síntese inicial e início do caso.

### Regras de UX deste bloco

- após a fala, o sistema deve mostrar o que entendeu e o que começou a fazer;
- o usuário não deve ser exposto a termos como envelope, orquestrador ou workflow técnico;
- se um trabalho estruturado for aberto, a UI deve indicar algo como “Plano iniciado” ou “Análise em andamento”;
- a passagem da voz para o trabalho cognitivo deve parecer natural e imediata.

### Regras de consistência deste bloco

- toda ação cognitiva disparada por voz deve estar vinculada a uma conversa;
- nenhum workflow iniciado por voz pode ficar sem `conversation_id`;
- nenhuma decisão do orquestrador deve existir sem envelope correspondente;
- solicitações sensíveis devem respeitar a trilha de verificação;
- o Agent Orchestrator não deve receber áudio bruto nem texto cru sem resolução de conversa.

### Critérios técnicos de aceite deste bloco

Este bloco só deve ser considerado concluído quando:

1. a camada de voz conseguir produzir um Voice Execution Envelope estável;
2. o Agent Orchestrator conseguir classificar a solicitação operacionalmente;
3. o sistema conseguir decidir entre resposta local, criação de workflow e acionamento agentic;
4. workflows puderem ser criados a partir de fala;
5. toda decisão ficar persistida e auditável;
6. integrações com ledger e resume bundle estiverem funcionais.

### Critérios funcionais de aceite deste bloco

Do ponto de vista do Giuseppe, este bloco está pronto quando:

- ele fala e o sistema não apenas entende, mas começa a trabalhar;
- o sistema coloca o assunto no lugar certo e inicia a ação correta;
- casos maiores parecem “em andamento” e não apenas respondidos superficialmente;
- a transição entre falar e ver o trabalho começar é fluida.

### Próximos blocos previstos para continuidade

- refinamento da criação de workflows a partir da fala;
- detalhamento da ligação entre voz e Deep Agent Executivo;
- aprofundamento da política de resposta e continuidade de trabalho dentro da conversa;
- detalhamento da resposta incremental ao Giuseppe durante workflows iniciados por voz.

