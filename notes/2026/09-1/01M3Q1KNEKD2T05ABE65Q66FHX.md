---
id: 01M3Q1KNEKD2T05ABE65Q66FHX
created: 2026-09-29T16:57:45.683314Z
updated: 2026-09-29T17:27:24.764329Z
type: task
title: 'The trail across Posture and the overview screens: Dashboard, Assessments, Gaps, Risks, Reports, Search, Actions, Admin'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 788
sprint: svq5edz
blocked_by:
- 01M3Q1K82GNMBWV667KHS4THGT
comments:
- id: 01M3Q39XX11WNNE75XH0FE4ZCC
  author: Steve Vine
  at: 2026-09-29T17:27:23.809775Z
  text: |-
    Done: PR #798, stacked on #797.

    - **Gaps and risks.** They no longer have their "← Gaps" / "← Risks" links. Their trail steps read the way the registers name them (G-14 · …, R-14 · …). Going gap → control → risk → vendor reads as you went, and each step returns you to where you were. A pasted link shows Gaps › … or Risks › ….
    - **Assessments.** Opening a control in the queue's side panel doesn't add a step, because it's the same screen. Coming back to Assessments reopens the control you had open. A link out of the panel is an ordinary step.
    - **Search, Actions, the Dashboard, Notifications, the activity log and Admin** needed nothing more. Their links are ordinary steps and their tabs are already remembered. The search step reads Search: "…" and brings back the same results.
    - **Timeline.** The period you pick still resets when you come back. COM-792 covers remembering list settings.

    The full frontend suite passes locally.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Carries the trail from COM-787 into the Posture section and the overview screens. Every step on these screens gets its proper name, and the fixed back links go.

## What people see

- **Gaps and risks lose their "← Gaps" and "← Risks" links.** Following a gap → its control → its risk → the vendor reads `Gaps › G-14 … › 5.2 … › R-12 … › Acme Ltd`, and each step returns you to where you were.
- **Steps are named as the screen names them.** A gap by its reference and title, a risk likewise. Reports, the Timeline, Actions, Notifications, Admin, the activity log and System status by their menu names.
- **Starting from the Dashboard, Actions or Notifications.** A link from any of these adds a step, so you can go back to your to-do list or the dashboard tile you came from.
- **Search results are a step you can return to.** Open a result, follow a link or two, then click `Search: "password"` to come back to the same results.
- **Assessments.** Opening a control in the queue's side panel doesn't add a step, because it's the same screen. The Assessments step returns to the queue with that control's panel open. Following a link out of the panel adds a step as usual.
- **Admin's tabs** behave like any other tabs: clicking the Admin step returns to the tab you were on.

## Notes (technical)

- **Back links removed:** `pages/RiskDetailPage.tsx` 95/104 and `GapDetailPage.tsx` 106/117. Clear both from the ratchet allowlist added by COM-787.
- **`useTrailLabel`** on the detail pages: Gap and Risk. `/assessments/:ref` is the same page as `/assessments`, with a panel opened by navigation. Make opening a ref a REPLACE, or treat `/assessments/*` as one step in the reducer so the step keeps the ref. Pick whichever keeps browser Back sensible; today each panel open may be a PUSH, so check.
- **Search.** `SearchPage.tsx:32` keeps `?q=` in the URL, so the step already restores the results. It's labelled from `q`.
- **Actions and API-supplied links.** Rows (`actions/ActionsTable.tsx:83,93`), Search (`SearchPage.tsx:60`) and Decision links (`DecisionDetailPage.tsx:128`) navigate to paths the API supplies. They're ordinary PUSHes; check that the natural-home map covers every path the API can emit.
- **Timeline.** Its period (`TimelinePage.tsx:43`) is local state. Leave it to COM-792, or move it to the URL here if that's trivial.

**Done when:** on staging, gap → control → risk → vendor and back works step by step. Search → result → back returns the same results. No Posture or overview page has a fixed back link.