Desktop com Electron;
- frontend local em React + TypeScript inicializado e empacotado dentro do shell;
- backend local em Python executado como processo gerenciado pelo aplicativo;
- banco SQLite inicial com migrações automáticas;
- estrutura local de diretórios e artefatos;
- health checks dos componentes críticos;
- sistema mínimo de logs locais;
- instalador local e ícone de desktop;
- mecanismo inicial de configuração e bootstrap;
- fluxo de startup e shutdown controlado.

#### Escopo da Phase 0

Phase 0 cobre apenas a fundação técnica do produto. Ela **não** precisa entregar ainda:
- inteligência completa dos agentes;
- memória micro/macro completa;
- base institucional completa;
- módulo jurídico completo;
- curadoria completa de notícias.

Ela precisa entregar a base sobre a qual tudo isso será construído.

#### Arquitetura técnica da Phase 0

##### 1. Desktop shell
Responsabilidades:
- abrir a janela principal;
- exibir splash/loading state;
- iniciar e monitorar o backend local;
- detectar falhas iniciais;
- expor comandos básicos do sistema operacional;
- integrar impressão/exportação futura;
- encerrar o backend de forma segura no fechamento do app.

Responsabilidades explícitas que **não** pertencem ao shell:
- lógica de negócio;
- orquestração de agentes;
- cálculo de contexto;
- gestão de memória;
- processamento jurídico;
- pipelines de monitoramento.

##### 2. Frontend
Responsabilidades:
- renderizar a interface principal;
- exibir status do sistema;
- exibir tela inicial e estados de erro;
- preparar a navegação por guias;
- enviar comandos ao backend local;
- exibir progresso de bootstrap e health check;
- guardar preferências apenas de UI quando apropriado.

##### 3. Backend local
Responsabilidades:
- expor API local para o frontend;
- inicializar banco, diretórios e config;
- centralizar logs do sistema;
- oferecer endpoint de health check;
- controlar acesso ao banco e ao storage;
- preparar a base para workers, orquestração e runtime de modelos.

##### 4. Data layer inicial
Responsabilidades:
- criar arquivo SQLite local;
- aplicar migrações automaticamente;
- validar compatibilidade de schema;
- registrar erros de bootstrap;
- garantir diretórios válidos para anexos, áudios e documentos.

#### Estrutura local de pastas

Estrutura local sugerida no computador do Giuseppe:

```text
GiuseppeExecutiveAssistant/
  app/
    logs/
    data/
      app.db
      migrations/
    artifacts/
      audio/
      pdf/
      docx/
      attachments/
      exports/
    cache/
    models/
    backups/
    config/
      app_config.json
      runtime_config.json
```

#### Semântica dos diretórios

- `logs/`: logs rotativos do app, backend, bootstrap e falhas críticas.
- `data/app.db`: banco principal SQLite.
- `data/migrations/`: histórico de migrações aplicadas.
- `artifacts/audio/`: áudios temporários e persistidos quando necessário.
- `artifacts/pdf/`: PDFs gerados.
- `artifacts/docx/`: documentos exportados.
- `artifacts/attachments/`: anexos do usuário e documentos ingeridos.
- `artifacts/exports/`: pacotes exportados pelo sistema.
- `cache/`: dados reprocessáveis, nunca canônicos.
- `models/`: configuração e cache local de runtime/modelos, quando aplicável.
- `backups/`: backups locais do banco e metadados.
- `config/`: configurações persistidas do aplicativo.

#### Sequência de bootstrap

Na primeira execução, o sistema deve seguir esta ordem:

1. detectar diretório-base do aplicativo;
2. criar estrutura de diretórios se não existir;
3. criar arquivos mínimos de configuração padrão;
4. iniciar backend local em modo bootstrap;
5. abrir conexão com SQLite;
6. verificar se o banco existe;
7. criar banco se necessário;
8. aplicar migrações pendentes;
9. registrar versão atual do schema;
10. executar health checks básicos;
11. informar ao frontend se o sistema está pronto;
12. liberar a UI principal.

#### Sequência de startup em uso normal

Em execuções normais, o fluxo deve ser:

1. shell Electron inicia;
2. splash screen aparece com status básico;
3. backend Python é iniciado pelo shell;
4. backend valida config e diretórios;
5. backend abre banco e verifica migrações;
6. backend registra estado do runtime;
7. frontend consulta endpoint de readiness;
8. se tudo estiver saudável, tela principal é liberada;
9. se houver falha recuperável, exibir estado assistido de correção;
10. se houver falha crítica, exibir tela de erro guiada.

#### Sequência de shutdown

No fechamento do app:

1. frontend envia sinal de encerramento gracioso;
2. backend finaliza operações seguras em andamento;
3. locks transitórios são liberados;
4. buffers de log são descarregados;
5. conexões com banco são fechadas;
6. shell encerra processo backend;
7. app fecha apenas após confirmação de shutdown ou timeout controlado.

#### Modelo de configuração

##### `app_config.json`
Configurações de produto:
- nome da instância local;
- idioma;
- caminhos-base;
- preferências de exportação;
- flags de funcionalidades habilitadas;
- versão esperada do schema;
- política local de backup.

##### `runtime_config.json`
Configurações técnicas:
- porta local do backend;
- timeouts internos;
- caminhos de runtime de modelos;
- limites de log;
- parâmetros do scheduler;
- política de retry no bootstrap.

#### API local mínima exigida nesta fase

O backend deve expor no mínimo:

- `GET /health/live`
- `GET /health/ready`
- `GET /health/dependencies`
- `GET /system/info`
- `GET /system/version`
- `POST /system/shutdown`

