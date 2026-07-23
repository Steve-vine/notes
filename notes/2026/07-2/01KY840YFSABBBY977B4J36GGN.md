---
id: 01KY840YFSABBBY977B4J36GGN
created: 2026-07-23T18:32:52.473867Z
updated: 2026-07-23T19:46:00.018122Z
type: task
title: Estate graph direction filter; drop duplicate impact graph from entity page
project: 01KX671DATY39VW6GWK3M2T3DN
number: 233
sprint: s5khymf
assignee: steve
priority: medium
task_status: active
---
The Entity detail page renders two React Flow canvases with heavily overlapping content: the Impact preview's inline graph (`ImpactPanel.tsx` → `ImpactGraph`, upstream-only, fixed depth 3, ISE-226) and the estate graph explorer below it (`EstateGraphPanel.tsx`, `direction: 'both'`, depth slider/filters/re-root/popout). The impact graph's only non-duplicated content is the untangled upstream slice — the dependents *list* above it already communicates the blast radius.

Scope (option 2 of the review):

- Add an **upstream / downstream / both** direction filter to the estate graph explorer (`EstateGraphPanel`), persisted like depth (ISE-156 pattern), passed through to `/api/v1/entities/{id}/graph`. One canvas; the blast-radius view becomes dial-in-able anywhere the explorer appears (entity page + popout).
- Remove `ImpactGraph` from the entity page's Impact preview — the panel keeps groups/tags headline, dependents list, unconfirmed callout and summary. The incident page's compact "Show impact graph" variant stays untouched.
- Preserve the unconfirmed-proposal affordance: impact-graph node clicks routed `ai_proposed` nodes to the proposal queue; the explorer's click re-roots (ISE-232). Ensure dashed proposal nodes in the explorer still offer a path to `/proposals` (e.g. via node action/context), not just re-rooting.

Done when: entity page has a single graph canvas whose direction can be set to upstream-only, and unconfirmed proposals remain reachable for review from it.