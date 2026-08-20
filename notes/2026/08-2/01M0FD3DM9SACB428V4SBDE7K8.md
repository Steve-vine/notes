---
id: 01M0FD3DM9SACB428V4SBDE7K8
created: 2026-08-20T10:57:35.36913Z
updated: 2026-08-20T10:57:35.36913Z
type: task
title: Forms say what is wrong and where — submit-then-explain, instead of a disabled button and no reason
assignee: steve
priority: medium
label: improvement
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 311
---
On a long form — Request a new vendor is the worst, with a vendor section, a contacts list and a whole engagement block — you can be unable to submit and have nothing on screen telling you why, or which field is at fault.

**The cause is not a validation that fails badly. It is that there is no validation at all.** The pattern across the app is a **disabled submit button**:

```tsx
disabled={!name.trim() || !engagementIsComplete(engagement)}   // RequestVendorModal
```

**99 sites** do this. Nothing is ever submitted, so nothing ever comes back to report, and the greyed-out button is the entire message. Meanwhile **51 fields carry Mantine's `required`**, which only draws a red asterisk — it validates nothing and shows no error. Exactly **two** inputs in the whole codebase use the `error` prop that would draw the red border.

So the fix is a change of interaction model, not a coat of paint: **let the form be submitted, then say what is wrong and where.**

- [ ] **Submit becomes attemptable.** Pressing it with something missing marks the offending fields via Mantine's `error` prop — red border and a message under the field — instead of the button being unpressable. That is the moment the red is *earned*; there is no such moment while the button is disabled.
- [ ] **Do not mark a field before it has been touched or submitted.** `RoleDetailPage` shows the trap: `error={owner ? undefined : 'Required'}` renders red the instant the form opens. A blank form covered in errors teaches people to ignore red. Track touched/submitted and mark on that.
- [ ] **Move to the first offending field** — focus it and scroll it into view. On Request a new vendor the missing field is often below the fold, and a red border you cannot see is no better than a disabled button.
- [ ] **Say it once at the top as well**, so a screen-reader user and anyone whose attention is on the button gets the same answer: "3 fields need attention" beside the submit, with the per-field detail below.
- [ ] **Server-side failures belong on the field too.** A duplicate vendor name comes back 409 and currently renders as a general red line at the foot of the modal, detached from the input that caused it. Where the API names a field, put the message there — the client cannot know about a name collision in advance, so this is the only feedback that case will ever get.
- [ ] **Decide whether to adopt `@mantine/form`.** It is not a dependency today, and 99 hand-rolled guards is the kind of thing it exists for — `useForm` gives touched/dirty state, per-field validation and `form.errors` wiring for free. Adding a dependency for this is a real decision though, so weigh it against a small shared hook. Whichever way, do it once: this must not become 99 individual implementations of the same idea.
- [ ] **Scope this deliberately.** Doing all 99 at once is a large, low-information change. Suggest the shared mechanism plus the forms that actually hurt — Request a new vendor, Request an engagement, Amend engagement, Edit request, Add/Edit engagement — and a note that the rest follow the same helper as they are touched.

- [ ] Tests: submitting an incomplete form marks the right fields and not the others; nothing is red before a submit or a touch; focus lands on the first offending field; a field-specific server error attaches to its field; a complete form still submits unimpeded.