#### Health checks desta fase

##### Live check
Verifica se o processo backend está ativo.

##### Ready check
Verifica se o sistema está pronto para liberar a UI principal.

Condições mínimas:
- diretórios válidos;
- banco acessível;
- migrações aplicadas;
- arquivos de configuração válidos;
- storage local gravável.

##### Dependency check
Verifica dependências locais necessárias para o MVP base.

Exemplos:
- backend iniciado;
- banco SQLite acessível;
- permissões de escrita no diretório local;
- executáveis/configurações críticas encontrados;
- espaço mínimo em disco acima do limite de segurança.

#### Modelo de logging

Phase 0 deve entregar observabilidade mínima suficiente para suporte técnico.

Tipos de logs:
- `app.log`: eventos gerais do shell e UI;
- `backend.log`: eventos do backend local;
- `bootstrap.log`: criação inicial de diretórios, banco e configuração;
- `error.log`: falhas críticas ou não tratadas.

Cada evento de log deve conter, quando possível:
- timestamp;
- nível (`INFO`, `WARN`, `ERROR`);
- componente;
- operação;
- correlation_id;
- mensagem;
- contexto resumido.

#### Tratamento de erro

##### Erros recuperáveis
Exemplos:
- diretório ausente e recriável;
- config parcial regenerável;
- cache corrompido mas descartável;
- lock transitório stale.

Conduta:
- corrigir automaticamente quando seguro;
- registrar no log;
- informar discretamente ao frontend se necessário.

##### Erros críticos
Exemplos:
- banco inacessível;
- migração falhou;
- diretório-base sem permissão de escrita;
- backend não sobe;
- configuração essencial inválida sem fallback.

Conduta:
- bloquear uso normal;
- exibir tela assistida de erro;
- registrar erro detalhado;
- oferecer caminho claro para suporte técnico.

#### Empacotamento e instalação

Phase 0 deve prever:
- empacotamento do Electron app;
- inclusão do frontend buildado;
- inclusão ou provisionamento controlado do backend Python;
- criação de atalho/ícone na área de trabalho;
- nome amigável do aplicativo;
- desinstalação controlada sem remoção acidental de dados críticos, salvo confirmação explícita.

#### Modos de instalação

##### First install
- cria pasta-base;
- instala binários necessários;
- cria atalho;
- inicializa configuração padrão;
- executa bootstrap assistido.

##### Update install
- preserva banco e artefatos;
- atualiza binários;
- executa migrações;
- registra versão instalada;
- mantém rollback lógico apenas para falha antes da migração irreversível.

#### Baseline de segurança desta fase

Mesmo na fundação, o sistema deve iniciar com:
- execução apenas local;
- API do backend acessível somente em loopback/local host;
- caminhos sensíveis centralizados em config;
- logs sem vazar conteúdo documental completo por padrão;
- separação entre dados canônicos e cache descartável.

#### Requisitos iniciais do banco

Na conclusão de Phase 0, o banco precisa suportar ao menos:
- tabela de metadata do sistema;
- tabela de migrações aplicadas;
- tabela mínima de auditoria técnica;
- estrutura pronta para expansão sem recriação manual;
- rotina de criação automática se banco não existir.

#### Critérios técnicos de aceite da Phase 0

A fase só deve ser considerada concluída quando:

1. o aplicativo instala no computador-alvo com atalho funcional;
2. o clique no ícone inicia shell, frontend e backend sem intervenção manual;
3. o backend sobe automaticamente;
4. o banco é criado e migrado automaticamente;
5. a estrutura de diretórios é criada sem scripts manuais externos;
6. o sistema consegue responder aos endpoints de health check;
7. o fechamento do app não deixa processo zumbi;
8. logs são gerados em diretório previsível;
9. erro crítico de bootstrap gera tela de erro guiada e log correspondente;
10. reinstalação/atualização preserva dados locais quando aplicável.

#### Critérios funcionais de aceite da Phase 0

Do ponto de vista do Giuseppe, Phase 0 está pronta quando:
- existe um ícone claro na área de trabalho;
- ao clicar, o sistema abre de forma previsível;
- não há necessidade de terminal, comando ou script manual;
- o aplicativo não parece protótipo técnico;
- em caso de erro, há uma mensagem compreensível e não apenas falha silenciosa.

#### Fora do escopo da Phase 0

Ficam fora desta fase:
- interpretação por voz completa;
- classificação semântica madura de intenção;
- memória micro/macro funcional;
- workflows concorrentes completos;
- curadoria de notícias e concorrência;
- base institucional detalhada;
- motor jurídico-regulatório;
- perfil adaptativo do Giuseppe;
- geração documental avançada.

#### Pacote de entregáveis esperado dos contratados ao final da Phase 0

O time deve entregar:
- código-fonte do shell desktop;
- código-fonte do backend local base;
- projeto frontend inicial;
- scripts de build e empacotamento;
- migrações iniciais do banco;
- documentação de bootstrap e instalação;
- checklist de troubleshooting;
- pacote instalável para ambiente-alvo;
- evidências de teste de instalação e inicialização.

### Phase 1 - Core Data and Navigation

#### Objetivo da Phase 1

Estabelecer a espinha dorsal organizacional do produto: guias, conversas, títulos obrigatórios, navegação, busca, anexos, metadados básicos, trilha inicial de auditoria e estrutura de dados suficiente para que o sistema deixe de ser apenas um shell técnico e passe a operar como ambiente real de trabalho.

