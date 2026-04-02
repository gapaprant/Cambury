### Detalhamento dos Deep Agents de domínio primário em nível operacional

#### Objetivo deste bloco

Transformar os domínios primários já definidos conceitualmente em unidades operacionais implementáveis, com responsabilidade clara, subagents internos, artefatos esperados, regras de entrada e saída, e política de integração com a Base de Verdade Institucional e com o domínio de Verificação.

Os três domínios primários priorizados nesta continuidade são:
- Concorrência;
- Regulação e Normas;
- Diagnóstico e Planejamento Interno.

Cada um deles deve ser tratado como um **Deep Agent coordenador de domínio**, não como um prompt isolado.

### Modelagem interna do domínio Concorrência

#### Missão do domínio

Analisar concorrentes privados relevantes, especialmente diretos, produzindo comparação estruturada entre sinais externos observáveis e a realidade interna da IES, com foco em:
- preço;
- bolsas e incentivos;
- campanhas e narrativa comercial;
- oferta acadêmica;
- diferenciais visíveis;
- mudanças recentes;
- impacto potencial na captação.

#### Quando este domínio deve ser acionado
- comparação competitiva por curso;
- consulta sobre preço ou bolsa de concorrente;
- análise de campanha ou narrativa de concorrente;
- detecção de movimento relevante de concorrência;
- apoio a plano de captação ou reposicionamento;
- apoio a diagnóstico institucional com recorte competitivo.

#### Quando não deve ser acionado isoladamente
- quando a pergunta for apenas documental interna;
- quando o tema for puramente regulatório sem relação competitiva;
- quando não houver concorrente, curso ou recorte de mercado minimamente definido e o caso ainda precisar de clarificação estrutural.

### Subagents internos do domínio Concorrência

#### 1. Price Monitor
Função:
- identificar preços públicos observáveis;
- capturar forma de apresentação comercial do preço;
- registrar vigência aparente, quando inferível.

#### 2. Incentive Monitor
Função:
- mapear bolsas, descontos, campanhas de matrícula, condições especiais e incentivos comerciais públicos.

#### 3. Campaign Narrative Monitor
Função:
- capturar slogan, promessa central, apelo de marca, diferenciais destacados e linguagem de campanha.

#### 4. Academic Offer Monitor
Função:
- mapear curso, modalidade, turno, polo, formato, novos lançamentos ou reposicionamentos aparentes.

#### 5. Differentials Monitor
Função:
- identificar laboratórios, empregabilidade, parcerias, infraestrutura, metodologia e outros diferenciais públicos utilizados na comunicação.

#### 6. Comparative Analyst
Função:
- consolidar os sinais coletados;
- cruzar com a Base de Verdade Institucional;
- estruturar gap competitivo inicial.

### Skills do domínio Concorrência

- `coleta-preco-concorrente`;
- `coleta-bolsa-e-incentivo`;
- `analise-narrativa-campanha`;
- `normalizacao-atributos-competitivos`;
- `comparacao-concorrente-vs-ies`;
- `geracao-dossie-competitivo`.

### Workflow interno do domínio Concorrência

#### Etapa 1 — Delimitação competitiva
- identificar curso;
- identificar recorte geográfico;
- identificar concorrentes diretos prioritários;
- identificar escopo analítico do caso.

#### Etapa 2 — Coleta de sinais públicos
- preços;
- incentivos;
- páginas de curso;
- landing pages;
- campanhas;
- novidades observáveis.

#### Etapa 3 — Normalização
- transformar coleta bruta em atributos comparáveis;
- remover duplicidade;
- anotar lacunas ou baixa confiança.

#### Etapa 4 — Cruzamento institucional
- trazer fatos internos relacionados ao mesmo curso;
- comparar realidade interna e sinais externos;
- detectar divergência ou oportunidade.

#### Etapa 5 — Síntese competitiva
- produzir achados principais;
- estimar impacto na captação;
- sugerir próximo passo.

#### Etapa 6 — Encaminhamento
- enviar ao verificador;
- ou, quando o caso for exploratório de baixa criticidade, produzir checkpoint inicial.

### Artefatos de saída do domínio Concorrência

- mapa competitivo do curso;
- comparativo de preço e incentivos;
- síntese de narrativa de concorrência;
- dossiê competitivo;
- alerta de mudança relevante;
- bloco de insumos para plano de captação.

