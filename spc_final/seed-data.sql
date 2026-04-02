-- ============================================================================
-- Seed Data & Test Fixtures V1
-- Executar após migrations para popular dados iniciais e de teste.
-- Dados semi-realistas baseados em IES fictícia em Goiânia.
-- ============================================================================

-- =====================
-- SEED: Workspaces (obrigatório em produção)
-- =====================
INSERT INTO workspaces (id, name, type, display_order) VALUES
  ('ws-planejamento', 'Planejamento', 'planejamento', 1),
  ('ws-captacao', 'Captação', 'captacao', 2),
  ('ws-normas', 'Normas e Regulação', 'normas_regulacao', 3),
  ('ws-documentos', 'Documentos', 'documentos', 4);

-- =====================
-- SEED: System Metadata (obrigatório em produção)
-- =====================
INSERT INTO system_metadata (key, value) VALUES
  ('schema_version', '1'),
  ('app_name', 'Giuseppe Executive Assistant'),
  ('install_date', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'));

-- =====================
-- FIXTURES: Conversations (apenas para testes)
-- =====================
INSERT INTO conversations (id, workspace_id, title, status, origin_mode, objective_summary, course_ref, created_at, updated_at) VALUES
  ('conv-001', 'ws-planejamento', 'Plano de captação — Gastronomia 2026/2', 'active', 'voice', 'Estruturar plano de captação para o curso de Gastronomia no segundo semestre', 'gastronomia', '2026-03-15T10:00:00Z', '2026-03-28T14:30:00Z'),
  ('conv-002', 'ws-captacao', 'Preços de Administração — UniAlfa', 'active', 'voice', 'Comparar preços e bolsas do curso de Administração com UniAlfa', 'administracao', '2026-03-20T09:00:00Z', '2026-03-25T11:00:00Z'),
  ('conv-003', 'ws-normas', 'Impacto da Portaria MEC 2026/15', 'paused', 'manual', 'Analisar impacto da nova portaria sobre reconhecimento de cursos', NULL, '2026-03-22T08:00:00Z', '2026-03-22T16:00:00Z');

-- =====================
-- FIXTURES: Messages
-- =====================
INSERT INTO messages (id, conversation_id, role, message_type, raw_text, message_order, created_at) VALUES
  ('msg-001', 'conv-001', 'user', 'standard', 'Vamos começar o planejamento de captação do curso de Gastronomia para o segundo semestre.', 1, '2026-03-15T10:00:00Z'),
  ('msg-002', 'conv-001', 'assistant', 'ack', 'Entendi. Abri o plano de captação de Gastronomia em Planejamento e já comecei a análise inicial.', 2, '2026-03-15T10:00:05Z'),
  ('msg-003', 'conv-001', 'assistant', 'progress', 'Já recuperei os dados internos do curso. Preço atual: R$ 890/mês. Última campanha: março 2026. Iniciando comparação com concorrentes diretos.', 3, '2026-03-15T10:01:30Z'),
  ('msg-004', 'conv-002', 'user', 'standard', 'Quero saber os preços de Administração da UniAlfa.', 1, '2026-03-20T09:00:00Z'),
  ('msg-005', 'conv-002', 'assistant', 'standard', 'Com base nos dados disponíveis, a UniAlfa cobra R$ 750/mês para Administração presencial, com desconto de 20% na primeira mensalidade. Nossa IES cobra R$ 820/mês sem desconto de entrada.', 2, '2026-03-20T09:01:00Z');

-- =====================
-- FIXTURES: Institutional Facts (semi-realistas)
-- =====================
INSERT INTO institutional_facts (id, fact_key, fact_value, fact_type, valid_from, confidence, source_description, created_at, updated_at) VALUES
  ('fact-001', 'ies.nome', 'Centro Universitário de Goiânia', 'text', '2020-01-01', 'confirmed', 'Estatuto institucional', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
  ('fact-002', 'ies.cnpj', '12.345.678/0001-90', 'text', '2020-01-01', 'confirmed', 'Estatuto institucional', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
  ('fact-003', 'ies.cidade', 'Goiânia', 'text', '2020-01-01', 'confirmed', 'Estatuto institucional', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
  ('fact-004', 'curso.gastronomia.preco_mensal', '890.00', 'number', '2026-01-01', 'confirmed', 'Tabela de preços 2026/1', '2026-01-15T00:00:00Z', '2026-01-15T00:00:00Z'),
  ('fact-005', 'curso.gastronomia.modalidade', 'Presencial', 'text', '2024-01-01', 'confirmed', 'PPC Gastronomia', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
  ('fact-006', 'curso.gastronomia.turnos', 'Noturno', 'text', '2024-01-01', 'confirmed', 'PPC Gastronomia', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
  ('fact-007', 'curso.gastronomia.vagas_semestrais', '60', 'number', '2026-01-01', 'confirmed', 'Edital vestibular 2026/1', '2026-01-15T00:00:00Z', '2026-01-15T00:00:00Z'),
  ('fact-008', 'curso.administracao.preco_mensal', '820.00', 'number', '2026-01-01', 'confirmed', 'Tabela de preços 2026/1', '2026-01-15T00:00:00Z', '2026-01-15T00:00:00Z'),
  ('fact-009', 'curso.administracao.modalidade', 'Presencial e EAD', 'text', '2024-01-01', 'confirmed', 'PPC Administração', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z'),
  ('fact-010', 'curso.psicologia.preco_mensal', '1250.00', 'number', '2026-01-01', 'confirmed', 'Tabela de preços 2026/1', '2026-01-15T00:00:00Z', '2026-01-15T00:00:00Z'),
  ('fact-011', 'curso.psicologia.conceito_mec', '4', 'number', '2023-06-01', 'confirmed', 'Resultado avaliação MEC 2023', '2023-07-01T00:00:00Z', '2023-07-01T00:00:00Z'),
  ('fact-012', 'ies.total_cursos_graduacao', '12', 'number', '2026-01-01', 'confirmed', 'Catálogo institucional 2026', '2026-01-01T00:00:00Z', '2026-01-01T00:00:00Z');

-- =====================
-- FIXTURES: External Sources + Items
-- =====================
INSERT INTO external_sources (id, source_name, source_type, url, reliability) VALUES
  ('src-001', 'UniAlfa Site Institucional', 'competitor_site', 'https://www.unialfa.com.br', 'medium'),
  ('src-002', 'Portal e-MEC', 'official_gov', 'https://emec.mec.gov.br', 'high');

INSERT INTO external_items (id, source_id, item_type, title, content_summary, detected_at, relevance_score, processed) VALUES
  ('ext-001', 'src-001', 'price', 'Administração UniAlfa — Preço 2026/1', 'Mensalidade: R$ 750, com 20% de desconto na primeira parcela. Campanha válida até abril.', '2026-03-20T08:00:00Z', 0.85, 1),
  ('ext-002', 'src-001', 'campaign', 'Campanha Vestibular UniAlfa 2026/2', 'Slogan: Seu futuro começa aqui. Foco em empregabilidade e parcerias empresariais.', '2026-03-18T10:00:00Z', 0.70, 0);

-- =====================
-- FIXTURES: Profile Traits (iniciais fixos)
-- =====================
INSERT INTO profile_traits (id, trait_group, trait_key, trait_value, weight, version) VALUES
  ('trait-001', 'escrita', 'objetividade', 'Prefere textos diretos, sem rodeios. Parágrafo inicial deve conter a conclusão.', 0.9, 1),
  ('trait-002', 'escrita', 'formalidade', 'Tom formal mas não rebuscado. Evitar jargão acadêmico desnecessário.', 0.8, 1),
  ('trait-003', 'tom', 'autoridade', 'Tom de quem decide, não de quem sugere timidamente.', 0.7, 1),
  ('trait-004', 'decisao', 'base_factual', 'Não aceita conclusões sem evidência. Sempre perguntar: qual é a fonte?', 0.9, 1),
  ('trait-005', 'organizacao', 'estrutura', 'Prefere listas de ação com responsável e prazo quando aplicável.', 0.8, 1);

-- =====================
-- VOICE TEST FIXTURES (10 frases para testar STT + intent)
-- =====================
-- Estas frases devem ser gravadas em áudio e usadas como teste de aceitação do pipeline de voz.
-- Salvar em: tests/fixtures/voice/
--
-- 1. "Vamos começar o planejamento de captação do curso de Gastronomia."
--    Expected: intent=start_planning, workspace=planejamento, curso=Gastronomia
--
-- 2. "Quero saber os preços de Administração da UniAlfa."
--    Expected: intent=ask_competitor_question, workspace=captacao, curso=Administração, concorrente=UniAlfa
--
-- 3. "Abra a conversa do plano de Psicologia."
--    Expected: intent=retrieve_conversation, curso=Psicologia
--
-- 4. "Continuar o parecer sobre regulação."
--    Expected: intent=continue_work, workspace=normas_regulacao
--
-- 5. "O que mudou nessa portaria do MEC?"
--    Expected: intent=ask_regulatory_question, workspace=normas_regulacao
--
-- 6. "Prepare um relatório executivo sobre captação."
--    Expected: intent=request_document, workspace=documentos, document_type=relatorio
--
-- 7. "Compare a campanha deles com a nossa."
--    Expected: intent=request_comparison, workspace=captacao
--
-- 8. "Como estamos em captação de Administração frente ao mercado?"
--    Expected: intent=start_planning ou request_comparison, workspace=planejamento
--
-- 9. "Quero acompanhar esse concorrente."
--    Expected: intent=start_planning (monitoring), workspace=captacao
--
-- 10. "Bom dia, tudo bem?"
--     Expected: intent=generic_chat, confidence < 0.5