A Phase 1 é a camada que transforma o aplicativo instalado na Phase 0 em um sistema utilizável no dia a dia, mesmo antes da maturidade completa de voz, agentes e memória avançada.

#### Escopo da Phase 1

A Phase 1 deve entregar:
- as 4 guias iniciais do MVP;
- estrutura de navegação previsível;
- criação e listagem de conversas;
- título obrigatório de conversa;
- associação obrigatória de conversa à guia;
- busca por guia e título;
- metadados iniciais por conversa;
- anexos por conversa;
- mensagens persistidas;
- auditoria técnica inicial dos eventos principais.

A Phase 1 ainda não precisa entregar:
- interpretação semântica completa por voz;
- classificação madura de intenção;
- roteamento avançado de agentes;
- memória micro e macro completa;
- curadoria externa madura;
- comparação competitiva completa.

#### Resultado esperado da Phase 1

Ao final desta fase, o Giuseppe deve conseguir:
- abrir o sistema;
- entrar em uma guia;
- criar uma conversa com título obrigatório;
- localizar depois essa conversa pela guia e pelo título;
- anexar material inicial;
- registrar mensagens e continuar o trabalho futuramente;
- perceber o sistema como um espaço organizado, e não como um chat caótico.

### Modelo funcional da navegação

#### Guias iniciais do MVP

As quatro guias iniciais devem existir como entidades fixas no bootstrap do sistema:
- Planejamento;
- Captação;
- Normas e Regulação;
- Documentos.

Cada guia é, ao mesmo tempo:
- um agrupador visual na interface;
- um escopo primário de organização;
- uma partição inicial de contexto;
- um filtro natural de busca;
- uma base para futura macro memory.

#### Estrutura visual mínima da interface

A UI da Phase 1 deve ter, no mínimo, estes elementos persistentes:

1. barra lateral com as 4 guias;
2. lista de conversas da guia atual;
3. campo de busca;
4. botão de nova conversa;
5. painel principal da conversa;
6. área de anexos ou referências;
7. cabeçalho com título da conversa e metadados principais.

#### Regras de navegação

- trocar de guia deve atualizar imediatamente a lista de conversas visíveis;
- busca dentro de uma guia deve priorizar resultados da guia atual;
- o usuário pode optar por busca global, mas o padrão deve ser busca no escopo atual;
- ao abrir uma conversa, o sistema deve restaurar mensagens, anexos e metadados básicos;
- a navegação não deve depender de múltiplos cliques complexos ou menus profundos.

### Modelo de conversa

#### Conversa como unidade primária de trabalho

Na Phase 1, a conversa é a unidade básica de organização operacional do sistema. Toda conversa deve:
- pertencer a exatamente uma guia;
- possuir título obrigatório;
- possuir identificador persistente;
- armazenar mensagens;
- aceitar anexos;
- guardar metadados básicos;
- preparar a futura associação com workflows, memória e documentos.

#### Regras obrigatórias de criação de conversa

Ao criar uma conversa, o sistema deve exigir:
- guia de origem já definida;
- título obrigatório;
- data e hora de criação;
- modo de origem (`manual`, com preparação futura para `voice`);
- status inicial da conversa.

#### Regras de título obrigatório

O título não é opcional. O sistema deve impedir criação de conversa sem título.

O título deve:
- ter tamanho mínimo configurável;
- ser persistido como campo pesquisável;
- aparecer na lista de conversas;
- poder ser editado posteriormente com trilha de auditoria;
- ser único apenas por ID, não por texto, mas o sistema deve sinalizar títulos muito parecidos na mesma guia quando fizer sentido.

#### Status mínimos de conversa

Estados sugeridos nesta fase:
- `active`;
- `paused`;
- `archived`;
- `draft`.

#### Metadados iniciais da conversa

Mesmo antes da inteligência completa, a conversa deve suportar estes campos:
- `workspace_id`;
- `title`;
- `status`;
- `created_at`;
- `updated_at`;
- `origin_mode`;
- `topic_tags`;
- `course_ref` opcional;
- `objective_summary` opcional;
- `created_by_system` booleano para futuras automações.

### Modelo de mensagens

#### Função das mensagens na Phase 1

Mensagens ainda não carregam toda a inteligência futura, mas já precisam ser persistidas corretamente para sustentar:
- histórico do caso;
- retomada futura;
- preparação da memória micro;
- anexação de eventos de intenção nas fases seguintes.

#### Campos mínimos de mensagem

Cada mensagem deve conter:
- `id`;
- `conversation_id`;
- `role` (`user`, `assistant`, `system`, `reviewer`);
- `raw_text`;
- `normalized_text` opcional;
- `created_at`;
- `attachment_refs` opcionais;
- `message_order`.

#### Regras de persistência de mensagens

- mensagens devem ser ordenadas por timestamp e ordem lógica;
- mensagens nunca devem ser apagadas silenciosamente;
- edição, quando existir no futuro, deve ser versionada ou auditada;
- mensagens de sistema relevantes devem ser distinguíveis das mensagens normais.

### Modelo de busca

#### Objetivo da busca nesta fase

A busca da Phase 1 não precisa ser semântica plena ainda. Ela precisa ser confiável, rápida e clara.

#### Modos obrigatórios de busca

1. **Busca por guia + título**
   - caso de uso principal do Giuseppe.

2. **Busca textual básica no conteúdo da conversa**
   - útil para localizar trabalhos antigos.

3. **Busca por metadados básicos**
   - curso, tag, período ou status quando disponíveis.

#### Regras da busca

