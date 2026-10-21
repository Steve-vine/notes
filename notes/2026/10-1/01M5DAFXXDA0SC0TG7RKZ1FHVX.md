---
id: 01M5DAFXXDA0SC0TG7RKZ1FHVX
created: 2026-10-20T18:51:59.78944Z
updated: 2026-10-21T20:16:50.726496Z
type: task
title: Fulfil reads in the order the work is done, and a new Respond step sends the answer and records what was provided
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1178
sprint: ss8348q
blocked_by:
- 01M5DAFG3YR20T97VTBQQ571J8
comments:
- id: 01M5F61S3X5RC2DX6818H6NA5T
  author: Steve Vine
  at: 2026-10-21T12:12:50.685562Z
  text: |-
    Done — PR #1202, merged 21 Oct 13:12 BST.

    - Fulfil now goes in the order the work is done: Systems holding their data, then **Who we've shared it with**, then Erasure record.
      - Who we've shared it with says: "Their answer must say who their data has been given to. These come from the Disclosures log. Check them, then add them to the response."
      - A HIPAA accounting request keeps the title "Accounting of disclosures".
      - What was provided is no longer in Fulfil.
    - A new numbered **Respond** step sits after Tell recipients and before Letters, on every request.
      - It shows the letter Decide calls for: the response, refusal, partly granted or forwarded letter.
      - Until it's written there's a **Write the response** button, which writes it and opens it in the editor. Once written it shows Draft / Gaps to fill / Sent, with View or Edit, Copy, Download and Mark sent.
      - Before every part is decided, it says the answer will be written here once they are.
    - **Mark sent** on the answer asks what was provided for each access or portability part: the description, files and formats, the two portability questions, the form asked for (HIPAA access), and how and when it was delivered. It's all saved in one go: if anything is refused, the letter stays a draft and nothing is recorded. Marking it sent from Letters asks the same.
    - Once sent, Respond shows the letter as sent with what was provided beneath it. **Change** asks "Why it is changing" until the request closes.
    - Older requests that already recorded what was provided keep it, and it shows here. A part missing after the letter went out gets a **Record** button.
    - The closing checklist's "Final letter marked sent" now links to Respond. What the checklist requires is unchanged.

    My calls:
    - Changing what was provided needs a reason everywhere, including from the assistant (it gained an optional reason). The assistant still never marks a letter sent.
    - On screen, every unrecorded part must be filled in before the answer can be marked sent. The server keeps them optional so other callers keep working.
    - Respond uses the same letter row as Letters, so its buttons read View/Edit (not "Open"), and Discard / Correct it appear there too.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve's feedback while smoke-testing sprint 79. Builds on COM-1177, the numbered-section layout.

**What's wrong:** for an access request, Fulfil goes from "Systems holding their data" straight to "What was provided", which is past tense. Nothing in Fulfil actually sends the person anything: the response letter is written under Letters at the bottom of the page, with no link between the two. "Who their data was disclosed to" doesn't explain why it's there.

**What it should do:**

*Fulfil* (one section, per COM-1177), in this order:
1. **Find their data**: Systems holding their data, as now.
2. **Who we've shared it with**: today's "Who their data was disclosed to", renamed, with one line saying why: *"Their answer must say who their data has been given to. These come from the Disclosures log. Check them, then add them to the response."* For a HIPAA accounting request it keeps its own title, "Accounting of disclosures".
3. **Erasure record**, for an erasure, as now.
4. The **What was provided** card is removed from Fulfil (it moves into Respond).

*Respond* (a new numbered step after Tell recipients, before Letters):
- Shows the letter that answers the request: the response, or refusal / partly granted, whichever Decide suggests. If it hasn't been written, there's a **Write the response** button. If it has, its state is shown (Draft, gaps to fill, Sent) with Open / Copy / Download.
- **Mark sent** for this letter also asks, for each access or portability part, **what was provided**: a description, files and formats, machine-readable, sent straight to another organisation (portability), how and when it was delivered, and, for HIPAA access, the form they asked for. So "the response went out" and "this is what went with it" are recorded together, once.
- Once sent, Respond shows the letter as sent with what was provided beneath it, and **Change** on what was provided (with a reason, as corrections are now) until the request closes.
- Every request type gets Respond. Only access and portability ask what was provided.

*Letters* stays as the full list of every letter on the request (acknowledgement, ID, extension, response…).

**Unchanged:** the close checklist still requires the final letter marked sent and what was provided for each access/portability part. Requests that already have "what was provided" recorded keep it, and it shows under Respond. The assistant still never marks a letter sent, so it keeps its own way to record what was provided.

**Done when:** on an access request, a handler can go down the page: find the data, check who it was shared with, write and send the response, and record what was provided in the same step as marking it sent, without going to Letters. The "What was provided" card no longer appears in Fulfil.