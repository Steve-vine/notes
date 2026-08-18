---
id: 01M0A2N05GN5QKMGHA0W6ZXS8N
created: 2026-08-18T09:18:44.912087Z
updated: 2026-08-18T22:27:33.304177Z
type: task
title: 'Integration cards: Test connection tests the saved config but is enabled before Save'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 245
sprint: s5gwx0s
comments:
- id: 01M0BFSB9RZM3KBABTA63KXQ26
  author: Steve Vine
  at: 2026-08-18T22:27:33.304048Z
  text: |-
    Fixed and merged to main (PR #258, CI green).

    Went with option (a), the smallest: Test connection is enabled only when the server reports an active configuration (data.source !== null — so environment-configured deployments keep a working button), with the hint "Save first — Test connection runs against the stored credentials." When the button is enabled but the form holds unsaved edits (typed secret, changed tenant/client id), a second hint variant says the unsaved values are not what the test runs against.

    Applied to the M365 and Entra cards as specified — and to the SSO card too, since it's the same copied form with the identical flaw. Regression tests cover both states.
assignee: steve
label:
- bug
priority: low
task_status: active
---
Smoke finding from Sprint 34 (2026-08-18, Entra card, but the M365 card has the identical behaviour it was copied from).

On Admin ▸ Integrations, typing credentials enables **Test connection** (`disabled={!configured && !secret}`) — but the endpoint tests the **saved** row, so testing before clicking Save returns "Entra ID access is not configured — add the dedicated app registration's credentials in Admin → Integrations", which reads as nonsense while the fields are visibly filled in. Steve hit exactly this three times (09:07–09:12) before saving at 09:14, after which the same click passed.

Options, smallest first: (a) keep Test disabled until saved, with a hint "Save first — the test runs against the stored credentials"; (b) have Save-then-test as one affordance; (c) let the test endpoint accept an optional unsaved credential payload. Applies to both the Entra and M365 cards — fix them together.

Refs: `admin/IntegrationsSection.tsx` (EntraForm + M365Form), `api/v1/integrations.py` test endpoints.