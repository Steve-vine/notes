---
id: 01M1TRJBFXEST1T4RJRMKY6P70
created: 2026-09-06T07:05:19.613306Z
updated: 2026-09-06T08:31:17.706661Z
type: task
title: saving an assessment says nothing
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 565
sprint: s2fcksg
comments:
- id: 01M1TVDS5RCKGW020Z35AW015P
  author: Steve Vine
  at: 2026-09-06T07:55:15.512759Z
  text: |-
    Done — PR #574, merged to main.

    All four mutations in the assessment editor now raise the standard green toast: "Assessment saved", "Gap raised", "Evidence file uploaded", "Evidence file removed". One `meta: { successMessage }` line each; the toast is wired globally in queryClient.ts (ADR 0022), so nothing new was needed.

    The double error was checked, not changed. It is deliberate and documented in AssessmentPanel.tsx from COM-554: a failed "Save and continue" leaves you on the panel after the toast has faded, and the inline copy is what tells you the changes are still there.

    No new tests. The toast wiring is tested once centrally (queryClient.test.tsx covers meta.successMessage) and the other 100 opted-in mutations in the app assert nothing individually — this follows them.

    Awaiting smoke test on staging: save an assessment (especially via Save and continue), raise a gap, upload and then delete an evidence file — each should say so.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Found by Steve on staging, 2026-09-05.

Save a control assessment and **nothing confirms it**. No toast, no inline line — the button stops spinning and that is all. Everywhere else in the app a save says so: "Control saved", "Domain saved", "Risk tier saved", "Email transport saved" — 96 mutations opt into that green toast. The assessment editor is one of the places that never did.

It matters most in the flow Steve was already in when he found it: **Save and continue** saves and immediately moves you to the next control, so there is no button state left to read and nothing on the new screen refers to what just happened. You are asked to take it on trust — while COM-564 was busy filling the next control with the previous one's answers, which is exactly the situation where you want the app to tell you what it did.

## What changes

- Saving an assessment raises the standard green toast — "Assessment saved", following the wording already in use.
- The other three mutations in the same editor are silent too, and all of them are things a person needs confirmed: **raising a gap**, and **uploading** or **deleting** an evidence file. Deleting evidence in silence is the worst of the three. Cover them in the same pass rather than fixing only the one that was reported.
- One line each — `meta: { successMessage: … }` on the mutation. The toast is wired globally in `queryClient.ts` (ADR 0022); nothing new is needed.

## While you are there

A failed assessment save currently shows the message **twice** — once as the global red toast and once inline under the form. That may be deliberate (the inline copy survives the toast fading, and the panel says "your changes are still here"), so check the intent from COM-554 before changing it. Flagging it, not asserting it is wrong.

## Related

- COM-564 — the same editor carries answers onto the next control. Same screen, worth testing together.
- COM-554 — a failed save says why it failed. The error half of this story.
- ADR 0022 — the toast convention.