### Estados de qualidade do retorno do domínio Concorrência

- `broad_signal_only`: sinais ainda amplos, úteis apenas como radar;
- `course_comparable`: já existe base mínima para comparação por curso;
- `competitive_gap_ready`: já existe gap competitivo suficientemente estruturado;
- `insufficient_public_evidence`: a análise deve subir com lacuna explícita.

### Modelagem interna do domínio Regulação e Normas

#### Missão do domínio

Interpretar, consolidar e contextualizar normas, atos, sinais regulatórios e mudanças oficiais relevantes para a IES, sempre conectando o texto normativo com o impacto institucional prático.

#### Quando este domínio deve ser acionado
- perguntas sobre leis, atos, portarias, resoluções e orientações oficiais;
- análise de impacto de ato regulatório sobre curso, prática ou documento;
- monitoramento de mudança regulatória;
- produção de parecer, nota ou alerta regulatório;
- casos jurídicos/regulatórios com base oficial predominante.

#### Quando não deve ser acionado isoladamente
- quando a pergunta for apenas sobre opinião estratégica sem conteúdo regulatório;
- quando a questão for somente documental interna e não envolver base normativa;
- quando o caso depender antes de fatos institucionais ainda não disponíveis.

### Subagents internos do domínio Regulação e Normas

#### 1. Official Acts Monitor
Função:
- localizar ato oficial, publicação ou atualização relevante.

#### 2. Norm Validity Analyst
Função:
- verificar vigência, alteração, hierarquia e relação com normas anteriores.

#### 3. Institutional Impact Analyst
Função:
- traduzir o ato para impacto institucional, curso, processo, documento ou prática.

#### 4. Program and Policy Monitor
Função:
- acompanhar programas governamentais, regras operacionais e alterações correlatas.

#### 5. Regulatory Synthesis Analyst
Função:
- consolidar entendimento normativo e produzir insumo executivo.

### Skills do domínio Regulação e Normas

- `pesquisa-ato-oficial`;
- `verificacao-vigencia-hierarquia`;
- `sintese-impacto-regulatorio`;
- `mapeamento-norma-processo`;
- `geracao-alerta-regulatorio`;
- `parecer-regulatorio-preliminar`.

### Workflow interno do domínio Regulação e Normas

#### Etapa 1 — Delimitação normativa
- identificar ato, tema, órgão, programa ou conceito regulatório;
- identificar se a pergunta é descritiva, interpretativa ou aplicativa.

#### Etapa 2 — Coleta oficial
- reunir atos, publicações, bases e sinais oficiais pertinentes.

#### Etapa 3 — Vigência e hierarquia
- identificar norma vigente, complementar, alteradora ou superada;
- anotar dependências normativas relevantes.

#### Etapa 4 — Tradução para a realidade da IES
- conectar o ato a curso, processo, contrato, política ou documento institucional;
- enviar ao domínio transversal de cruzamento institucional quando necessário.

#### Etapa 5 — Síntese regulatória
- produzir resumo executivo;
- destacar impacto, risco, lacuna e ação sugerida.

#### Etapa 6 — Encaminhamento seguro
- enviar ao verificador;
- ou gerar checkpoint regulatório preliminar se o caso ainda não puder ser concluído.

### Artefatos de saída do domínio Regulação e Normas

- síntese regulatória preliminar;
- alerta regulatório;
- mapa de impacto institucional;
- parecer preliminar;
- checklist de adequação;
- insumo validável para Redação Executiva.

### Estados de qualidade do retorno do domínio Regulação e Normas

- `descriptive_only`: apenas descreve norma, sem impacto institucional consolidado;
- `impact_mapped`: impacto institucional inicial já mapeado;
- `regulatory_case_ready`: caso regulatório pronto para verificação/redação;
- `normative_conflict_or_gap`: conflito ou lacuna impeditiva identificada.

### Modelagem interna do domínio Diagnóstico e Planejamento Interno

#### Missão do domínio

Converter contexto interno, contexto macro, comparações externas e histórico do caso em diagnóstico acionável e planejamento estruturado, especialmente para:
- captação por curso;
- posicionamento;
- organização de ações executivas;
- melhorias institucionais;
- planos ou refatorações de trabalho.

