---
id: 01M5WWM0GTX49QJBCACM0TQ8SX
created: 2026-10-26T19:57:24.378945Z
updated: 2026-10-27T08:12:10.211437Z
type: task
title: 'The writer classifies every answer: a required "Sensitivity" choice under the answer they wrote, from the rubric''s levels — no default, nothing worked out behind their back'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1336
sprint: s4zhkvy
comments:
- id: 01M5X73ZJ6C1BNNSHDRR2YTWYW
  author: Steve Vine
  at: 2026-10-26T23:00:53.446001Z
  text: |-
    Done — PR #1356 merged (0d5eb72e).

    What changed for the user:
    - The answer window has a "Sensitivity" choice directly under the answer fields, before Evidence and Sources. It reads "How sensitive is what you've written?" and lists each level with its wording from Admin ▸ Sensitivity.
    - It's required, with no default. Save, or Submit with unsaved changes, says "Say how sensitive this answer is."
    - "Disclosure override" and "What its sources allow" are gone.
    - Under the choice: "Its sources are classified Sensitive". A level lower than that still asks why, and the reason is kept.
    - Using a library answer brings in the entry's approved level, already chosen.
    - Polaris must name a level on every save; it can no longer "follow" the sources. Its window line reads "Saved the answer to A.1 — Public".
    - An older answer that followed its sources keeps its level and "Can this be given?" result until someone next saves it. The form says "Saved following its sources (Sensitive): pick how sensitive it is when you next save it."

    My calls, for you to check:
    1. Cover fields (Company name and the like) start at Public, not empty. That keeps your COM-1303 decision, and it can still be changed. Every other answer starts empty.
    2. The API refuses any save without a level, whatever the client (it uses the API's standard "field required" error). The friendly message is on screen.
    3. Rewording an older follow-the-sources answer needs a level before it saves. Submitting one unchanged doesn't.
    4. Once an answer has its own level, a source reclassified later no longer changes it. That's the same rule a hand-set level always had.

    To smoke-test:
    - Write an answer by hand: the choice is required.
    - Add a Sensitive source and pick Public: you're asked why.
    - Use a library answer: its level is pre-picked.
    - Have Polaris draft one: its window line names the level.

    ADR 0124 is amended (§9, planning call 7).
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
## What Steve saw

When he writes an answer himself, it shows as "Not classified — treated as Internal". That's backwards for an answer written for a client. The classification is also offered in a select labelled **"Disclosure override"**, which lists the same levels as the rubric. So it reads like an override, when it is really the answer's own classification.

## Decided (Steve, 2026-10-26)

**The classification belongs to the answer, and the person writing it decides it at the time of writing.** They write the answer, or the answers when the client has several fields, and then say how sensitive it is.

Letting the code work it out was rejected twice:
- deriving it from the sources;
- pre-filling the level this client can receive.

A classification is a judgement about what the answer says, so a person makes it.

The override, which lets a held-back answer go to this client anyway, is a separate switch: **COM-1337**.

## Behaviour

- **The selector moves:**
  - It sits **directly under the answer fields**: after the short response, the answer and any of the client's other fields, and before Evidence and Sources.
  - It's labelled **"Sensitivity"**, and its help line reads "How sensitive is what you've written?"
  - It lists the rubric's levels by name, each with its wording from Admin ▸ Sensitivity.
- **It's required, with no default.** Saving without a level says "Say how sensitive this answer is." This applies to every answer, with or without sources.
- **"Disclosure override" goes from the form**, and so does "What its sources allow". The answer's level is whatever the writer picked.
- **Sources inform the choice; they don't make it.**
  - Under the selector: "Its sources are classified Sensitive" (the highest of them, an unclassified one counting as Internal).
  - Picking a level **lower than the sources'** still asks why, and the reason is kept in history. This is today's safeguard against an answer quietly giving away more than what it's based on.
- **Using a library answer** brings the entry's approved level in already chosen, because a person decided it when the entry was approved. The writer can change it.
- **"Can this be given?"** stays below and reads from the level chosen. An answer whose level this client can't receive is held back, and **COM-1337**'s switch is how it goes anyway.
- **Polaris must state a level whenever it saves an answer.**
  - The level shows on the answer and in the window's activity line ("Saved the answer to A.1 — Public").
  - Under COM-1340 a save no longer asks first, so the person who checks the level is the approver, who sees it on every answer before approving.
- **Existing answers:**
  - Nothing already saved changes.
  - An older answer that followed its sources keeps showing that level until someone next saves it.
  - At that point the selector starts empty and must be picked.
  - Sent DDQs keep their snapshot.

## Notes for the build

- **API:**
  - The save takes a required `classification_rank`; it returns 422 without one, from any client, the MCP tool included.
  - Every new version is saved with `classification_chosen=True`.
  - `effective_rank` still follows sources for older versions with `classification_chosen=False`.
  - No migration is needed.
  - This is an API change, so the task is on the chain and needs a regenerated schema.d.ts. Run the drift script.
- **`ddq_save_answer` MCP tool:** `classification` becomes required in its input schema, and its result names the level. Check every other path that saves a version:
  - library Use (copies the entry's rank as chosen);
  - "from last time";
  - Polaris drafts;
  - the bulk Review answers flow, if it saves.
- **`AnswerForm.tsx`:**
  - Move the select into the Response paper, after `otherFields` and before "Evidence included".
  - Relabel it, and drop the `FOLLOW` option and the "Disclosure override" label.
  - Keep `lower` and the reason textarea.
  - Replace the `unsaid` check with "no level picked".
- **ADR 0124 §9 (call 7):** add an "Amended by" line saying a person chooses an answer's classification on every save, and sources only advise.
- **Tests:**
  - a save without a level is refused (the API and the MCP tool);
  - a level lower than the sources needs a reason;
  - library Use carries the level;
  - an older answer that followed its sources still reads as before;
  - the form places and requires the selector;
  - the screen-conventions test passes (w="fit-content" where it applies).