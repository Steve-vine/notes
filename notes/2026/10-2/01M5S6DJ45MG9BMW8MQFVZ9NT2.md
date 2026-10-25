---
id: 01M5S6DJ45MG9BMW8MQFVZ9NT2
created: 2026-10-25T09:31:41.061838Z
updated: 2026-10-25T10:47:29.797062Z
type: task
title: 'DDQ: the question window is reorganised to read top to bottom — the question in its own box, then the response, then sharing, with Assignment and History at the bottom'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1297
sprint: ssgnel8
assignee: steve
priority: medium
task_status: active
---
## What Steve asked

"I'd like to make some changes to the Question modal to make it easier to read.
- Move the >Assignments section to the bottom above >History
- Change the title from 'Answer x' to 'Question x' and move this to below the Assignment section
- The question section needs to stand out more, put the whole question section in its own box and make it stand out more from the rest of the modal, the box should contain… Question 4 / [wording] / The client's guidance / [guidance]
- Then the response section should follow, again in a single box: Response / Evidence Included / Sources
- Then the remaining sections: Can this be given / Blah blah…
- Followed by 'Who can this go to?' but renamed as… Evidence override"

Then, after I pointed out that the control sets who the answer can go to and not the evidence: "change it to 'Disclosure override'".

## Behaviour

The question window opened from a DDQ's questions list reads, top to bottom:

1. **The question box.** It stands apart from everything else: a tinted background with a coloured edge, unlike the plain bordered boxes below it. It contains:
   - **"Question 4"** as its heading (the client's reference, or "Question n" where there's none). This replaces "Answer 4" in the window's title bar, which now shows just the close button.
   - the question's wording, in larger text than the rest of the window;
   - the answers the client allows, when they give any ("Choices: Yes, No, N/A");
   - **The client's guidance**, under that label, word for word.
2. **Suggestions from the library**, when there are any, as now.
3. **The response box**, one bordered box containing:
   - **Response**: the answer box, under the client's own label ("Response"), with where it goes in their file. Any short-response choice and the client's other fields sit here too, under their labels.
   - **Evidence included**: what goes out with the answer (renamed from "Evidence to include"). Where the client's file has an evidence-list column, the note that Compass fills it in sits here.
   - **Sources**: what the answer is based on. **Always shown**, rather than tucked behind "Based on something in Compass? Add a source" (this changes COM-1289's collapse, at Steve's request).
4. **Can this be given?** As now: the NDA position, and whether the answer and each piece of evidence can go to this client.
5. **Disclosure override**: the control currently labelled "Who can this go to?", renamed.
   - Its description: "Who this answer can go to, when it isn't what its sources allow. Evidence is checked separately."
   - It's unchanged in what it does and when it's required: with no sources it must be picked, with no default (COM-1289). The error stays "Say who this answer can go to."
   - "Why it is lower than its sources" follows it when needed.
6. The "Drafted by…" line, any error, and **Save**.
7. **Review** (Approve / Send back / Add to library), when it has something to show, as now.
8. **Assignment**: who has the question, with Assign to me / to Polaris / to someone… Moved here from the top.
9. **History**: every earlier version, as now.

A question someone can't change shows the same layout, read-only.

Polaris's tool descriptions and the approver's "From X — no source in Compass" line (COM-1289) use the same name where they refer to this choice.

## My calls (awaiting Steve)

- **The window's title bar** no longer carries a title: "Question 4" heads the question box instead, which is how the mock-up shows it. I read "move this to below the Assignment section" as "below where Assignment used to be", the top of the window.
- **Library suggestions** sit between the question box and the response box. The mock-up didn't place them.
- **The "Last time" lines** from carry-forward aren't placed, because COM-1292 removes them. If this lands first, they sit at the foot of the question box.

## Implementation notes

- `src/ddq/answers/AnswerQuestionModal.tsx`:
  - drop the `title` (keep the close button and an `aria-label` "Question 4" on the Modal for screen readers);
  - move `<AssignmentPanel>` below `<AnswerReview>` and above `<AnswerHistory>`.
- `src/ddq/answers/AnswerForm.tsx`:
  - wrap wording, choices and guidance in a `Paper` with a tinted background and a left accent border, headed "Question n";
  - wrap response, other fields, evidence and sources in one `Paper withBorder`;
  - remove the `showSources` collapse and its "Add a source" button;
  - relabel "Evidence to include" → "Evidence included" and "Who can this go to?" → "Disclosure override", with the description above.
- Check any other screen or tool text that says "Who can this go to?": the review list, the assignee's Actions form and the assistant tool descriptions.
- Check `brief/information-architecture.md` → *Screen conventions* for card and heading styles. Keep the box colours on the fixed palette from sprint 65.
- Update tests that find things by label ("Who can this go to?", "Evidence to include", "Add a source", the "Answer 4" title) and order. Add a test that Assignment renders after the answer form.
- Independent: frontend only, plus the tool description text.
