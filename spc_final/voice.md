# Coding Pack: Voice (M4)

## Role
Voice como canal principal: push-to-talk → STT → normalização → intent → resolução de conversa → persistência.

## Tables
- `voice_events` (id, conversation_id, audio_path, audio_format, duration_seconds, status)
- `voice_transcripts` (id, voice_event_id FK, raw_transcript, normalized_transcript, quality_score 0-1)
- `intent_events` (id, conversation_id, voice_event_id, primary_intent, entities_json, confidence_score 0-1, requires_confirmation, suggested_title)

## Endpoints
**POST /voice/capture/start** → `{voice_event_id, status: "recording"}`
**POST /voice/capture/stop** → Body: `{voice_event_id}` → `{voice_event_id, audio_path, duration_seconds}`
**POST /voice/process** → Body: `{voice_event_id}` → `{voice_event_id, transcript: {raw, normalized, quality}, intent: {primary, secondary, workspace_candidate, conversation_action, entities, confidence, requires_confirmation, suggested_title}}`
**GET /voice/events/:id** → full voice event with transcript and intent
**POST /intent/resolve-conversation** → Body: `{intent_event_id}` → `{resolved_conversation_id, action_taken, created_new, title_final, workspace_final}`
**POST /voice/confirm** → Body: `{intent_event_id, confirmed_action, confirmed_workspace?, confirmed_title?}` → `{conversation_id, action_taken}`

## Pipeline (6 layers)
1. **Audio Capture:** Electron mediaDevices → WAV 16kHz mono → save to artifacts/audio/
2. **STT:** faster-whisper model=small language=pt → raw_transcript + quality_score
3. **Normalization:** regex cleanup (espaços duplos, pontuação, capitalização) → normalized_transcript
4. **Intent Classification:** Claude Sonnet 4 → JSON (ver system prompt em system-prompts.md)
5. **Conversation Resolution:** busca por title similarity + entities match → create_new | resume_existing | reply_in_current | ask_for_confirmation
6. **Persistence:** salvar voice_event + transcript + intent_event + audit_log

## Intent Categories
`start_planning`, `continue_work`, `retrieve_conversation`, `ask_competitor_question`, `ask_regulatory_question`, `request_document`, `request_summary`, `request_comparison`, `generic_chat`

## Conversation Actions
`create_new`, `resume_existing`, `reply_in_current`, `ask_for_confirmation`, `reject_due_to_low_signal`

## Workspace Selection Rules
- Palavras-chave plano/estratégia/ação → Planejamento
- Palavras-chave concorrência/preço/bolsa/campanha/captação → Captação
- Palavras-chave lei/norma/MEC/portaria/regulação → Normas e Regulação
- Palavras-chave documento/parecer/ofício/despacho/relatório → Documentos
- Ambíguo (2 workspaces com score próximo) → requires_confirmation=true

## Confirmation Policy
Confirmar APENAS quando: 2 workspaces com score próximo (<0.15 diferença), ou 2+ conversas plausíveis para retomada, ou quality_score < 0.6. NÃO confirmar quando: intent clara, correspondência forte com conversa existente, risco baixo.

## Acceptance Criteria
1. ✅ Botão push-to-talk captura áudio e salva WAV
2. ✅ faster-whisper transcreve pt-BR com >80% acerto em 10 frases teste
3. ✅ Normalização limpa espaços e pontuação sem distorcer sentido
4. ✅ Intent classification retorna JSON válido com 9 categorias
5. ✅ Conversa criada por voz com título sugerido
6. ✅ Conversa retomada por voz quando correspondência forte
7. ✅ Confirmação curta APENAS em cenários ambíguos
8. ✅ voice_events, transcripts, intent_events persistidos

## Dependencies
- M1 (Foundation), M2 (Conversations: precisa de workspaces e conversations para resolver)
- M3 (Context Persistence: session_ledger para registrar lifecycle events — pode ser stub inicialmente)
