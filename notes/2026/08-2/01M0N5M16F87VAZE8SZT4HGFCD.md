---
id: 01M0N5M16F87VAZE8SZT4HGFCD
created: 2026-08-22T16:42:17.679484Z
updated: 2026-08-23T06:54:07.72773Z
type: task
title: One Start button for the batch — all pending assessments open together, one link sent
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 365
sprint: sbph5q5
comments:
- id: 01M0NBA3KYV8YPD7QS88S8Y0XX
  author: Steve Vine
  at: 2026-08-22T18:21:43.934429Z
  text: |-
    Done — PR #367, merged to main.

    - Per-row Start buttons gone; **one `Start N assessments…` button** on the Assessments tab, enabled while anything is `pending`. Complete stays on the row — filling an assessment in on the supplier's behalf genuinely is about that one assessment.
    - New vendor-scoped `POST /vendors/{id}/assessments/start` taking `assessment_ids` + one `valid_until` + `contact_ids`. The batch opens in **one transaction**; a rejected member takes the whole send down, since they were asked for as one thing and half a batch must not go live.
    - Tokens minted once per contact (the link was already vendor-scoped, which is why the old per-assessment emails all carried the same URL). **One email per contact naming the whole batch**, one owner notice listing it — both tasks now take `assessment_ids: list[str]`.
    - **Open question answered as recommended: per-assessment checkboxes, ticked by default.** They cost nothing because the modal has to list the batch anyway, and they make the "hold this year's PCI pack back" case representable.
    - Untouched, as specified: per-assessment % complete, Close, expiry — and each assessment keeps its **own activity-log line**, because "when was this one sent, and to whom" is asked of a single assessment long after the batch is forgotten. A later addition sits `pending`, the button reappears, and it starts on its own date; nothing assumes a batch expires together.
    - Tests: batch opens on one shared date with one email per contact naming both and one live token each; owner hears once; a partial send leaves the unticked one pending; a later addition keeps the already-open deadline intact and regenerates rather than duplicates the token; an already-open member 409s the whole batch with no emails sent; a duplicated id is one assessment; an empty list is 422. Frontend: default-ticked and POSTed together, untick holds one back, all-unticked disables Start, no button when nothing is pending.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
COM-358 shipped Start as a per-assessment action, so a vendor with several assigned assessments means several modals and several emails to the same contacts. Change it: **one Start button** on the vendor's Assessments tab that opens **all pending assessments together** and sends **a single link** to complete them.

- [ ] The per-row Start buttons go; a single **Start Assessments** button (tab-level) is enabled while the vendor has ≥1 `pending` assessment. The modal is unchanged in shape — compliance contacts ticked by default, one **valid until** (default +2 weeks) — but it lists the assessments it is about to open, and the chosen date applies to **all of them** (they were sent as one ask; they expire as one).
- [ ] On Start: every pending assessment goes `pending → open` with the shared `valid_until`, in one transaction; per-contact tokens (re)generated once as today. The access model already makes the single link natural — one portal destination per vendor — so the contact email becomes **one email, one link, listing the assessments** to complete; the owner email likewise lists the batch.
- [ ] Later additions: an assessment assigned *after* a batch is already open sits `pending` and the Start button reappears for it — starting it re-uses the modal (its own valid-until this time), regenerates the ticked contacts' tokens per the existing rule, and the email says what's newly asked; the portal simply shows the newly opened one alongside the rest.
- [ ] Per-assessment machinery is untouched: individual % complete, individual Close (COM-359), individual expiry handling — only *starting* is batched. Since the batch shares one date they will normally expire together, but the invariants must not assume it.
- [ ] Decide in review: is "start all pending" always right, or does the modal want per-assessment checkboxes (ticked by default) for the rare partial send? Cheap to add while the modal lists them anyway — recommend the checkboxes.
- [ ] Tests: batch start opens all pending with one shared date, one email per contact naming every assessment, one owner email; a later single start leaves open ones untouched; tokens regenerated not duplicated; zero-pending hides/disables the button.