# Glossário Canônico V1

**Status:** FROZEN V1 — Qualquer termo novo ou renomeação exige change log.

| Termo canônico | Definição | NÃO usar (sinônimos proibidos) |
|---|---|---|
| **workspace** | Uma das 4 guias de trabalho do MVP (Planejamento, Captação, Normas e Regulação, Documentos). Tabela `workspaces`. | guia, tab, departamento, aba |
| **conversation** | Unidade primária de trabalho. Pertence a 1 workspace, tem título obrigatório. Tabela `conversations`. | chat, sessão, caso, thread |
| **message** | Entrada textual dentro de uma conversation. Pode ser standard ou incremental (ack, progress, checkpoint). Tabela `messages`. | resposta, turno, entry |
| **attachment** | Arquivo vinculado a uma conversation. Tabela `attachments`. | anexo, upload, arquivo (usar 'attachment' no código, 'anexo' na UI) |
| **workflow** | Trabalho estruturado multi-etapas criado a partir de voz ou sistema. 6 tipos. Tabela `workflows`. | fluxo, processo, job, task (task é sub-unidade) |
| **workflow_task** | Sub-unidade de trabalho dentro de um workflow. Tabela `workflow_tasks`. | tarefa, step, etapa (usar 'task' no código) |
| **workflow_seed** | Embrião lógico de um workflow: objetivo, escopo, entidades, incerteza. Tabela `workflow_seeds`. | brief, resumo inicial |
| **session_ledger** | Objeto de estado operacional de uma sessão/trabalho ativo. NÃO é transcrição. Tabela `session_ledgers`. | log, histórico, estado (usar 'ledger' sempre) |
| **compact_summary** | Resumo compactado do ledger em marco lógico. Armazenado em `compaction_events.compact_summary_json`. | snapshot (ambíguo), resumo |
| **resume_bundle** | Pacote para retomada: último ledger + compact summary + fatos + memória macro. Armazenado em `context_packs` com type='resume'. | pacote de retomada |
| **voice_event** | Evento atômico de captura de áudio por push-to-talk. Tabela `voice_events`. | gravação, áudio |
| **transcript** | Resultado de STT sobre um voice_event. Tabela `voice_transcripts`. | transcrição |
| **intent_event** | Interpretação semântica de um transcript. Tabela `intent_events`. | intenção, classificação |
| **voice_execution_envelope** | Pacote de saída da camada de voz entregue ao Orchestrator. Tabela `voice_execution_envelopes`. | envelope (quando no contexto de voz, ok usar curto) |
| **orchestrator_decision** | Decisão do Agent Orchestrator sobre como tratar uma solicitação. Tabela `orchestrator_decisions`. | — |
| **executive_routing_pack** | Pacote enviado ao Deep Agent Executivo Roteador. Tabela `executive_routing_packs`. | routing pack, ERP (conflita com Enterprise Resource Planning) |
| **execution_routing_plan** | Plano cognitivo devolvido pelo Deep Agent Executivo. Tabela `execution_routing_plans`. | plano, routing plan |
| **domain_assignment** | Delegação formal do Executivo para um domínio. Tabela `domain_assignments`. | assignment, tarefa de domínio |
| **domain_result** | Retorno estruturado de um domínio. Tabela `domain_results`. | resultado, achados |
| **executive_checkpoint** | Artefato de progresso visível ao usuário. 5 tipos: initial, analytical, verification, draft, final. Tabela `executive_checkpoints`. | checkpoint (quando no contexto de progresso executivo, ok usar curto) |
| **verification_artifact** | Resultado de um estágio de verificação. 5 estágios. Tabela `verification_artifacts`. | verificação (ambíguo — pode ser o processo ou o artefato) |
| **verification_stage** | Estágio do pipeline de verificação: intake, domain_output, cross_domain, pre_writing, final_release. | fase de verificação |
| **verification_status** | Selo de um estágio: green, yellow, red. | cor, semáforo |
| **institutional_fact** | Fato canônico versionado sobre a IES. Tabela `institutional_facts`. | dado, informação (muito genérico) |
| **source_document** | Documento-fonte de fatos institucionais. Tabela `source_documents`. | documento (ambíguo — pode ser output documental) |
| **canonical_view** | View derivada de fatos (ficha institucional, ficha de curso). Tabela `canonical_views`. | visão, ficha |
| **profile_trait** | Traço do perfil executivo do Giuseppe. Tabela `profile_traits`. | preferência, configuração de estilo |
| **monitoring_thread** | Trilha de monitoramento contínuo de um tema. Tabela `monitoring_threads`. | monitor, radar (radar é tipo de thread, não sinônimo) |
| **writing_request** | Pedido formal de redação executiva. Tabela `writing_requests`. | pedido de documento |
| **writing_output** | Saída da redação executiva. Tabela `writing_outputs`. | documento gerado |
| **document** | Documento institucional finalizado (despacho, ofício, parecer, etc.). Tabela `documents`. | — |
| **document_version** | Versão de um documento. Tabela `document_versions`. | revisão |
| **coding_pack** | Arquivo de contexto segmentado para agente de codificação. Em `docs/coding-packs/`. | pack, contexto |
| **HITL** | Human-in-the-loop. Ponto de aprovação humana obrigatória. | revisão humana (ok na UI, não no código) |
| **quality_state** | Estado de qualidade auto-declarado por um domínio sobre seu retorno (ex: `broad_signal_only`, `impact_mapped`). | — |
| **Deep Agent** | Agent coordenador com subagents, skills e workflow. No MVP: implementado como 1 função LLM, não árvore de agents. | agente, agent (sem "Deep" = ambíguo) |
| **stub** | Componente que existe como interface/contrato mas retorna placeholder no MVP. | mock (mock é para teste; stub é para MVP) |
