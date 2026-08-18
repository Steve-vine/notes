---
id: 01M0A2N05GN5QKMGHA0W6ZXS8N
created: 2026-08-18T09:18:44.912087Z
updated: 2026-08-18T09:18:44.912087Z
type: task
title: 'Integration cards: Test connection tests the saved config but is enabled before Save'
priority: low
assignee: steve
label: bug
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 245
---
Smoke finding from Sprint 34 (2026-08-18, Entra card, but the M365 card has the identical behaviour it was copied from).

On Admin ▸ Integrations, typing credentials enables **Test connection** (`disabled={!configured && !secret}`) — but the endpoint tests the **saved** row, so testing before clicking Save returns "Entra ID access is not configured — add the dedicated app registration's credentials in Admin → Integrations", which reads as nonsense while the fields are visibly filled in. Steve hit exactly this three times (09:07–09:12) before saving at 09:14, after which the same click passed.

Options, smallest first: (a) keep Test disabled until saved, with a hint "Save first — the test runs against the stored credentials"; (b) have Save-then-test as one affordance; (c) let the test endpoint accept an optional unsaved credential payload. Applies to both the Entra and M365 cards — fix them together.

Refs: `admin/IntegrationsSection.tsx` (EntraForm + M365Form), `api/v1/integrations.py` test endpoints.