- o padrão deve ser “buscar na guia atual”;
- deve haver opção explícita de ampliar para busca global;
- títulos devem ter peso superior ao corpo da conversa na ordenação do resultado;
- resultados devem mostrar pelo menos: título, guia, última atualização e trecho resumido.

#### Indexação mínima recomendada

A Phase 1 já deve preparar:
- índice por `workspace_id`;
- índice por `title`;
- índice por `updated_at`;
- base pronta para FTS no conteúdo.

### Modelo de anexos

#### Função dos anexos nesta fase

Os anexos permitem que a conversa já nasça vinculada a material de trabalho real.

Exemplos:
- tabela de preço;
- minuta de contrato;
- regulamento;
- documento institucional;
- material de concorrente;
- rascunho de plano.

#### Regras mínimas de anexos

- cada anexo deve estar vinculado a uma conversa;
- o sistema deve guardar nome original, tipo, caminho físico e data de upload;
- anexos não devem ficar “soltos” fora de referência;
- anexos devem ser listáveis na UI da conversa;
- remoção lógica deve ser auditada.

#### Metadados mínimos de anexo

- `id`;
- `conversation_id`;
- `file_name`;
- `mime_type`;
- `file_path`;
- `uploaded_at`;
- `size_bytes`;
- `status`.

### Auditoria inicial da Phase 1

Mesmo antes da trilha de auditoria completa, a Phase 1 já deve registrar eventos básicos:
- criação de conversa;
- alteração de título;
- mudança de status;
- abertura de conversa;
- upload de anexo;
- remoção lógica de anexo;
- erro relevante de persistência.

Cada evento mínimo deve registrar:
- `event_type`;
- `target_type`;
- `target_id`;
- `timestamp`;
- `event_data` resumido.

### Modelo de dados detalhado da Phase 1

#### Tabelas mínimas obrigatórias

```sql
workspaces (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  type TEXT NOT NULL,
  created_at DATETIME NOT NULL
)

conversations (
  id TEXT PRIMARY KEY,
  workspace_id TEXT NOT NULL,
  title TEXT NOT NULL,
  status TEXT NOT NULL,
  origin_mode TEXT NOT NULL,
  objective_summary TEXT,
  course_ref TEXT,
  created_at DATETIME NOT NULL,
  updated_at DATETIME NOT NULL,
  FOREIGN KEY (workspace_id) REFERENCES workspaces(id)
)

conversation_tags (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  tag_value TEXT NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id)
)

messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  role TEXT NOT NULL,
  raw_text TEXT,
  normalized_text TEXT,
  message_order INTEGER NOT NULL,
  created_at DATETIME NOT NULL,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id)
)

attachments (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  file_name TEXT NOT NULL,
  mime_type TEXT NOT NULL,
  file_path TEXT NOT NULL,
  size_bytes INTEGER,
  status TEXT NOT NULL,
  uploaded_at DATETIME NOT NULL,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id)
)

audit_log (
  id TEXT PRIMARY KEY,
  event_type TEXT NOT NULL,
  target_type TEXT NOT NULL,
  target_id TEXT NOT NULL,
  event_data TEXT,
  created_at DATETIME NOT NULL
)
```

### Endpoints mínimos da API local para a Phase 1

#### Workspaces
- `GET /workspaces`
- `GET /workspaces/:id`

#### Conversations
- `POST /conversations`
- `GET /conversations/:id`
- `GET /workspaces/:id/conversations`
- `PATCH /conversations/:id`
- `POST /conversations/:id/archive`
- `POST /conversations/:id/pause`

#### Search
- `GET /search/conversations?workspace_id=...&query=...`
- `GET /search/global?query=...`

#### Messages
- `POST /conversations/:id/messages`
- `GET /conversations/:id/messages`

#### Attachments
- `POST /conversations/:id/attachments`
- `GET /conversations/:id/attachments`
- `DELETE /attachments/:id`

### Fluxos principais da Phase 1

#### Fluxo A — Criar nova conversa
1. usuário entra em uma guia;
2. clica em “nova conversa”;
3. sistema exige título;
4. usuário confirma criação;
5. conversa é persistida;
6. evento de auditoria é registrado;
7. painel principal é aberto pronto para mensagens.

#### Fluxo B — Buscar conversa existente
1. usuário entra em uma guia;
2. digita parte do título;
3. sistema filtra conversas da guia atual;
4. usuário seleciona a conversa;
5. sistema carrega mensagens, anexos e metadados.

#### Fluxo C — Anexar documento inicial
1. usuário abre conversa existente;
2. seleciona arquivo;
3. sistema persiste arquivo em storage local;
4. salva metadados no banco;
5. registra evento de auditoria;
6. exibe arquivo na lista de anexos.

### Regras de UX da Phase 1

- a criação de conversa deve ser simples e rápida;
- a obrigatoriedade do título deve parecer organizacional, não burocrática;
- a busca deve ser visível, não escondida;
- o cabeçalho da conversa deve sempre mostrar a qual guia ela pertence;
- a lista de conversas deve privilegiar legibilidade sobre densidade extrema;
- a ausência de mensagens deve ser tratada com estado vazio útil, não com tela “quebrada”.

### Regras de consistência da Phase 1

- não pode existir conversa sem guia;
- não pode existir conversa sem título;
- não pode existir mensagem órfã sem conversa;
- não pode existir anexo sem conversa;
- atualização de título deve atualizar `updated_at`;
- arquivamento não deve apagar histórico.

### Critérios técnicos de aceite da Phase 1

A fase só deve ser considerada concluída quando:

1. as 4 guias estiverem persistidas e navegáveis;
2. for possível criar conversa em qualquer guia;
3. o sistema impedir conversa sem título;
4. a busca por guia e título funcionar com persistência real;
5. mensagens forem salvas e reabertas corretamente;
6. anexos puderem ser vinculados a conversas;
7. eventos básicos forem auditados;
8. recarregar o aplicativo não apagar conversas, mensagens ou anexos.

### Critérios funcionais de aceite da Phase 1

Do ponto de vista do Giuseppe, a fase está pronta quando:
- ele consegue organizar o trabalho por guia;
- consegue nomear as conversas de modo claro;
- consegue reencontrar conversas antigas sem esforço;
- percebe que o sistema “guarda o assunto no lugar certo”;
- consegue iniciar trabalho com documentos anexos desde cedo.

### Fora do escopo da Phase 1

Ficam fora desta fase:
- sugestão automática madura de títulos por IA;
- roteamento semântico robusto;
- criação automática de conversas por voz;
- macro memory funcional;
- verificador de suficiência;
- redação executiva avançada;
- orquestração concorrente completa.

### Pacote de entregáveis esperado dos contratados ao final da Phase 1

O time deve entregar:
- UI funcional das 4 guias;
- CRUD mínimo de conversas;
- obrigatoriedade de título;
- busca por guia e título;
- persistência de mensagens;
- upload e listagem de anexos;
- trilha inicial de auditoria;
- testes funcionais básicos da navegação e persistência.

### Phase 2 - Voice-first Interaction

_A aprofundar na continuação desta SPEC._

### Arquitetura-alvo em LangChain/LangGraph

A leitura correta do repositório de curadoria enviado não deve ser literal. O valor dele está na lógica arquitetural: separar papéis, modularizar know-how, explicitar workflow, estabelecer critérios de suficiência e persistir artefatos intermediários e finais.

No contexto deste sistema, a melhor tradução para LangChain/LangGraph é:
- Deep Agent como coordenador principal;
- skills como know-how sob demanda;
- subagents/supervisor no lugar de Team;
- LangGraph custom workflow no lugar de workflow/loop do Agno;
- kernel local de orquestração para concorrência real do produto;
- Base de Verdade Institucional acoplada ao pipeline de notícias, concorrência e regulação.

Em uma frase: o módulo de notícias não deve ser um “agente jornalista”, mas um conjunto de workflows de inteligência institucional, coordenados por um Deep Agent, com subagents e skills especializados.

### Tradução inicial do repositório para o sistema

A solução-base traduzida do repositório para este sistema é a seguinte:

#### 1. Deep Agent coordenador
Função:
- entender o pedido do Giuseppe;
- escolher o tipo de curadoria;
- decidir quais skills e subagents acionar;
- sintetizar o resultado final para a conversa.

#### 2. Subagents especializados iniciais
Primeira tradução operacional do repositório para LangChain:
- **Oficial Researcher**: busca e resume atos, normativos, comunicados e fontes oficiais;
- **Competitor Researcher**: rastreia faculdades privadas concorrentes por curso, preço, campanha, oferta e diferenciais;
- **Market Analyst**: consolida sinais de mercado macro;
- **Evidence Verifier**: cruza convergência, divergência, recência, suficiência e confiança;
- **Executive Writer**: gera saída final no formato institucional certo.

#### 3. Skills iniciais
As skills iniciais devem ser enxutas e reutilizáveis:
- `pesquisa-fontes-oficiais-ies`;
- `pesquisa-concorrencia-direta`;
- `classificacao-de-fontes`;
- `verificacao-de-suficiencia`;
- `normalizacao-de-evidencias`;
- `geracao-alerta-executivo`;
- `geracao-dossie-comparativo`.

#### 4. Workflow LangGraph inicial
Cada execução de curadoria roda assim:
1. classificar pedido ou gatilho;
2. definir cobertura exigida;
3. coletar fontes em paralelo;
4. normalizar e deduplicar;
5. enriquecer com base interna da IES;
6. verificar suficiência e frescor;
7. se insuficiente, executar laço de reapuração orientada;
8. sintetizar e publicar;
9. persistir em conversa, dossiê e memória macro.

#### 5. Regra de suficiência melhor do que a do repositório original
Em vez de apenas “mínimo de 3 fontes”, usar regras específicas por tipo de saída:

- **Radar regulatório**: pelo menos 1 fonte oficial primária;
- **Radar da concorrência**: pelo menos 2 evidências públicas do concorrente, quando possível;
- **Relatório comparativo**: pelo menos 1 evidência externa e fatos internos da IES relacionados;
- **Alerta executivo**: precisa de confiança mínima e classificação de impacto.

#### 6. Tradução final da lógica do repositório
O que no repositório era:
- pesquisa;
- apuração;
- verificação;
- redação.

No sistema passa a ser:
- descoberta;
- coleta multi-fonte;
- validação e classificação;
- cruzamento com verdade institucional;
- síntese executiva;
- persistência e memória.

### Refinamento da arquitetura: modelo hierárquico definitivo

A tradução inicial acima é útil para compreender a lógica do repositório. Porém, para a realidade completa deste sistema, ela precisa ser refinada: os domínios principais não devem permanecer como especialistas rasos. Cada domínio principal deve ser um **Deep Agent coordenador**, com sua própria microarquitetura de subagents, skills, workflow, memória operacional e política de saída.

Assim, a arquitetura correta do sistema não é um supervisor com cinco especialistas simples. Ela é uma **hierarquia de Deep Agents coordenadores**, onde:
- o Deep Agent Executivo roteia o caso;
- cada Deep Agent de domínio assume sua parte do trabalho;
- cada domínio usa seus subagents internos;
- cada domínio carrega suas skills sob demanda;
- cada domínio executa seu workflow próprio;
- o resultado sobe em camadas até a resposta executiva final.

