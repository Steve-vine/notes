---
id: 01M0FD3DM9SACB428V4SBDE7K8
created: 2026-08-20T10:57:35.36913Z
updated: 2026-08-20T12:32:46.136972Z
type: task
title: Forms say what is wrong and where — submit-then-explain, instead of a disabled button and no reason
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 311
sprint: sbph5q5
comments:
- id: 01M0FDC7C32AE70H5WPNJ8ET1W
  author: Steve Vine
  at: 2026-08-20T11:02:23.874908Z
  text: |-
    Sharpened after Steve hit a concrete case: `htttp://moneypenny.com` in the website field on Request a new vendor → **"Request validation failed"** at the foot of the modal, with nothing naming the field.

    Traced it, and the finding changes the shape of the fix. **This is not the disabled-button problem** the task was originally written around — that form submits happily (name and engagement are filled) and is rejected by the server. Three distinct layers:

    1. **The API already sends what the UI needs.** `_handle_validation_error` returns `jsonable_encoder(err.errors())` as `detail`, carrying `loc: ["body","vendor","website"]` and a per-field `msg`. The client discards it — `errorMessage()` reads `error.message` and stops. So the field-level fix is **client-side only**; no API change needed for this case.
    2. **The Pydantic message is not showable even once surfaced.** `_HttpUrl` is a regex `Field(pattern=r"^https?://\S+$")`, so `msg` reads `String should match pattern '^https?://\S+$'`. Attaching that to the field swaps a vague sentence for a regex — the patterned types need human wording, and it needs to live in one place so client and server cannot disagree.
    3. **It never needed a round trip.** A malformed URL is knowable on blur.

    Both failures now share one spec because they want the same plumbing — per-field errors on a touched/submitted basis. Splitting them would mean building that twice.
