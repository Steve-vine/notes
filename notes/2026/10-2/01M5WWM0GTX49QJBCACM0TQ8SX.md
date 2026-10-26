---
id: 01M5WWM0GTX49QJBCACM0TQ8SX
created: 2026-10-26T19:57:24.378945Z
updated: 2026-10-26T20:11:20.864066Z
type: task
title: Writing an answer by hand, the classification comes filled in with the level this client can receive (from the sensitivity rubric) — saved as the writer's choice, not "Not classified, treated as Internal"
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

## Decided (Steve, 2026-10-26)

A person always makes the call, and the rubric supplies the suggestion. Compass never classifies an answer silently. A classification is a judgement about content (the rubric's definitions describe content), so an answer that ends up in the library labelled Public must carry the name of the person who chose Public.

## Behaviour

- **Writing an answer with no sources:** the classification already shows **the suggested level for this client**. That is the highest level the sensitivity rubric lets this DDQ receive:
  - **no NDA in place:** whatever the rubric says can always be given (Public as shipped);
  - **NDA in place:** whatever the rubric allows with an NDA (Sensitive as shipped).
- The suggestion is labelled "Suggested for this client", and the writer can change it before saving.
- **Saving keeps it as the writer's choice**, recorded under their name exactly as if they had picked it from the list. History shows who classified it.
- **Nothing shifts silently.** Recording or removing an NDA later doesn't change a saved level; the usual sharing check then decides whether it can be given.
  - Example: Sensitive with the NDA withdrawn is held back, as today.
- **If the rubric lets nothing be given to this client**, there is no suggestion, and the answer stays "Not classified" as today.
- **Answers with sources are unchanged.** They still follow their sources, with an unclassified source counting as Internal; there is no pre-fill.
  - If the writer removes the last source, the suggestion appears.
- **"From last time" answers** (COM-1292) get the same pre-fill. They repeat what this requester was already told, and the person still confirms it by saving.
- **Polaris:** when Polaris drafts a source-less answer, its save includes the suggested level. The ask-before-change card shows it ("Classified Public — suggested for this client"), so the person approving the change is the one choosing.
- **Existing answers:** nothing already saved changes. Source-less answers that are still unclassified show the suggestion the next time someone edits them.

## Notes for the build

- **The suggestion:**
  - It's the highest rank on `sharing_scale` whose `ddq_sharing` is `always`, or `nda` when `nda_in_place`; with none, it's None.
  - It's worked out from the rubric at the time it's shown. Nothing is hard-coded to Public or Sensitive.
  - Add it to the question/answer payload as `suggested_classification_rank`, beside the level's name.
  - This is an API change, so the task joins the chain and needs a regenerated schema.d.ts. No migration is needed.
- **`AnswerForm`:**
  - With no sources and no chosen level, pre-fill the classification select with the suggestion, and note "Suggested for this client".
  - The save sends it as a chosen classification (`classification_chosen=True`), so `effective_rank` is unchanged and the save path needs no new rule.
- **The `ddq_save_answer` MCP tool:**
  - When the answer has no sources and no classification is given, it uses the suggestion and says so in its result and its approval summary.
  - Saves outside the MCP tool and the form, with no classification, behave exactly as today.
- **Tests:**
  - the suggestion with and without an NDA;
  - an admin rule change changes the suggestion;
  - a rubric with nothing givable gives no suggestion;
  - the saved level is recorded as chosen by the writer;
  - a later NDA change does not alter it;
  - an answer with sources gets no pre-fill;
  - the Polaris save shows the level on the approval card;
  - the form pre-fills and labels it.
- Amend ADR 0124 §9 (call 7) with an "Amended by" line: a suggested, person-confirmed level for source-less answers.