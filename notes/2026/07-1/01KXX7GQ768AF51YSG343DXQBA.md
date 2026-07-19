---
id: 01KXX7GQ768AF51YSG343DXQBA
created: 2026-07-19T13:02:16.294603536Z
updated: 2026-07-19T13:22:57.053703451Z
type: task
title: 'ADR: Incident Loop — memory, playbooks & signatures'
label:
- brief
priority: high
task_status: backlog
assignee: steve
project: 01KX671DATY39VW6GWK3M2T3DN
number: 133
imported_from: Obsidian
sprint: sdv8hgy
---
**Sprint 13 foundation.** Codify the Canon's Incident Loop learning layer as ADR 0029.

- **Recall / Update bookends** around the existing propose→approve→execute loop (ADR 0024): Recall retrieves prior memory + playbooks at the front; Update writes back what was learned at the back.
- **Two-signature model**: a coarse **trigger** signature (computed at Recall from signal identity + affected entity, for retrieval) and a precise **diagnostic** signature (computed after Investigate from the cause found, for learning). Many-to-many; built from **stable attributes only** (the ISE-44 fingerprint lesson); hung off the entity graph.
- **Playbook six-part anatomy**: applicability signature, ranked hypotheses, investigation plan (intents), remediation options (each referencing an existing `ActionSpec`), validation criteria, efficacy/provenance.
- **"Judgment, not privilege"**: playbooks reference only the existing action catalogue — no new execution capability, governance unchanged (ADR 0017/0021 untouched).
- **Self-tiering** + efficacy tracking (anti-rot): cost per incident falls as memory grows; a strong match short-circuits toward a rubber-stamp.

*No screen (ADR — the one allowed no-UI task in the sprint).*