- id: 01M0FJHPHR6AV87MH2FARDNWGJ
  author: Steve Vine
  at: 2026-08-20T12:32:46.136816Z
  text: |-
    Done — PR #305, merged to main as d80e0bb.

    Both failures, one mechanism, as your comment concluded. `forms/fieldErrors.ts` + `forms/useFormErrors.ts` + `forms/ErrorSummary.tsx`, then the five forms you named: Request a new vendor, Request an engagement, Amend engagement, Edit request, Add/Edit engagement.

    **The URL case, end to end.** Write hooks now throw with the envelope attached as `cause`, so `.message` is unchanged for every existing reader while the per-field `detail` survives the trip. A form's field keys are the API's own path for that field (`vendor.website`, `contacts.0.email`), so `loc: ["body","vendor","website"]` lands on the right input with no translation table to keep in step with the payload. A malformed URL is also caught on blur, so the typo never costs a round trip.

    **Decisions you asked for, with reasons:**
    - *Human wording lives client-side, in one place.* The server's messages are the contract every other consumer reads, and wording it on both sides invites them to disagree.
    - *A small shared hook, not `@mantine/form`.* The useful half is mapping `loc` to a field, which no form library does for us, and these forms carry heterogeneous state — a contacts array, a shared engagement block, a sparse amendment overlay — that `useForm` would mean rewriting wholesale for no gain. Recorded in the code so the next form does not re-decide it.
    - *Nothing is red before a touch or a submit*, exactly as you flagged with `RoleDetailPage`.

    `engagementIsComplete` is gone: `engagementErrors` replaces it and says *which* of the three is missing, so every form that collects an engagement gives the same answer in the same words.

    **One item I could not do as written.** There is no duplicate-name 409 to attach — `vendors.name` has no unique constraint and nothing raises a conflict on it, so that rejection does not exist today. The mechanism handles the general case (a rejection naming no field can be nominated to one, and is otherwise still rendered as the form's overall error rather than swallowed), and that path is tested with a generic conflict. Making duplicate names an actual 409 is a backend change outside this task — say the word and I will raise it.

    Tests: nothing red before a touch or submit; submit marks the right fields and not the optional ones; focus lands on the first fault; a mistyped URL caught on blur; a 422 marks the website field in words and never renders "Request validation failed" alone; a field-less rejection still reaches the reader; a complete form submits unimpeded — plus unit tests for the envelope mapping. Three existing tests asserting the disabled button are rewritten to assert the new behaviour rather than deleted. Full suite green (466).

    Ready for smoke-testing: type `htttp://moneypenny.com` into Website on Request a new vendor — it should go red under the field on blur, in words. Then press Submit on an empty form and check it names the count at the top and jumps you to the first field.
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
On a long form — Request a new vendor is the worst, with a vendor section, a contacts list and a whole engagement block — you can be stopped from submitting, or bounced after submitting, with nothing on screen saying which field is at fault.

There are **two separate failures** here, and they need one shared answer.

## 1. The disabled button that never says why

The dominant pattern is a **disabled submit**:

```tsx
disabled={!name.trim() || !engagementIsComplete(engagement)}   // RequestVendorModal
```

**99 sites** do this. Nothing is ever submitted, so nothing comes back to report, and the greyed-out button is the entire message. Meanwhile **51 fields carry Mantine's `required`**, which draws a red asterisk and validates nothing; exactly **two** inputs in the codebase use the `error` prop that draws a red border.

## 2. The worked example: a bad website URL (Steve, 2026-08-20)

Typing `htttp://moneypenny.com` submits — name and engagement are filled, so the button is live — and comes back as **"Request validation failed"** at the foot of the modal. Which field, and what is wrong with it, are not stated anywhere.

**The API already sends both.** `core/errors.py` returns the full Pydantic error list as `detail`:

```python
_envelope("validation_error", "Request validation failed", jsonable_encoder(err.errors()))
```

— including `loc: ["body", "vendor", "website"]` and a per-field `msg`. **The client throws it away**: `errorMessage()` reads `error.message` and nothing else, so the one useful part of the response never reaches the screen.

**And the message underneath is not fit to show either.** `_HttpUrl` is `Annotated[str, Field(pattern=r"^https?://\S+$")]`, so Pydantic's `msg` is `String should match pattern '^https?://\S+$'`. Surfacing that verbatim swaps a vague sentence for a regex. A typed URL is also knowable **before** the round trip — the form should catch it on blur and say "must start with http:// or https://".

## The work

- [ ] **Submit becomes attemptable**, and marks the offending fields via Mantine's `error` prop — red border and a message under the field — instead of the button being unpressable. That is the moment the red is *earned*; while the button is disabled there is no such moment.
- [ ] **Do not mark a field before it has been touched or submitted.** `RoleDetailPage` shows the trap: `error={owner ? undefined : 'Required'}` renders red the instant the form opens. A blank form covered in red teaches people to ignore red.
- [ ] **Stop discarding `error.detail`.** Map each entry's `loc` to its field and attach `msg` there. This is the half that fixes the URL case, and it is client-side only — the payload is already correct.
- [ ] **Human messages for the patterned types.** `_HttpUrl` and friends need wording a person can act on rather than the regex. Either give the field a message client-side or attach one server-side; decide which, because doing both invites them to disagree.
- [ ] **Validate a URL on blur**, so the obvious typo never costs a round trip.
- [ ] **Move to the first offending field** — focus it and scroll it into view. On this form the field is often below the fold, and a red border you cannot see is no better than a disabled button.
- [ ] **Say it once at the top too**, so a screen-reader user and anyone looking at the button gets the same answer: "3 fields need attention", with the per-field detail below.
- [ ] **Other server-side failures belong on the field as well** — a duplicate vendor name comes back 409 and currently lands as a detached red line at the foot of the modal. The client cannot predict a name collision, so that is the only feedback that case will ever get.
- [ ] **Decide whether to adopt `@mantine/form`.** Not a dependency today, and 99 hand-rolled guards is what `useForm` exists for — touched/dirty state, per-field validation, `form.errors` wiring. Adding a dependency is a real decision; weigh it against a small shared hook. Either way, do it **once**.
- [ ] **Scope deliberately.** All 99 at once is a large change with little information in it. Suggest the shared mechanism plus the forms that hurt — Request a new vendor, Request an engagement, Amend engagement, Edit request, Add/Edit engagement — with the rest converting as they are touched.

- [ ] Tests: **a malformed website URL marks the website field and names the problem, and never renders "Request validation failed" alone**; submitting an incomplete form marks the right fields and not the others; nothing is red before a submit or a touch; focus lands on the first offending field; a 409 on a duplicate name attaches to the name field; a complete form still submits unimpeded.
