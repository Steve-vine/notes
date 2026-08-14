---
id: 01KZZQFBPMS3CXQWWNYT9YZ0BZ
created: 2026-08-14T08:51:01.460147Z
updated: 2026-08-14T09:03:46.482153Z
type: task
title: History and Playbooks are one box pretending to be two — split them
project: 01KX671DATY39VW6GWK3M2T3DN
number: 701
sprint: sevhjex
comments:
- id: 01KZZR6PSJT1ADV3RS9129Z16W
  author: Steve Vine
  at: 2026-08-14T09:03:46.48201Z
  text: |-
    DECIDED 2026-08-14 — the manual-incident question is settled: ALWAYS SHOW BOTH.

    Steve: "Keep the boxes on screen when there's no data, I want it to be implicitly implied that there isn't any data." So History and Playbooks each render on every incident, including a hand-raised one where `RecallPanel` currently returns null outright (`!data.signature`) and neither can ever match. Two empty boxes is the intended outcome — their presence says the answer is nothing, rather than leaving the operator to wonder whether ISE looked.

    That removes the `return null` on a missing signature entirely: the sections render, each showing its own "(No data)" line.

    COLOURS — the two halves cannot both stay blue. One section, one unique colour (ISE-699 owns the allocation across all five); History and Playbooks each need their own, and blue can only go to one of them.
assignee: steve
label:
- improvement
priority: medium
task_status: backlog
tech: null
---
`RecallPanel` (`IssueDetailPage.tsx:1790`) is a single blue card answering two unrelated questions, and its title tells you which one it thinks it is:

```
{data.prior_count > 0
  ? `Seen ${data.prior_count} time${…} before`
  : 'ISE has a playbook for this'}
```

So with priors it is titled as history and lists playbooks inside anyway; with no priors it is titled as playbooks. The card's own code comment already calls it "dual-purpose". An operator cannot collapse one without losing the other, cannot tell at a glance whether a playbook exists when priors are present, and gets a heading whose meaning depends on data it has not read yet.

**Wanted:** two sections. **History** lists previous incidents. **Playbooks** lists matching playbooks. Each with its own fixed title, its own collapse, and its own "(No data)" line.

**Scope**
- Split the render into two sections, both adopting the ISE-699 shell.
- One `/recall` query still serves both — do not fetch twice. Split the presentation, not the request.
- **`DismissedPlaybooks` goes with Playbooks**, not History. ISE-688 put dismissed suggestions behind a "show" affordance with a Restore (reversibility was chosen over an undo toast because the failure it guards against — a card that quietly stops suggesting anything — shows up weeks later). Preserve that; it belongs to the Playbooks half.
- The "No prior history — this incident is new to ISE" line is History's empty state, and it currently renders only when *both* halves are empty (`prior_count === 0 && playbooks.length === 0`). Once split, each section owns its own empty state independently: history can be empty while playbooks match, and vice versa.
- Keep `TierBadge` with whichever section it describes — check which of the two it actually qualifies before moving it.

**Decide: what happens on a manual incident.** `RecallPanel` returns null when `!data.signature` — no signal means no signature, so neither history nor playbook matching can ever produce anything, not merely nothing today. ISE-699 asks for all sections on all incidents; two permanently-empty boxes on every hand-raised incident may be worse than omitting them. Same decision as flagged in ISE-699 — resolve it once, apply it to both.

Depends on ISE-699 for the shell. Sibling: ISE-700.