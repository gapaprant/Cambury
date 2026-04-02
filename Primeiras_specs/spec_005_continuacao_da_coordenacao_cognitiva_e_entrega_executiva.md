### Detalhamento do Deep Agent Executivo Roteador

#### Objetivo deste bloco

Definir com precisão o papel do **Deep Agent Executivo Roteador** como cérebro de coordenação cognitiva do caso, situado entre o Agent Orchestrator e os Deep Agents de domínio.

O Agent Orchestrator decide que existe um trabalho cognitivo a ser conduzido. O Deep Agent Executivo decide **como esse trabalho será cognitivamente estruturado**, quais domínios participarão, em que ordem, com que paralelismo, com quais checkpoints e com qual estratégia de entrega.

#### Posição arquitetural do Deep Agent Executivo

O Deep Agent Executivo não substitui:
- a camada de voz;
- o Agent Orchestrator;
- o kernel local de orquestração;
- os Deep Agents de domínio;
- a Redação Executiva.

Ele ocupa a posição de **planejador e roteador cognitivo central**.

#### O que entra no Deep Agent Executivo

O Deep Agent Executivo recebe do Agent Orchestrator um **Executive Routing Pack** já consolidado com:
- objetivo do caso;
- guia e conversa resolvidas;
- entidades centrais;
- contexto mínimo reidratado;
- restrições do caso;
- risco percebido;
- tipo de saída pretendida;
- estado do ledger;
- prioridade do caso.

#### O que o Deep Agent Executivo produz

Ele devolve um **Execution Routing Plan** contendo:
- decomposição cognitiva do caso;
- domínios a acionar;
- justificativa da escolha dos domínios;
- ordem ou paralelismo sugerido;
- pontos obrigatórios de verificação;
- pontos de checkpoint executivo;
- política de entrega parcial;
- necessidade de human-in-the-loop;
- definição do finalizador do caso.

### Responsabilidades do Deep Agent Executivo

#### 1. Classificação cognitiva do caso
Ele deve responder:
- o caso é simples, composto, sensível ou longitudinal?
- o caso exige análise, monitoramento, planejamento, redação ou combinação desses?
- o caso exige comparação com base interna?
- o caso exige verificação forte antes de qualquer conclusão?

#### 2. Seleção de domínios
Ele deve decidir quais Deep Agents de domínio entram no caso.

Exemplo:
- um caso de regulação + impacto institucional pode exigir:
  - Regulação e Normas
  - Cruzamento com Base de Verdade Institucional
  - Verificação de Evidências
  - Redação Executiva

#### 3. Estratégia de ordem versus paralelismo
Ele deve decidir:
- o que pode rodar em paralelo;
- o que depende de resultado anterior;
- quando um domínio deve esperar outro;
- quando já existe base suficiente para checkpoint intermediário.

#### 4. Definição do padrão de entrega
Ele deve decidir se o caso pede:
- resposta direta;
- alerta executivo;
- síntese comparativa;
- plano;
- dossiê;
- parecer;
- relatório executivo.

#### 5. Governança de risco cognitivo
Ele deve marcar:
- necessidade de verificação obrigatória;
- possível sensibilidade jurídica/regulatória;
- chance de conflito com verdade institucional;
- necessidade de aprovação humana.

### Taxonomia cognitiva dos casos

Para manter consistência, o Deep Agent Executivo deve classificar o caso em uma taxonomia comum.

#### `simple_case`
- uma única linha de raciocínio;
- baixa dependência externa;
- baixa necessidade de decomposição.

#### `composite_case`
- múltiplas linhas de análise;
- dois ou mais domínios;
- necessidade de síntese coordenada.

#### `sensitive_case`
- alto risco regulatório, contratual, jurídico, reputacional ou institucional;
- exige verificação forte e possível human-in-the-loop.

#### `longitudinal_case`
- caso que não termina em uma única execução;
- exige monitoramento, checkpoints recorrentes e revisitação futura.

### Estratégias de decomposição cognitiva

#### Estratégia A — Linear
Usar quando um domínio depende claramente do resultado do anterior.

Exemplo:
1. Regulação e Normas
2. Cruzamento com Base Institucional
3. Verificação
4. Redação Executiva

