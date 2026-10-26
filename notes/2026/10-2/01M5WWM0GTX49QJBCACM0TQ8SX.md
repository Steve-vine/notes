---
id: 01M5WWM0GTX49QJBCACM0TQ8SX
created: 2026-10-26T19:57:24.378945Z
updated: 2026-10-26T19:57:26.752969Z
type: task
title: An answer written by hand for a client is classified for that client — Public, or Sensitive when an NDA is in place — not "Not classified, treated as Internal"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1336
sprint: s4zhkvy
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
## What Steve saw

When he writes an answer himself, with nothing in Compass behind it, the answer shows as "Not classified — treated as Internal, so it won't be shared in a DDQ". It's held back and can't be approved until someone picks a level. Strictly that's correct, but it's backwards: an answer written for a client's questionnaire is written to be given to that client.

## Behaviour

An answer with **no sources** that nobody has classified by hand takes **the highest level this DDQ can be given**. That's the most protective level that still reaches the client.

- **No NDA in place:** Public, the only level that can go out without one.
- **NDA in place:** Sensitive, so the answer can't later be reused from the library for a client without an NDA.
- The level is worked out from the sensitivity rules in Admin, not hard-coded as Public or Sensitive. If an admin changes which levels can be given, this changes with it.
- The answer form shows the level with a short "Written for this client" note instead of "Not classified". The writer can still change it.
- Once someone picks a level by hand, it's fixed as it is today.
- **Answers with sources are unchanged.** They still follow their sources, with an unclassified source counting as Internal. Something Compass already holds keeps its own classification.
- **Approval is still the gate.** An approver still sees and approves every answer before it goes out, so a hand-written answer is never sent without a second look.
- **"From last time" answers** (COM-1292) get the same rule. They repeat what this requester was already told. This replaces COM-1292's "someone must say who it can go to".
- **Recording or removing an NDA** moves an uncommitted answer between Public and Sensitive at once. The level is worked out when the answer is read, never stored, like the rest of the sharing rules.
- **Adding one to the library** carries the level as it stands at that moment.

## Notes for the build

- `core/ddq_answers.effective_rank`: when nothing is chosen and `sources_default` is None, use the DDQ's "for this client" rank.
- That rank is the highest rank on `sharing_scale` whose `ddq_sharing` is `always`, or `nda` when `nda_in_place`. If no level qualifies, it stays None, which keeps today's behaviour.
- Show the reason in the answer payload, for example `classification_basis: "sources" | "chosen" | "for_this_client" | "none"`. The form uses it to say why.
  - This is an API change, so the task joins the chain and needs a regenerated schema.d.ts.
  - No migration is needed.
- The same rule applies everywhere the rank is read: the review cards, Polaris tools, the sent snapshot and add-to-library.
- Sent DDQs keep their snapshot, so nothing already sent changes.
- Existing unclassified, source-less answers on open DDQs become givable at once. That is intended.
- Tests:
  - a source-less answer with and without an NDA;
  - a hand-chosen level is kept;
  - an answer with sources is unchanged;
  - an admin rule change shifts the level;
  - a "from last time" answer.
- Amend ADR 0124 §9 (call 7) with an "Amended by" line, plus a short note in the ADR or a new ADR.