Em termos práticos, o sistema não terá uma equipe plana de agentes. Terá uma organização multiagente em árvore, com coordenação central e coordenações de domínio.

### Hierarquia definitiva dos Deep Agents coordenadores

#### Camada 0 — Kernel local de orquestração do produto
É o runtime real do sistema desktop:
- fila por conversa;
- concorrência local;
- retomada;
- locks;
- persistência;
- prioridades;
- cancelamento e pausa.

Ele não é substituído por Deep Agents. Deep Agents entram como camada cognitiva; o kernel local continua sendo a camada operacional do produto.

#### Camada 1 — Deep Agent Executivo Roteador
Responsável por:
- entender o pedido do Giuseppe;
- classificar o tipo de trabalho;
- decidir a composição de domínios;
- acionar 1 ou mais Deep Agents de domínio;
- receber os artefatos estruturados;
- montar a resposta final ou encaminhar para redação executiva.

#### Camada 2 — Deep Agents de domínio
Taxonomia recomendada:

##### Domínios primários
- Regulação e Normas;
- Concorrência;
- Mercado Educacional;
- Diagnóstico e Planejamento Interno.

##### Domínios transversais
- Verificação de Evidências;
- Cruzamento com Base de Verdade Institucional.

##### Domínio finalizador
- Redação Executiva.

#### Camada 3 — Subagents internos por domínio
Cada Deep Agent de domínio possui seus próprios subagents especializados.

#### Camada 4 — Skills por domínio
Cada Deep Agent carrega apenas suas próprias skills sob demanda.

#### Camada 5 — Workflows por domínio
Cada Deep Agent de domínio possui um workflow explícito em LangGraph, com etapas, laços, critérios de suficiência e pontos de persistência próprios.

### Subagents de cada domínio

#### A. Deep Agent — Regulação e Normas
Subagents:
- Monitor MEC/SERES/CNE;
- Monitor e-MEC;
- Monitor INEP/avaliação;
- Monitor Programas Governamentais;
- Analista de Vigência;
- Analista de Impacto Institucional.

#### B. Deep Agent — Concorrência
Subagents:
- Monitor de Preço;
- Monitor de Bolsas e Incentivos;
- Monitor de Campanhas e Narrativas;
- Monitor de Oferta Acadêmica;
- Monitor de Diferenciais Visíveis;
- Analista Comparativo por Curso.

#### C. Deep Agent — Mercado Educacional
Subagents:
- Analista de Tendências Macro;
- Analista Regional;
- Analista de Posicionamento por Curso;
- Analista de Mudança de Comportamento de Ingresso;
- Analista de Sinais de Inovação.

#### D. Deep Agent — Diagnóstico e Planejamento Interno
Subagents:
- Leitor da Base Institucional;
- Analista de Gaps;
- Analista de Aderência da Prática ao Documento;
- Analista de Oportunidades;
- Planejador de Ações;
- Planejador de Plano por Curso.

#### E. Deep Agent — Verificação de Evidências
Subagents:
- Verificador de Recência;
- Verificador de Convergência;
- Verificador de Conflito;
- Verificador de Suficiência;
- Classificador de Confiança;
- Detetor de Lacuna de Base.

#### F. Deep Agent — Redação Executiva
Subagents:
- Gerador de Alerta Curto;
- Gerador de Relatório Executivo;
- Gerador de Dossiê Comparativo;
- Gerador de Parecer Analítico;
- Revisor de Objetividade e Formatação;
- Ajustador ao Perfil do Giuseppe.

### Skills por domínio

#### Skills do domínio Regulação e Normas
- `pesquisa-fontes-oficiais-ies`;
- `verificacao-vigencia-normativa`;
- `classificacao-impacto-regulatorio`;
- `geracao-sintese-regulatoria`;
- `mapeamento-norma-processo-interno`.

#### Skills do domínio Concorrência
- `coleta-concorrencia-privada`;
- `normalizacao-atributos-concorrenciais`;
- `comparacao-preco-bolsa`;
- `analise-narrativa-campanha`;
- `dossie-competitivo-por-curso`.

#### Skills do domínio Mercado Educacional
- `leitura-sinais-mercado`;
- `identificacao-tendencias-por-curso`;
- `analise-regional`;
- `analise-posicionamento`.

#### Skills do domínio Diagnóstico e Planejamento Interno
- `consulta-base-institucional`;
- `analise-gap-interno`;
- `geracao-plano-captacao`;
- `analise-aderencia-pratica-documento`;
- `priorizacao-impacto-esforco`.

#### Skills do domínio Verificação
- `verificacao-suficiencia`;
- `verificacao-convergencia`;
- `verificacao-conflito`;
- `classificacao-confianca`;
- `detector-lacuna-evidencia`.

#### Skills do domínio Redação Executiva
- `geracao-alerta-executivo`;
- `geracao-relatorio-executivo`;
- `geracao-parecer`;
- `geracao-dossie-comparativo`;
- `adequacao-estilo-giuseppe`.

### Workflows por domínio

#### Workflow — Regulação e Normas
1. classificar o tema regulatório;
2. coletar atos e fontes oficiais;
3. filtrar por vigência e hierarquia;
4. identificar impacto na IES;
5. enviar para verificação;
6. cruzar com base institucional;
7. gerar síntese executiva;
8. persistir em dossiê, conversa e memória macro.

