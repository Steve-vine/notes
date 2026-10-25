---
id: 01M5S9F9E583ZGWN7ACD5JV0Z3
created: 2026-10-25T10:25:03.429119Z
updated: 2026-10-25T12:39:54.350399Z
type: task
title: 'DDQ: "Review answers" — one wide window to approve or reject every answer and pick what goes to the library; "Approve all" and "Add all to library" go'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1300
sprint: ssgnel8
comments:
- id: 01M5SAGF4SN3RA49A49V6XKHBM
  author: Steve Vine
  at: 2026-10-25T10:43:10.617399Z
  text: '**Changed by COM-1303:** cover fields become ordinary questions in a "Cover fields" section, so the separate cover-field rows at the top of the Review answers window aren''t needed. They appear as normal question rows, first, with Approve/Reject and no Add to library. Build whichever lands second to match.'
assignee: steve
priority: high
task_status: active
---
## What Steve said

"I think I need a quicker way to review all the answers rather than clicking on each one. At the same time the 'Approve all..' and 'Add all .. to library' feel a bit like broad blind actions.
- Remove those 2 buttons from the Review section and add a 'Review answers' button. Have this open a new modal (wide style) that list each question like so… Question x / Question text / Guidance / Guidance text / Response / Response text / Drafted by: who drafted it
- Then on the right hand side include the following toggles… [Approve/Reject] [Add to Library]. The Add to library toggle only appears for manually answered questions
- Then at the bottom of the list are buttons to [Save] [Cancel] [Submit]. Save, saves the current responses in case the reviewer need to go away and check something mid review, cancel clears the answers and submit commits the responses and adds to the Q&A library where specified."

## Behaviour

**On the DDQ page:** the Review section loses **Approve all…** and **Add all … to the library**, and gains **Review answers**. The button is shown to anyone who can approve DDQ answers while the questionnaire is In review.

**The Review answers window** is wide (most of the screen) and lists each question awaiting review, in the questionnaire's order. Each row:

- **Left:**
  - **Question x** and the question's wording;
  - **Guidance**: the client's guidance, when there is any;
  - **Response**: the answer as it will go out, with the client's other fields under their labels;
  - **Drafted by:** who drafted it ("Polaris" or a person's name).
  - Also on the left (my call; see below):
    - **Based on:** its sources;
    - **Evidence:** what goes with it;
    - any warning the single-question window would show: held back and why, something cited that can no longer be cited, or "From X — no source in Compass";
    - an **Open** link to the full question window.
- **Right:**
  - **Approve / Reject**: each row starts undecided. Choosing Reject opens a box for the reason, which is required because it's what the person gets back.
  - **Add to library**: shown only for answers a person drafted by hand, and only usable while Approve is chosen.
  - An answer held back from this client, or citing something no longer citable, can't be approved, so only Reject is offered, with the reason shown.

**Cover fields** ("Company Name", "Completed by") are listed first, each with what it says and an Approve toggle. They used to be approved by Approve all.

**At the foot of the window:**

- **Save** keeps the reviewer's choices and reasons so far, and closes the window. Nothing is approved, rejected or added yet. Opening Review answers again, on any device, picks up where they left off.
- **Cancel** discards this reviewer's choices, saved or not, after a "Discard your review choices?" check, and closes the window. **It never changes the answers themselves.**
- **Submit** carries out every choice made:
  - each Approve approves that answer;
  - each Reject sends it back with its reason (to Drafted, with whoever has it, and back on their Actions: COM-1299);
  - each Add to library adds the approved answer to the Q&A library, as Add to library does today.

  Rows left undecided stay In review. Afterwards the window says what happened ("12 approved, 2 sent back, 3 added to the library; 4 still to review").

**Saved choices belong to the reviewer.** If another approver acts on a question first, that question drops out of the list, with a note that someone else has decided it.

## My calls (awaiting Steve)

- **Sources, evidence and warnings are shown on each row**, though the outline didn't include them. Without them, approving from the list would be as blind as Approve all.
- **"Manually answered"** means drafted by a person, not by Polaris or from the library. Answers Polaris drafts from Compass are re-drafted from the same material next time, so they don't need a library entry (COM-1292).
- **Rows start undecided**, not approved, so nothing is approved without a choice.
- **Reject needs a reason.**
- **Polaris's bulk tools go too:** "approve all" and "add all to the library". Polaris keeps approving or adding one question at a time, when the person asks for that question.

## Implementation notes

- **Depends on COM-1299** (In review status and lock) and uses COM-1297's labels.
- **Backend:**
  - a table for a reviewer's saved choices, e.g. `ddq_review_choices` (ddq_id, reviewer_id, question_id or cover_field_id, decision approve/reject, reason, add_to_library, updated_at), unique per (ddq, reviewer, item); migration.
  - Routes:
    - GET the review list (each In review question with wording, guidance, current answer and fields, drafted-by, sources, evidence, sharing verdict, citability, whether it may go to the library) plus the reviewer's saved choices;
    - PUT to save choices;
    - DELETE to discard them;
    - POST to submit.
  - Submit is **one transaction** that reuses `ddq_review` approve and send-back and the existing add-to-library path. It rejects stale rows (a question no longer In review), reports them, and clears the reviewer's saved choices.
- **Remove:** the `approve_all` / `add_all_to_library` routes and buttons, and the assistant tools `ddq_approve_all` and `ddq_add_all_answers_to_library`. Cover-field approval moves into the review submit.
- **Frontend:**
  - new `src/ddq/review/ReviewAnswersModal.tsx` (Modal size ~"90%");
  - rows as cards, with a `SegmentedControl` (Approve / Reject, starting unset) and a `Switch` for the library (`w="fit-content"`, aria-label, per screen conventions);
  - a reason `Textarea` on Reject;
  - a sticky footer with Save / Cancel / Submit.
- **Tests:**
  - Save → reopen → choices restored;
  - Cancel discards choices and leaves the answers alone;
  - Submit approves, sends back with reason and adds to the library;
  - held back → only Reject;
  - Add to library hidden for Polaris drafts;
  - a question decided by someone else drops out;
  - cover fields approved through the window.
- On the chain (migration and API).
