---
id: 01KZVC8BSQBE4B3533Y5CMW0H0
created: 2026-08-12T16:18:00.119132Z
updated: 2026-08-13T19:00:18.281948Z
type: task
title: 'ADR: a dashboard tile points at any estate roll-up, and dependencies colour it'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 671
sprint: sdshnf8
comments:
- id: 01KZVCWBQCBXAG8T43RJ6GZ9HF
  author: Steve Vine
  at: 2026-08-12T16:28:55.404259Z
  text: |-
    Done — PR #622 merged to main as 5954d98.

    ADR 0099 "A dashboard tile points at any estate roll-up, and what it rests on colours it" (0099 was free on main and no other branch had claimed it). It amends ADR 0053 §§1-3 and records four things:

    1. A service points at SOURCES — group, business-application or business-service. Nearly free structurally: all three are Entity rows and the join was always an FK to entity.id. No source_type column — entity.type is the answer and a copy would drift.
    2. Derived dependencies colour the tile exactly like members, one evaluated set under the unchanged rule language. All three alternatives are recorded with their reasons for rejection (members-only = green through a dead database; amber cap = teaches the team amber means outage; per-tile opt-out = two tiles for one BA disagreeing). The consequence is stated plainly rather than tuned away: one failing shared cluster reddens every tile above it.
    3. A Business Service evaluates entities, not its children's colours — otherwise it and its BAs could disagree about one failure, and asset_count would have no assets to count.
    4. unknown must say which emptiness it is; the current single reason is a lie for three of the four cases.

    Also written: the index row (0053 marked "amended by 0099"), ui-brief §10 (a Sources bullet, a Service drill-in bullet describing the Members / Depends on split, and the specific greys), and the ISE Canon memo's Dashboards section.

    One thing worth noting for the build: the ADR deliberately does NOT decide dependency depth as an operator setting. If tiles ever need a different depth from the blast-radius page, that is evidence the derivation is wrong, not that the tile needs a knob.

    Docs only — no code, no schema, no screen, so the code CI jobs correctly path-filtered to skipping.
assignee: steve
label:
- brief
priority: medium
task_status: done
tech: null
---
Record the decision before the code. Amends **ADR 0053 §§1-3** (an amendment block is not enough here — §1 defines what a service *is*, and this changes it, plus it adds a rule ADR 0053 never had).

**Check `origin/main` for the next free ADR number before writing** — parallel sessions take them (0098 is the last known).

What the ADR must decide and record:

1. **A dashboard service points at estate roll-ups, not only groups.** The three accepted kinds are `group`, `business-application` and `business-service`. All three are already `Entity` rows and `dashboard_service_group.group_entity_id` is already an FK to `entity.id`, so this widens a type check, not a schema. The service stays a *curated view*, deliberately not an entity (ADR 0053 §1 stands).
2. **Inferred dependencies count towards colour, exactly like members.** A Business Application's dependencies are derived, never stated (ADR 0096 §5) — walked downstream over `runs-on` / `depends-on` / containment `part-of` from whatever membership resolves to now. Members + dependencies are ONE evaluated set feeding one unchanged rule language.
   - Record **why the alternatives were rejected**: colour from members only would let a tile read green while the only database beneath it was dead — the exact failure ADR 0053 §3 exists to prevent; a per-tile opt-out lets two tiles for the same Business Application disagree; capping a dependency at amber makes a dead database amber.
   - Record the **consequence plainly**: one failing shared cluster reddens every tile above it. That is accepted and arguably the point — but it means an `asset_count` rule ("≥2 assets critical") is easier to trip than it was over a group, and the tile's `detail` must keep saying which condition tripped.
3. **A Business Service's evaluated set is the union of its Business Applications' members and their dependencies** — entities re-evaluated, not computed levels rolled up. Reason: a Business Service and its Business Applications can never then disagree about the same failure, and the `asset_count` rule shape still has assets to count.
4. **`unknown` must say which emptiness it is.** ADR 0053 §3 keeps its rule (zero members is grey, never green), but the single hard-coded reason "check the service's groups" is now a lie for three of the four cases. Enumerate the reasons.
5. Note what is **not** changing: dependency derivation itself (ADR 0096 §5, and its deferred capture gaps — AWS SG ingress, k8s `ExternalName`, RDS replica source), the latch/auto-clear model, the public-token posture, board membership.

**Also in this task** (the decision is not recorded until these are):
- `docs/briefs/ui-brief.md` §10 — Dashboards: sources rather than groups, and the two-section expanded view.
- The **ISE Canon** Notuvia memo, §Dashboards.

No code, no screen. Docs only.