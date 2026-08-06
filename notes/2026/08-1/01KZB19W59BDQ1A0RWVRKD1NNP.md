---
id: 01KZB19W59BDQ1A0RWVRKD1NNP
created: 2026-08-06T07:58:44.393482Z
updated: 2026-08-06T07:58:44.393482Z
type: task
title: Migrate Freshservice burst config to threshold_specs, retire bespoke surface
label: tech_debt
priority: medium
assignee: steve
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 581
---
Move the ticket-burst tunables (`freshservice_detect.py:46-54, 229-240`: `burst_window_minutes`, `burst_min_tickets`) onto declared `ThresholdSpec`s, and retire the hand-wired per-connector surface they currently require:

- `_FRESHSERVICE_CONFIG_KEYS` + `_require_freshservice` type guard (`systems.py:711-739`)
- the bespoke GET/PUT config endpoints (`systems.py:741-780`) and their Pydantic model (`schemas.py:307-317`)
- `FreshserviceConfigCard.tsx` — replaced by the generic threshold card

Keep the derived ladder exactly as-is (medium at threshold, high at 2× — the `freshservice_detect.py:236-240` stance): the specs declare the two inputs, not four knobs. Same config keys so existing per-System overrides carry over.

Removing API endpoints reddens the OpenAPI snapshot — regen api-types on this branch. Acceptance: burst config is editable via the generic card with identical validation bounds (`ge=5, le=1440` etc.), bespoke endpoints and card gone, detector behaviour unchanged.