#### Estratégia B — Paralela com síntese
Usar quando domínios podem coletar ou analisar em paralelo antes de síntese central.

Exemplo:
1. Concorrência
2. Mercado Educacional
3. Diagnóstico e Planejamento Interno
4. Verificação
5. Redação Executiva

#### Estratégia C — Exploratória com checkpoint precoce
Usar quando o caso ainda é aberto e precisa de entendimento inicial antes de grande expansão.

Exemplo:
1. coleta curta exploratória
2. checkpoint executivo
3. decisão de aprofundamento

#### Estratégia D — Monitoramento longitudinal
Usar quando o caso vira trilha contínua.

Exemplo:
1. caso inicial
2. baseline
3. regras de monitoramento
4. checkpoints periódicos

### Contrato operacional entre o Deep Agent Executivo e os Deep Agents de domínio

#### Objetivo deste bloco

Definir como o Deep Agent Executivo delega trabalho para os Deep Agents de domínio sem perder consistência, contexto e governança.

### Princípio de delegação

O Deep Agent Executivo não deve delegar uma frase genérica. Ele deve delegar um **Domain Assignment Pack** estruturado.

#### Campos mínimos do Domain Assignment Pack
- `assignment_id`;
- `workflow_id`;
- `conversation_id`;
- `domain_target`;
- `goal_statement`;
- `domain_objective`;
- `entities_in_scope`;
- `context_pack_ref`;
- `verification_requirement`;
- `expected_output_type`;
- `deadline_hint` opcional;
- `priority_hint`;
- `handoff_reason`.

### O que cada Deep Agent de domínio deve devolver

Cada domínio deve devolver um **Domain Result Package** contendo:
- `assignment_id`;
- `domain_name`;
- `result_status` (`ok`, `partial`, `blocked`, `conflicted`);
- `executive_summary`;
- `findings`;
- `evidence_refs`;
- `institutional_truth_refs` quando aplicável;
- `confidence_score`;
- `conflicts`;
- `gaps`;
- `suggested_next_step`;
- `ready_for_verification` booleano;
- `ready_for_writing` booleano.

### Regra de qualidade da delegação

Uma delegação válida precisa responder claramente:
- o que o domínio deve fazer;
- com base em quê;
- com qual profundidade;
- para produzir que tipo de saída;
- sob quais restrições.

### Regra de qualidade do retorno

Um retorno de domínio não é bom porque “parece inteligente”. Ele só é aceitável quando:
- tem escopo claro;
- apresenta achados rastreáveis;
- mostra lacunas e conflitos;
- deixa evidente o próximo passo;
- não mistura opinião livre com fato validado.

### Política de reentrada entre o Executivo e os domínios

Se o retorno do domínio vier `partial` ou `blocked`, o Deep Agent Executivo deve decidir entre:
- nova delegação ao mesmo domínio com objetivo refinado;
- acionamento de domínio complementar;
- checkpoint parcial ao usuário;
- encerramento temporário com lacuna explícita;
- escalonamento para verificação ou revisão humana.

### Refinamento dos domínios transversais de verificação e cruzamento com base institucional

#### Objetivo deste bloco

Transformar os domínios transversais em componentes formais de governança cognitiva do sistema, e não apenas etapas vagas “de checagem”.

Esses domínios são:
- **Verificação de Evidências**;
- **Cruzamento com Base de Verdade Institucional**.

Eles devem atuar como camadas obrigatórias em casos onde risco, conflito ou impacto justifiquem governança superior.

### Domínio transversal — Cruzamento com Base de Verdade Institucional

#### Função principal
Responder:
- o que deste caso já é fato institucional validado?
- o que está em conflito com a base institucional?
- o que ainda é hipótese externa ou inferência?
- quais fatos internos precisam ser atualizados, mas ainda não podem ser promovidos?

#### Entradas
- findings de domínio primário;
- entities do caso;
- context pack;
- referência a fatos canônicos relevantes.

#### Saída
- fatos internos confirmados relevantes;
- fatos ausentes;
- possíveis conflitos com a realidade institucional;
- status de aderência à Base de Verdade;
- sugestão de atualização ou bloqueio.

#### Estado de aderência sugerido
- `aligned`
- `partially_aligned`
- `conflicted`
- `insufficient_internal_truth`

### Domínio transversal — Verificação de Evidências

