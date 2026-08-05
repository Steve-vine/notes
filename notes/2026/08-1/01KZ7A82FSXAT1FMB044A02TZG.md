---
id: 01KZ7A82FSXAT1FMB044A02TZG
created: 2026-08-04T21:18:04.793974Z
updated: 2026-08-05T14:25:09.943181Z
type: task
title: 'acs-voice channel: PSTN call with TTS + press-1 acknowledge'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 548
sprint: s4ncy73
blocked_by:
- 01KZ7A7V2EQJNZ9M3EJE9NXGJB
assignee: steve
label: null
priority: medium
task_status: backlog
---
ADR 0079 §1/§3/§4/§5. The `acs-voice` poster: place an outbound PSTN call via `azure-communication-callautomation`, speak the incident from a speech renderer over the frozen payload snapshot (TTS `TextSource`, linked Azure AI Speech), recognise DTMF press-1 as acknowledgement.

Callback endpoint: public route for ACS call events with per-call callback-token validation (mounted like the enumerated public exceptions). Delivery row records outcome: no-answer / busy / answered / **acknowledged** — answered is NOT acknowledged (voicemail answers calls).

Screen: Settings channels card supports the voice kind + test call; delivery log shows call outcomes.