#### Quando este domínio deve ser acionado
- criação ou revisão de plano;
- diagnóstico crítico da situação atual;
- organização de ações por curso;
- comparação entre prática atual e oportunidade externa;
- síntese interna para tomada de decisão.

#### Quando não deve ser acionado isoladamente
- quando não houver fatos internos mínimos;
- quando o caso depender essencialmente de norma ou concorrência ainda não analisadas;
- quando a tarefa for apenas recuperar documento pronto sem necessidade analítica.

### Subagents internos do domínio Diagnóstico e Planejamento Interno

#### 1. Institutional Facts Reader
Função:
- recuperar fatos internos relevantes do curso, processo, documento ou tema.

#### 2. Gap Analyst
Função:
- identificar diferença entre estado atual e estado desejado.

#### 3. Practice-vs-Document Analyst
Função:
- comparar prática atual com documentos, políticas ou diretrizes já registradas.

#### 4. Opportunity Analyst
Função:
- relacionar sinais externos com oportunidades internas.

#### 5. Action Planner
Função:
- transformar diagnóstico em ações organizadas.

#### 6. Course Plan Builder
Função:
- estruturar plano por curso, com lógica executiva e checkpoints.

### Skills do domínio Diagnóstico e Planejamento Interno

- `consulta-fatos-institucionais`;
- `analise-gap-estado-atual`;
- `comparacao-pratica-documento`;
- `priorizacao-impacto-esforco`;
- `geracao-esqueleto-plano`;
- `refatoracao-plano-existente`.

### Workflow interno do domínio Diagnóstico e Planejamento Interno

#### Etapa 1 — Leitura do estado atual
- recuperar fatos internos;
- recuperar histórico relevante da conversa;
- recuperar macro memory útil;
- identificar objetivo executivo do caso.

#### Etapa 2 — Diagnóstico inicial
- descrever situação atual;
- identificar pontos fortes, lacunas, bloqueios e incoerências.

#### Etapa 3 — Incorporação externa
- absorver sinais de concorrência, mercado ou regulação quando já disponíveis;
- anotar o que ainda falta para diagnóstico completo.

#### Etapa 4 — Estruturação de ações
- transformar achados em linhas de ação;
- organizar por prioridade, impacto e sequência.

#### Etapa 5 — Geração de plano ou recomendação
- produzir estrutura inicial de plano;
- ou gerar recomendação executiva estruturada.

#### Etapa 6 — Encaminhamento
- seguir para verificação;
- ou seguir para Redação Executiva quando a natureza do caso permitir checkpoint útil imediato.

### Artefatos de saída do domínio Diagnóstico e Planejamento Interno

- diagnóstico executivo inicial;
- mapa de gaps;
- estrutura de plano;
- plano de ação por curso;
- recomendação priorizada;
- insumo para relatório executivo.

### Estados de qualidade do retorno do domínio Diagnóstico e Planejamento Interno

- `diagnostic_sketch`: diagnóstico ainda exploratório;
- `actionable_diagnosis`: diagnóstico já acionável;
- `plan_skeleton_ready`: plano inicial pronto para refinamento;
- `insufficient_internal_basis`: base interna insuficiente para planejamento robusto.

### Aprofundamento da política de verificação multiestágio

#### Objetivo deste bloco

Definir como a verificação deve operar em camadas, acompanhando o caso ao longo do tempo em vez de aparecer apenas no final como etapa binária.

### Princípio central

Verificação não é apenas “aprovar ou reprovar no final”. Ela deve atuar como trilha progressiva de governança cognitiva.

### Estágios de verificação

#### Stage 1 — Intake verification
Objetivo:
- verificar se o caso foi formulado com objetivo suficiente;
- detectar falta grave de contexto antes de delegações profundas.

Verifica:
- clareza do objetivo;
- entidades mínimas;
- tipo de saída esperado;
- risco inicial do caso.

#### Stage 2 — Domain output verification
Objetivo:
- qualificar retorno de cada domínio.

Verifica:
- suficiência do retorno do domínio;
- existência de conflitos;
- cobertura mínima para o tipo de caso;
- aderência ao escopo delegado.

#### Stage 3 — Cross-domain verification
Objetivo:
- validar coerência entre múltiplos domínios.

