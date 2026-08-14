---
id: 01KZZQFBPMS3CXQWWNYT9YZ0BZ
created: 2026-08-14T08:51:01.460147Z
updated: 2026-08-14T12:53:17.370747Z
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
- id: 01KZZVC5XJGT20E56A9ZVXQMJS
  author: Steve Vine
  at: 2026-08-14T09:59:11.538534Z
  text: |-
    BUILT + MERGED 2026-08-14 — PR #650 (squashed to main as 3ac2cce), CI green.

    SPLIT. `RecallPanel` is gone. `HistorySection` (blue) lists previous incidents; `PlaybooksSection` (teal) lists what matches. Each has a fixed title, its own collapse and its own empty state, both on the ISE-699 shell.

    ONE REQUEST STILL SERVES BOTH — `useRecall(issueId)` shares the query key, so React Query hands the same `/recall` response to both sections. The split is in the presentation, exactly as scoped.

    EMPTY STATES ARE NOW INDEPENDENT. The old `prior_count === 0 && playbooks.length === 0` test could not express "no history, but there IS a playbook" — the sections now say it. Collapsed lines: History → "seen N times before" / "No data"; Playbooks → "1 playbook matches" / "N playbooks match" / "none matching · N put away".

    THE MANUAL-INCIDENT DECISION, applied: `RecallPanel`'s `return null` on a missing signature is gone entirely. Both sections render on a hand-raised incident, each showing "No data" collapsed and its own sentence when expanded ("No prior history — this incident is new to ISE" / "No playbook matches this incident"). There is a test for that shape.

    `DismissedPlaybooks` went with Playbooks, as scoped. ISE-688's Restore stays reachable even when nothing else matches — the section is non-empty whenever anything was put away, which is what stops a durable suppression becoming an invisible one.

    TIERBADGE — you asked which of the two it qualifies. Neither, and the check found why: `compute_tier(prior_count, playbooks)` reads BOTH — `rubber-stamp` from a proven playbook, `familiar` from history OR playbooks, `novel` from neither. Left in History it would sit beside "No prior history" reading "proven — rubber-stamp", which contradicts itself; moved to Playbooks it would vanish on a familiar incident that has no playbook. It is a judgement about the INCIDENT, so it now renders in the page header beside the incident's other identity badges (`IncidentTierBadge`, same shared query — no extra request). Say the word if you would rather it sat in one of the two boxes.
assignee: steve
label:
- improvement
priority: medium
task_status: done
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