#### Função principal
Responder:
- há base suficiente para afirmar isso?
- há conflito entre fontes?
- a evidência é atual o bastante?
- a cobertura está adequada ao tipo de caso?
- a redação final pode ser liberada?

#### Entradas
- Domain Result Packages;
- status de aderência institucional;
- tipo de saída esperado;
- nível de criticidade do caso.

#### Saída
- `verification_status` (`green`, `yellow`, `red`);
- `confidence_score`;
- `sufficiency_score`;
- `recency_score`;
- conflitos detectados;
- lacunas detectadas;
- autorização ou bloqueio para redação.

### Regra de obrigatoriedade dos domínios transversais

#### Cruzamento com Base Institucional obrigatório quando
- houver qualquer conclusão sobre a IES;
- houver recomendação de ação interna;
- houver comparação com concorrência;
- houver implicação sobre cursos, preços, estrutura, contratos ou políticas.

#### Verificação obrigatória quando
- houver conclusão sensível;
- houver base externa relevante;
- houver potencial conflito;
- houver redação final de documento formal;
- houver impacto regulatório ou jurídico.

### Política de checkpoints executivos e entrega parcial de artefatos

#### Objetivo deste bloco

Definir como o sistema entrega valor ao Giuseppe ao longo de casos longos, sem esperar sempre o final completo do workflow.

### Tipos de checkpoint executivo

#### 1. `initial_checkpoint`
Emitido após o entendimento inicial do caso e primeiras coletas úteis.

Função:
- confirmar escopo do caso;
- mostrar linha inicial de trabalho;
- indicar se o caso parece simples, composto ou sensível.

#### 2. `analytical_checkpoint`
Emitido após uma rodada relevante de análise.

Função:
- apresentar achados parciais;
- mostrar lacunas e conflitos;
- indicar o próximo domínio ou verificação.

#### 3. `verification_checkpoint`
Emitido após verificação relevante.

Função:
- sinalizar se já há base suficiente para conclusão;
- indicar riscos;
- orientar se o caso segue para redação.

#### 4. `draft_checkpoint`
Emitido quando já existe saída parcial útil.

Função:
- mostrar esqueleto de documento, plano ou síntese;
- permitir refinamento antes da finalização.

#### 5. `final_checkpoint`
Emitido quando o caso alcança entrega principal.

Função:
- entregar artefato final;
- registrar conclusão;
- indicar possíveis próximos passos.

### Regras de checkpoint executivo

- checkpoints devem ser curtos e executivos;
- checkpoints não devem despejar dados brutos em excesso;
- checkpoints devem sempre dizer o que já foi feito, o que falta e o que o sistema recomenda fazer a seguir;
- checkpoints devem ser persistidos como artefatos formais do caso.

### Entrega parcial de artefatos

O sistema deve poder entregar parcialmente:
- mapa inicial de concorrência;
- síntese regulatória preliminar;
- esqueleto de plano;
- minuta inicial de parecer;
- dossiê parcial;
- checklist de verificação.

#### Regra de segurança da entrega parcial
Uma entrega parcial nunca deve parecer uma conclusão final se ainda houver conflito, lacuna ou verificação pendente.

### Modelo de artefato de checkpoint

Campos conceituais recomendados:
- `checkpoint_id`;
- `workflow_id`;
- `checkpoint_type`;
- `executive_summary`;
- `completed_work`;
- `open_gaps`;
- `next_step`;
- `requires_user_action`;
- `can_progress_without_user`;
- `created_at`.

### Detalhamento da Redação Executiva como finalizador de caso

#### Objetivo deste bloco

Formalizar a **Redação Executiva** como domínio finalizador do caso, responsável por transformar achados validados em entregas compreensíveis, imprimíveis, objetivas e aderentes ao estilo do Giuseppe.

A Redação Executiva não é um “agente que escreve bonito”. Ela é o último estágio controlado do caso.

### Funções da Redação Executiva

- transformar pacotes validados em saída final ou parcial utilizável;
- escolher formato de saída adequado;
- aplicar padrão de organização e objetividade;
- aplicar traços relevantes do perfil do Giuseppe;
- manter coerência com checkpoints anteriores;
- produzir material imprimível e auditável.

### Entradas da Redação Executiva