Verifica:
- compatibilidade entre concorrência, regulação, diagnóstico e base institucional;
- lacunas entre domínios;
- contradições analíticas.

#### Stage 4 — Pre-writing verification
Objetivo:
- decidir se já existe base suficiente para redação executiva.

Verifica:
- status de conflito;
- aderência institucional;
- suficiência de evidência;
- necessidade de human-in-the-loop.

#### Stage 5 — Final release verification
Objetivo:
- garantir que a saída liberada está consistente com a governança do caso.

Verifica:
- status do workflow;
- consistência da entrega final;
- bloqueios pendentes;
- conformidade com política de risco.

### Matrizes de decisão da verificação

#### Selo por estágio
- `green`
- `yellow`
- `red`

#### Interpretação
- `green`: pode seguir normalmente;
- `yellow`: pode seguir com ressalvas, checklist ou checkpoint parcial;
- `red`: bloquear conclusão e escalar revisão.

### Regras de escalonamento da verificação

- `red` em qualquer estágio sensível bloqueia redação final;
- `yellow` em domínio isolado pode seguir para checkpoint parcial, mas não para conclusão forte sem rechecagem;
- `green` em domínio não dispensa verificação cruzada quando houver múltiplos domínios.

### Artefatos de verificação

Cada estágio deve gerar um artefato persistido contendo:
- `verification_stage`;
- `verification_status`;
- `confidence_score`;
- `sufficiency_score`;
- `recency_score` quando aplicável;
- `conflicts`;
- `gaps`;
- `allowed_next_steps`;
- `blocked_next_steps`;
- `created_at`.

### Integração da verificação com checkpoints executivos

- `green` permite checkpoint com avanço claro;
- `yellow` permite checkpoint com ressalvas explícitas;
- `red` exige checkpoint orientado a bloqueio, revisão ou nova coleta.

### Regras de UX da verificação multiestágio

O Giuseppe não deve ver “Stage 1”, “Stage 2” ou termos técnicos internos. A tradução executiva deve ser algo como:
- “Entendimento inicial suficiente para seguir”;
- “Há base parcial, mas ainda faltam confirmações”;
- “Há conflito relevante antes de concluir”;
- “O texto já pode ser preparado”;
- “A conclusão final ainda exige revisão.”

### Critérios de consistência dos domínios primários e da verificação

- nenhum domínio primário deve operar sem missão e workflow definidos;
- nenhum domínio deve devolver saída sem estado de qualidade do próprio retorno;
- toda conclusão relevante sobre a IES deve passar por cruzamento institucional;
- toda conclusão sensível deve passar por verificação multiestágio;
- todo checkpoint executivo deve refletir o estágio real do caso.

### Critérios técnicos de aceite destes blocos

Os blocos acrescentados nesta continuação da SPEC-006 só devem ser considerados concluídos quando:

1. os domínios Concorrência, Regulação e Normas, e Diagnóstico e Planejamento Interno estiverem modelados como Deep Agents operacionais completos;
2. cada domínio possuir subagents, skills, workflow e artefatos de saída coerentes;
3. a verificação multiestágio conseguir acompanhar o caso do intake até a liberação final;
4. o sistema conseguir distinguir retorno exploratório, retorno acionável, retorno bloqueado e retorno pronto para redação;
5. a integração com Base de Verdade Institucional estiver prevista de forma obrigatória nos casos relevantes.

### Critérios funcionais de aceite destes blocos

Do ponto de vista do Giuseppe, estes blocos estarão prontos quando:
- o sistema souber trabalhar concorrência, regulação e planejamento como domínios distintos, mas coordenados;
- os resultados parecerem progressivamente mais consistentes e seguros;
- casos longos tragam checkpoints úteis em vez de silêncio ou respostas apressadas;
- o sistema sinalize claramente quando já pode concluir e quando ainda precisa aprofundar.

### Próximos blocos previstos para continuidade

- detalhamento interno do domínio transversal Cruzamento com Base de Verdade Institucional;
- detalhamento interno do domínio transversal Verificação de Evidências;
- modelagem operacional da Curadoria e Monitoramento contínuo;
- ligação entre monitoramento contínuo, alertas executivos e abertura automática de casos;
- preparação para consolidação final de Milestones e Gathering Results.