#### Workflow — Concorrência
1. identificar curso e mercado-alvo;
2. levantar concorrentes prioritários;
3. coletar preço, bolsas, campanhas, oferta e diferenciais;
4. normalizar atributos;
5. verificar suficiência e recência;
6. cruzar com base institucional;
7. gerar análise comparativa;
8. abrir alerta, relatório ou plano.

#### Workflow — Mercado Educacional
1. detectar tema ou tendência;
2. coletar sinais macro e regionais;
3. agrupar por curso, região e modalidade;
4. verificar consistência;
5. cruzar com vulnerabilidades e oportunidades internas;
6. produzir insight acionável.

#### Workflow — Diagnóstico e Planejamento Interno
1. carregar fatos internos do tema;
2. carregar decisões históricas micro e macro;
3. comparar com mercado, concorrência e regulação;
4. gerar gaps;
5. priorizar;
6. transformar em plano, ação ou documento.

#### Workflow — Verificação de Evidências
1. receber pacote analítico;
2. checar fontes, recência e cobertura;
3. detectar conflitos;
4. medir confiança;
5. apontar lacunas;
6. devolver selo de verificação e observações.

#### Workflow — Redação Executiva
1. receber pacote já validado;
2. escolher formato de saída;
3. aplicar perfil do Giuseppe;
4. montar documento ou resposta;
5. passar revisor formal;
6. devolver artefato final.

### Contratos de entrada e saída entre agentes

Os contratos entre agentes não podem ser texto livre. Devem ser artefatos estruturados estáveis, utilizáveis pelo sistema e auditáveis.

#### Contrato de entrada padrão para Deep Agent de domínio
- `request_id`;
- `conversation_id`;
- `workspace`;
- `task_type`;
- `goal`;
- `entities`;
- `internal_context_refs`;
- `constraints`.

#### Contrato de saída padrão de domínio
- `domain`;
- `status`;
- `summary`;
- `findings`;
- `evidence_refs`;
- `confidence`;
- `coverage`;
- `conflicts`;
- `gaps`;
- `recommended_next_step`;
- `suggested_output_type`.

#### Contrato de saída do verificador
- `verification_status`;
- `confidence_score`;
- `sufficiency_score`;
- `recency_score`;
- `conflicts`;
- `missing_evidence`;
- `approved_for_writing`;
- `human_review_required`.

#### Contrato de saída da redação executiva
- `output_type`;
- `title`;
- `executive_text`;
- `document_sections`;
- `printable`;
- `style_profile_version`;
- `source_trace_refs`.

### Integração entre curadoria externa e base institucional

Nenhum domínio externo deve concluir sozinho. Toda curadoria relevante precisa passar por uma camada transversal de **Cruzamento com Base de Verdade Institucional**.

Funções:
- buscar fatos internos vigentes;
- resolver qual fato é canônico;
- dizer o que é verdade interna, o que é fonte externa e o que é inferência;
- anexar evidência institucional ao caso;
- detectar contradição entre “o que a IES é ou faz” e “o que o mercado ou a norma exige”.

#### Fluxo integrado
1. domínio externo produz achados;
2. achados vão para verificação preliminar;
3. ocorre cruzamento com base institucional;
4. só então a análise sobe para o roteador executivo;
5. redação executiva usa sempre evidência externa, evidência interna e estado de conflito ou lacuna.

#### Regra prática
- notícia sem cruzamento institucional = sinal, não conclusão;
- concorrência sem cruzamento institucional = monitoramento, não recomendação;
- regulação sem cruzamento institucional = resumo normativo, não impacto executivo.

### Critérios de escalonamento entre agentes

O Deep Agent Executivo Roteador deve aplicar estas regras:

#### Caso simples
Um único domínio resolve.

#### Caso composto em paralelo
Dois ou mais domínios são acionados juntos.

#### Caso em cadeia
Um domínio prepara, outro valida, outro finaliza.

#### Caso de aprofundamento
Se a cobertura vier insuficiente, o roteador reenvia o caso ao mesmo domínio com refinamento de objetivo ou amplia para outro domínio complementar.

#### Caso sensível
Se houver risco regulatório, jurídico, contratual, trabalhista, proteção de dados ou mudança institucional relevante:
- obrigar passagem por Verificação;
- avaliar human-in-the-loop;
- só então liberar para redação final.

#### Critérios objetivos de escalonamento
- criticidade do tema;
- quantidade de fontes exigidas;
- necessidade de cruzamento com base interna;
- presença de conflito;
- confiança do verificador;
- tipo de saída solicitada;
- impacto executivo potencial.

### Papel do verificador e da redação executiva

#### Papel do verificador
O verificador não é decorativo. Ele é o principal freio técnico contra:
- alucinação;
- conclusão prematura;
- extrapolação indevida;
- conflito não percebido;
- saída eloquente sem base.

Ele deve:
- medir suficiência;
- medir recência;
- medir convergência;
- detectar conflito;
- apontar lacuna de base;
- classificar confiança;
- autorizar ou não a redação final.

##### Estados de saída do verificador
- verde: base suficiente, pode redigir;
- amarelo: base parcial, pode redigir com ressalvas ou checklist;
- vermelho: conflito, alto risco ou lacuna essencial; não liberar texto conclusivo.

#### Papel da redação executiva
A Redação Executiva não pesquisa nem inventa base. Ela:
- recebe o pacote já validado;
- escolhe o formato de saída;
- adapta ao estilo do Giuseppe;
- organiza para leitura rápida;
- produz material imprimível e documentável.

#### Regra de separação
- pesquisa e análise ficam nos domínios primários;
- validação fica no verificador;
- forma final fica na redação.