A Redação Executiva só deve receber:
- resultados de domínio já consolidados;
- status de verificação;
- aderência institucional já conhecida;
- tipo de saída esperado;
- perfil executivo relevante;
- template ou modelo documental quando aplicável.

### Saídas da Redação Executiva

#### Saídas conversacionais
- resposta executiva curta;
- síntese comparativa;
- recomendação objetiva;
- resumo de progresso.

#### Saídas documentais
- despacho;
- ofício;
- parecer;
- relatório executivo;
- plano de captação;
- checklist;
- dossiê comparativo.

### Política de formatos

A Redação Executiva deve sempre escolher entre três níveis de forma:

#### `chat_executive`
Para resposta dentro da conversa.

#### `structured_note`
Para síntese estruturada sem virar documento formal completo.

#### `formal_document`
Para documento institucional imprimível/exportável.

### Regras de redação

- começar pelo ponto principal;
- priorizar objetividade;
- evitar prolixidade;
- destacar achado, risco e ação sugerida;
- manter formato consistente com o tipo documental;
- não esconder lacunas;
- não transformar hipótese em afirmação.

### Revisão final interna da Redação Executiva

Antes de liberar uma saída, a Redação Executiva deve verificar:
- se o tipo de saída está correto;
- se o texto está coerente com o status de verificação;
- se o texto está coerente com a verdade institucional disponível;
- se o tom está adequado ao perfil do Giuseppe;
- se a estrutura está adequada ao template.

### Regras de bloqueio da Redação Executiva

A Redação Executiva não deve liberar saída conclusiva quando:
- `verification_status = red`;
- houver conflito institucional grave não resolvido;
- o caso estiver explicitamente marcado como sensível com revisão humana obrigatória;
- a base estiver incompleta para o tipo de documento solicitado.

#### Em caso de bloqueio
Ela deve produzir:
- explicação executiva curta;
- o que falta;
- o que já pode ser dito com segurança;
- checklist ou minuta intermediária quando útil.

### Modelo de pacote de redação

#### Input conceitual
- `writing_request_id`;
- `workflow_id`;
- `output_type`;
- `verification_status`;
- `institutional_alignment_status`;
- `executive_profile_refs`;
- `template_ref` opcional;
- `content_blocks`;
- `source_trace_refs`.

#### Output conceitual
- `document_or_message_id`;
- `output_type`;
- `executive_text`;
- `document_sections`;
- `printable`;
- `exportable`;
- `style_profile_version`;
- `release_status`.

### Critérios de consistência da coordenação cognitiva

- nenhum domínio deve ser acionado sem Assignment Pack válido;
- nenhum retorno de domínio deve subir sem Result Package estruturado;
- nenhum caso sensível deve pular verificação;
- nenhum checkpoint executivo deve existir sem estado real correspondente;
- nenhuma redação final deve ignorar verificação e aderência institucional.

### Critérios técnicos de aceite da SPEC-005

Os blocos desta SPEC-005 só devem ser considerados concluídos quando:

1. o Deep Agent Executivo conseguir produzir planos de execução consistentes e rastreáveis;
2. a delegação para Deep Agents de domínio ocorrer com contratos formais;
3. os domínios transversais conseguirem bloquear, liberar ou qualificar conclusões;
4. checkpoints executivos forem gerados como artefatos reais do caso;
5. a Redação Executiva operar como finalizador controlado, e não como redator solto;
6. casos sensíveis respeitarem verificação e eventual human-in-the-loop.

### Critérios funcionais de aceite da SPEC-005

Do ponto de vista do Giuseppe, esta etapa estará pronta quando:
- o sistema parecer coordenar inteligentemente casos complexos;
- o trabalho avançar em etapas compreensíveis;
- as conclusões parecerem mais seguras e mais organizadas;
- documentos e sínteses chegarem com formato executivo adequado;
- o sistema não “se perca” ao combinar concorrência, regulação, fatos internos e redação.

### Próximos blocos previstos para continuidade

- detalhamento dos Deep Agents de domínio primário em nível operacional;
- modelagem interna do domínio Concorrência;
- modelagem interna do domínio Regulação e Normas;
- modelagem interna do domínio Diagnóstico e Planejamento Interno;
- aprofundamento da política de verificação multiestágio.

