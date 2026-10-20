---
id: 01M5DAFXXDA0SC0TG7RKZ1FHVX
created: 2026-10-20T18:51:59.78944Z
updated: 2026-10-20T18:52:12.919026Z
type: task
title: Fulfil reads in the order the work is done, and a new Respond step sends the answer and records what was provided
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1178
sprint: ss8348q
blocked_by:
- 01M5DAFG3YR20T97VTBQQ571J8
assignee: steve
label:
- improvement
priority: medium
task_status: todo
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