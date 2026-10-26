---
id: 01M5WZNABFB1VDDA3YXWMNTYDQ
created: 2026-10-26T20:50:32.943988Z
updated: 2026-10-26T23:00:55.813714Z
type: task
title: Polaris asks only before sending to clients, anything destructive, or a sign-off — extracting questions, drafting answers and assigning just happen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1340
sprint: s4zhkvy
assignee: steve
label:
- improvement
priority: high
task_status: active
---
## What Steve saw

The permission requests are too aggressive. Polaris asks before extracting questions, before answering every question and before assigning every question. It should ask only when sending data to clients or doing something destructive.

## Decided (Steve, 2026-10-26)

This reverses sprint 88's "ask before each change" (COM-1330, ADR 0127).

**Polaris asks first only for:**
1. **Anything that goes outside the organisation:**
   - sending a DDQ through the trust centre, or marking it sent;
   - emailing a trust centre update, posting one, inviting a visitor, resending a link or extending a visitor's access;
   - sending vendor questionnaires;
   - anything else that emails or shows information to a client, supplier, visitor or data subject.
2. **Anything destructive:** every tool marked destructive, such as deletes, directory changes and stopping trust centre sharing.
3. **Sign-offs:** Steve chose to keep asking for these, because a sign-off stays a person's deliberate click. They include:
   - approving a DDQ answer or library entry;
   - publishing content;
   - deciding a DSR part or a request to disclose;
   - placing a legal hold;
   - completing an incident review or a SAP entry;
   - approving a trust centre access request;
   - validating an expedited access change;
   - starting a recertification now.

**Everything else just happens:** setting up and extracting questions, saving and drafting answers, assigning questions, adding missed questions, submitting for review, drafting library entries, and updating records. Each still shows as a line in the window ("Saved the answer to A.1"), and is recorded in History as made by the person, via Polaris.

## Behaviour

- **The cards that remain offer Allow / Deny only.** Every ask left is for something that deserves its own click every time, so "Allow for this conversation" goes.
- **The card says plainly what will happen and who it reaches.** For example: "Send DDQ-14 to Acme Ltd through the trust centre — 42 answers, 6 files", or "Delete risk RSK-12".
- **Polaris's instructions change to match.** It no longer says "I'll ask before each change"; it gets on with drafts and stops only at the three kinds of step above.
- **Nothing about who can do what changes.** Polaris still acts with exactly the person's role, and things it can never do stay refused, such as releasing held-back information (ADR 0124 §16).

## Notes for the build

- **Registry:**
  - Replace the "every non-read-only tool asks" rule in `core/polaris/engine.py` with `registry.asks(name)`, which is true for: destructive tools, `compass_tool(always_ask=True)`, and a new `sends_outside=True` flag.
  - Sweep every tool:
    - Mark each that sends outside the organisation. The likely set is `ddq_send_via_trust_centre`, `ddq_mark_sent`, the trust centre email, post, invite, resend and extend tools, `vendors_send_questionnaires`, and any DSR tool that writes to the data subject.
    - Re-check the 19 `always_ask` tools: keep the sign-offs, and move any purely outward ones to `sends_outside`.
    - List the final set in the Done comment so Steve can check it.
- **`allowed_tools` / "allow for conversation":**
  - Remove the decision value `allow_for_conversation` from the approvals route and the window's card.
  - Keep the route and the pending state for the remaining asks.
  - This is an API change, so regenerate schema.d.ts. Existing conversations with a pending card still resolve.
- **Polaris's system prompt and the DDQ guidance:** reword them around the three kinds of step.
- **ADR 0127:** add an "Amended by" note saying ask-before-change is narrowed to sends, destructive steps and sign-offs (Steve, 2026-10-26).
- **Tests:**
  - a save, an assignment and a question extraction run without pausing;
  - a send, a delete and an approve-answer each pause;
  - Deny stops them;
  - the `allow_for_conversation` decision is refused;
  - a registry test that every tool whose name contains send, email, invite, post or publish is marked as asking, so a new tool can't slip through.