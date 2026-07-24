---
id: 01KY840YFSABBBY977B4J36GGN
created: 2026-07-23T18:32:52.473867Z
updated: 2026-07-24T14:43:09.775046Z
type: task
title: Estate graph direction filter; drop duplicate impact graph from entity page
project: 01KX671DATY39VW6GWK3M2T3DN
number: 233
sprint: s5khymf
comments:
- id: 01KY88DKQDJN6T8Z6ZXT65JX42
  author: Steve Vine
  at: 2026-07-23T19:49:41.741808Z
  text: |-
    Done on feature/ise-233-graph-direction-filter (PR #215).

    - Added an upstream/downstream/both direction control to the estate graph explorer (EstateGraphPanel), persisted like depth (ISE-156) and passed through to /api/v1/entities/{id}/graph. One canvas; blast-radius view now dial-in-able on the entity page + popout.
    - Removed the duplicate upstream-only ImpactGraph from the entity page's Impact preview. The panel keeps its groups/tags headline, dependents list, unconfirmed callout and summary. The incident page's compact "Show impact graph" bridge is untouched.
    - Preserved the proposal affordance: when the explorer holds an unconfirmed proposal, it shows a standing link to /proposals, so dashed nodes stay reviewable even though a click re-roots (ISE-232).

    Frontend-only, no API change. Updated the ImpactPanel test that asserted the full-variant inline graph (now asserts the canvas is gone from the entity preview). Full frontend suite (366 tests) green; build + lint clean.
assignee: steve
label: null
priority: medium
task_status: done
---
The Entity detail page renders two React Flow canvases with heavily overlapping content: the Impact preview's inline graph (`ImpactPanel.tsx` → `ImpactGraph`, upstream-only, fixed depth 3, ISE-226) and the estate graph explorer below it (`EstateGraphPanel.tsx`, `direction: 'both'`, depth slider/filters/re-root/popout). The impact graph's only non-duplicated content is the untangled upstream slice — the dependents *list* above it already communicates the blast radius.

Scope (option 2 of the review):

- Add an **upstream / downstream / both** direction filter to the estate graph explorer (`EstateGraphPanel`), persisted like depth (ISE-156 pattern), passed through to `/api/v1/entities/{id}/graph`. One canvas; the blast-radius view becomes dial-in-able anywhere the explorer appears (entity page + popout).
- Remove `ImpactGraph` from the entity page's Impact preview — the panel keeps groups/tags headline, dependents list, unconfirmed callout and summary. The incident page's compact "Show impact graph" variant stays untouched.
- Preserve the unconfirmed-proposal affordance: impact-graph node clicks routed `ai_proposed` nodes to the proposal queue; the explorer's click re-roots (ISE-232). Ensure dashed proposal nodes in the explorer still offer a path to `/proposals` (e.g. via node action/context), not just re-rooting.

Done when: entity page has a single graph canvas whose direction can be set to upstream-only, and unconfirmed proposals remain reachable for review from it.