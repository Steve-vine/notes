---
id: 01M23RFWJFEZ3XJM2N1ZGTEPGA
created: 2026-09-09T18:57:08.687427Z
updated: 2026-09-09T18:58:33.412414Z
type: task
title: Posture over time inception + ADR 0070
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 634
sprint: srtvjyn
assignee: steve
label:
- brief
priority: high
task_status: active
---
Write **ADR 0070 — Posture over time is a daily snapshot, backfilled once from the revisions**, recording the sprint's decisions before any code lands (the ADR 0048 shape: the whole capability decided once, delivered task by task).

**What it is.** A read-only page, **Posture ▸ Timeline**, showing how a company's posture moves — improving, flat, slipping — rather than only where it stands. Six measures, all of which the Dashboard, Coverage and Risk overview already put on screen: overall compliance, compliance by tier, open gaps, maturity, framework compliance, risks. Nothing on the page is a new number; it is the existing numbers with a time axis.

**Decisions to record:**

* **A snapshot, not a replay.** One row per company per day, taken by a nightly Beat task, holding what the Dashboard said that day (`posture_snapshots`, the `membership_coverage_snapshots` precedent from ADR 0061 §7). Replaying `assessment_revisions` on demand was the alternative and is rejected as the *primary* source: the library itself moves (mappings, tiers, out-of-scope rulings, framework versions), so a replay through today's library silently rewrites the past. A snapshot records what was actually said, which is the honest number — and the only one an auditor can be handed.
* **One calculation.** The snapshot is written by the same function the Dashboard, coverage and risk-overview endpoints read, extracted to `core/posture.py`. Two arithmetics would drift; the whole value of the line is that it agrees with the ring.
* **Backfilled once, and labelled.** A one-off, idempotent backfill reconstructs days from the revision tables (assessments, risks) and gap timestamps back to the first revision, so the line has a past on day one. Reconstructed rows carry `source = reconstructed`; observed rows `observed`. A reconstructed day is never overwritten by the backfill and an observed day is never overwritten by anything. The page draws the two regions differently and says so.
* **Not audited, not governed.** A derived measurement, like the sync status singleton: no activity-log row, no revisions of its own, `CASCADE` on company delete.
* **Annotations are events, and events are mostly derived.** Marks on the line explain a jump. Derived at read time from what already exists: a framework adopted (`company_frameworks.created_at`), a framework version superseded (ADR 0058), the maturity rubric edited, the risk appetite changed, and the reconstructed→observed boundary. Authored notes ("Q3 assessment campaign", "external audit") are a small table of their own, in a later task.
* **Charts: adopt `@mantine/charts`.** Compass has one time-series today — the hand-rolled SVG sparkline on Access ▸ Coverage — and no chart library. Six charts with tooltips, reference lines for annotations and a shaded reconstructed region is past what a hand-rolled SVG should carry. `@mantine/charts` (Recharts under Mantine 8's theming) matches the stack and the Appearance palette. Record why not raw Recharts or d3.
* **Read gate**: `require_posture_view`, the same as the Dashboard. No writes on the page.
* **IA amendment**: Timeline joins the Posture section (ADR 0017), recorded as an amendment in the append-only style.

Refs: ADR 0011 (revisions exist for trending), 0015 decision 4, 0023, 0061 §7, 0062 §5 (the "what the answer was in March" argument), 0069.