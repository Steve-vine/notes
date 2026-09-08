---
id: 01M1YYG4GDSEC1PMA94TVBWY3A
created: 2026-09-07T22:05:56.109817Z
updated: 2026-09-08T20:37:59.878001Z
type: task
title: The Gaps register answers "what do I do first"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 622
sprint: sa2t9sq
comments:
- id: 01M21BVT7YRET9QMYRTCXAG1CK
  author: Steve Vine
  at: 2026-09-08T20:37:59.166097Z
  text: |-
    Done — PR #632 merged to main (d9dbff3).

    What you'll see on the Gaps register:
    - Two new columns after Control: Tier (the same pill as the Controls list) and Control status (where the control itself stands — the pill the assessment queue shows). The trailing column is now labelled Gap status, and its filter is renamed to match.
    - Two new filters beside Gap status: Tier (the Controls list's filter) and Owner, which offers only the people who own a gap in this company plus Unassigned. Owned by me stays; picking an owner unticks it and ticking it clears the owner.
    - Tier sorts Essential → Expected → Specialised (by rank, not spelling); Control status sorts by its lifecycle, as the queue does.

    No backend change — the page reads the same assessments call the queue uses and matches each gap to its assessment by id.

    Tests: 5 new on the register, including the header order and the mutual exclusion of the owner filters. Deploying to staging now with COM-621.
assignee: steve
label:
- improvement
priority: high
task_status: review
---
The Gaps register lists every open shortfall and gives you almost nothing to rank them by. It shows the control's reference, the gap's title, its owner, its target date and its own status — so the only way to decide what matters is to recognise the control refs by eye, or open them one at a time.

Three additions, all of them things the app already knows and simply does not show here.

## What a reader sees

The table becomes:

| Control | Tier | Control status | Title | Owner | Target date | Gap status |
|---|---|---|---|---|---|---|

- **Tier** — Essential, Expected or Specialised (ADR 0069), as the pill the Controls list already uses. An Essential control falling short is not the same news as a Specialised one, and this is the column that says so at a glance.
- **Control status** — where the control itself stands: not implemented, partial, implemented. A gap against a control still at *not implemented* is a different job from one against a control that is *partial* and nearly there.
- The trailing status column is renamed **Gap status**. Two columns saying "Status" in one table is a question the reader should not have to answer, and the control's status is the newcomer, so both get named.

## Filters

Beside the existing Gap status filter:

- **Tier** — the same `TierFilterSelect` the Controls list uses. One component, so the words never disagree.
- **Owner** — who the gap belongs to. The list holds the people who actually own a gap in this company, not every user in the directory; a filter offering names with nothing behind them is noise. It also offers **Unassigned**, which is its own useful question.

The existing **Owned by me** switch stays — it is one click for the commonest case, and Actions has the same switch, so removing it here would split the pattern. The two are made mutually exclusive: choosing an owner clears the switch, ticking the switch clears the owner. They must never be able to state two different answers at once.

## No backend work

- Tier is on `CoreControl` and already comes back from `/api/v1/controls`, which this page loads and maps by id.
- Control status is on the assessment. The page adds `/api/v1/assessments?company=` — the same call the assessment queue makes, so React Query serves it from cache on the way between the two screens — and maps it by **assessment id**, which every gap row already carries. Map by the assessment, not the control: the gap names its parent directly and the lookup cannot pick the wrong company's row.
- All filtering on this screen is already client-side over the whole loaded list. Tier and owner join it. Nothing new is asked of the API.

## Where

`pages/GapsPage.tsx` only. `TierBadge`, `TierFilterSelect` and `TIER_OPTIONS` come from `library/components.tsx` / `library/tiers.ts`; the control status renders through the existing `StatusPill`, exactly as the assessment queue renders it.

## Note on ordering with the sort sweep

*Posture lists sort* adds column sorting to this table. Whichever of the two lands second owns making the new columns sortable — **Tier** by rank (Essential → Specialised, never alphabetically, which would read Essential, Expected, Specialised by luck and break the moment a tier is renamed) and **Control status** by its lifecycle rank. Say so in that PR rather than leaving it to be noticed.

Tests: the tier and control-status columns render for a gap; the tier filter narrows the list; the owner filter narrows it and offers Unassigned; picking an owner clears "Owned by me" and vice versa; the two status columns are distinguishable by their headers.
