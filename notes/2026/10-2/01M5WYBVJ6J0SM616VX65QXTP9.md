---
id: 01M5WYBVJ6J0SM616VX65QXTP9
created: 2026-10-26T20:27:54.310849Z
updated: 2026-10-26T20:27:59.278735Z
type: task
title: The override is a "Give to this client anyway" switch on a held-back answer or piece of evidence — this DDQ only, its classification untouched
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1337
sprint: s4zhkvy
blocked_by:
- 01M5WWM0GTX49QJBCACM0TQ8SX
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
## What Steve asked for

"The classification belongs to the answer, the override can bypass a restriction." The override should be a toggle that lets a Sensitive or Internal answer, or one at any other level, go to this client this once. It shouldn't be a second list of levels.

Today the bypass already exists as a release on the DDQ (COM-1259). An Admin releases a held-back item, with a reason, from the Held back list in review. But it's nowhere near the answer, and the form's "Disclosure override" select (which was really the classification, see COM-1336) looked like the override.

## Behaviour

- **The switch appears where an item is held back:**
  - In the answer form's "Can this be given?" panel, beside each held-back item: the answer, and each piece of evidence.
  - It reads **"Give to this client anyway"**.
  - It's shown only while that item is held back.
- **Switching it on asks for a short reason**, which is kept in history. For example: "Client's auditor; NDA in signature."
  - The item then reads "✓ Given anyway — by Steve Vine, 26 Oct: <reason>".
- **This DDQ only.** The answer's classification, and the evidence's, is unchanged. The library and other DDQs are unaffected.
- **Who can switch it:** the same people who can release held-back information today, which is Admins as shipped.
  - Anyone else sees the switch greyed out with "An Admin can give this anyway".
  - **Polaris can never switch it.** That's unchanged from ADR 0124 §16.
- **Switching it off** is allowed until the DDQ is sent, and history keeps both. Today a release can't be undone; a switch can.
- **Rewording the answer** turns the switch off for the answer. What was allowed was the old wording, so the new wording needs allowing again, and the form says so. Evidence stays allowed, because its file hasn't changed.
- **The Held back list in review** shows the same switch, so it can still be done from there.

## Notes for the build

- It's built on the existing `DdqRelease`, `core/ddq_review.release`, `POST /ddqs/{id}/releases` and the "Release held-back information" grant.
- **Undoing:**
  - Add `DELETE /ddqs/{id}/releases/{release_id}`, or mark the release withdrawn, so history keeps both. A `withdrawn_at`/`withdrawn_by` column is the likely shape.
  - That means a migration and an API change, so the task is **on the chain after COM-1336**.
  - The release stays frozen once the DDQ is sent.
- **The form:**
  - `AnswerForm` "Can this be given?" `ShareLine` gains a Switch with `w="fit-content"` and an aria-label, plus a small reason prompt.
  - Hide it when the item is allowed by the rules. Disable it without the grant.
  - The assistant refusal stays, in the core function and on the route.
- **Wording:** check the completed file, the evidence pack and the Sent cards. Use "Given anyway" where they say "Released".
- **ADR:** add a short amendment to ADR 0124 §10: the release is a per-item switch on the answer, and can be withdrawn until the DDQ is sent.
- **Tests:**
  - switching on needs the grant and a reason;
  - Polaris and API tokens are refused;
  - switching off before sending works, and after sending is refused;
  - a reworded answer loses it;
  - evidence keeps it;
  - the classification is unchanged;
  - the form shows and greys the switch correctly.