### Human-in-the-loop nos casos sensíveis

O sistema deve inserir human-in-the-loop nos seguintes cenários:

#### 1. Jurídico-regulatório sensível
Antes de:
- concluir recomendação contratual;
- concluir interpretação normativa com impacto operacional;
- gerar parecer de alto risco.

#### 2. Alteração de verdade institucional
Antes de:
- promover fato novo a fato canônico;
- substituir preço vigente;
- mudar política, contrato, infraestrutura ou processo cadastrado.

#### 3. Ações externas sensíveis
Antes de:
- publicar ou exportar documento oficial;
- iniciar ação operacional sugerida de alto impacto;
- consolidar recomendação com potencial financeiro ou trabalhista.

#### 4. Casos de confiança baixa ou conflito alto
Quando o verificador devolver:
- `verification_status = red`;
- ou `human_review_required = true`.

#### Formas de interação
- aprovar;
- rejeitar;
- editar instrução;
- editar artefato;
- pedir nova rodada de coleta ou verificação.

#### Regra de UX
O Giuseppe não deve ver jargão técnico. Ele deve ver mensagens como:
- “Há conflito entre base interna e fontes externas”;
- “Esta conclusão precisa de revisão”;
- “Deseja aprovar esta interpretação?”;
- “Deseja que eu refine a análise antes de concluir?”.

### Decisão arquitetural consolidada

A formulação consolidada desta continuação é:

- o sistema deve usar Deep Agent como coordenador principal;
- skills devem funcionar como know-how sob demanda;
- subagents e supervisor substituem a ideia de Team do repositório original;
- LangGraph custom workflow substitui a lógica de workflow e loop do Agno;
- o kernel local de orquestração continua responsável pela concorrência real do produto;
- a Base de Verdade Institucional deve estar acoplada ao pipeline de notícias, concorrência e regulação.

Em forma operacional:

1 roteador executivo → vários coordenadores de domínio → subagents internos → skills e workflows especializados.

Isso resolve profundidade, isolamento de contexto, escalabilidade, reuso, governança, economia de tokens e aderência ao produto real.

### Context Persistence Protocol

A persistência de contexto dos agentes não deve ser tratada como detalhe secundário de memória. Ela deve ser uma disciplina operacional do sistema, aplicada em todas as conversas, workflows e handoffs entre domínios.

O objetivo deste protocolo é garantir que o sistema:
- mantenha continuidade entre sessões sem depender de histórico bruto completo;
- compacte o contexto em momentos lógicos;
- reidrate apenas o contexto necessário para a próxima ação;
- transforme saídas verificadas em memória reutilizável;
- evite poluição entre casos, sessões e domínios;
- aprenda com erros, correções, rejeições e sucessos operacionais.

### Tipos de memória utilizados pelo protocolo

#### Session Ledger Memory
Memória viva da sessão ou do trabalho corrente.

Função:
- registrar o estado atual do caso;
- preservar continuidade entre abertura, pausa e retomada;
- guardar decisões recentes, blockers e próximo passo.

#### Case Memory
Memória compacta do caso específico.

Função:
- manter a narrativa consolidada do trabalho;
- armazenar achados aceitos, hipóteses e decisões locais;
- servir de base para retomada sem replay completo da conversa.

#### Macro Memory
Memória consolidada por guia, curso, programa, linha de ação ou tema.

Função:
- ligar casos micro a supervisão macro;
- acumular padrões recorrentes, riscos abertos e ações em andamento;
- fornecer visão executiva para diagnósticos e planejamento.

#### Institutional Truth Memory
Memória canônica da Base de Verdade Institucional.

Função:
- guardar fatos internos validados e versionados;
- garantir precedência da realidade institucional sobre memória operacional do agente;
- impedir que hipótese ou resumo momentâneo se torne “verdade” por acidente.

#### Agent Operational Memory
Memória de aprendizado operacional dos agentes.

Função:
- guardar padrões do que funcionou, do que falhou e do que deve ser evitado;
- preservar heurísticas úteis por domínio;
- melhorar handoffs futuros e reduzir retrabalho.

#### Executive Preference Memory
Memória do perfil executivo do Giuseppe.

Função:
- adaptar escrita, estrutura, objetividade e critérios de qualidade;
- aprender padrões de revisão, decisão e reprovação;
- influenciar apenas forma, organização e priorização, sem substituir evidência factual.

### Regra de precedência entre memórias

Quando houver conflito entre blocos de memória, o sistema deve obedecer à seguinte precedência:

1. verdade institucional canônica;
2. estado validado do caso atual;
3. memória macro relevante;
4. memória operacional dos agentes;
5. preferências executivas do Giuseppe;
6. hipóteses temporárias e inferências ainda não verificadas.

### Session Ledger Model

Cada conversa ativa e cada workflow relevante devem possuir um Session Ledger persistido.

Campos mínimos:
- `session_id`;
- `conversation_id`;
- `workflow_id`;
- `workspace`;
- `phase`;
- `goal`;
- `accepted_facts`;
- `evidence_refs`;
- `decisions`;
- `attempted_approaches`;
- `failed_approaches`;
- `blockers`;
- `open_questions`;
- `next_step`;
- `verification_state`;
- `last_compaction_ref`;
- `created_at`;
- `updated_at`.

Esse ledger não é uma transcrição. Ele é um objeto de estado operacional.

### Lifecycle events for memory persistence

O protocolo deve ser ativado por eventos formais de lifecycle.

#### `ConversationStart`
- cria ou reabre o ledger;
- registra objetivo inicial;
- registra contexto base usado na abertura.

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

