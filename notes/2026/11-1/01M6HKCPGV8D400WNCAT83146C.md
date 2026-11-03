---
id: 01M6HKCPGV8D400WNCAT83146C
created: 2026-11-03T21:00:10.651208Z
updated: 2026-11-03T21:01:27.586675Z
type: task
title: Work it from the initiative — assess a control, raise and update gaps, create risks and treatment plans, record decisions and review content without leaving the initiative; anything created there joins it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1558
sprint: snyzymp
blocked_by:
- 01M6HKC6NF2YB57Z51Q2MHK613
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). Builds on COM-1555, COM-1556 and COM-1557.

## What people see

Each tab gets the actions you'd use on the item's own page. They open the **same forms and drawers** used elsewhere, so nothing is learnt twice. You come back to the initiative afterwards with the row updated.

- **Controls:** **Assess**, the assessment form (status, maturity, owner, review dates, evidence). **Raise gap** opens with the control filled in.
- **Gaps:** open a gap to update its status, owner and target date, or to comment.
- **Risks:**
  - **New risk** opens with the initiative's controls offered for linking. It joins the initiative directly, and through any control you link.
  - On a risk: **Add treatment plan** and update treatment plans.
- **Decisions:** **New decision** is linked to whichever of the initiative's controls or risks you pick, and joins the initiative.
- **Content:**
  - **Review** records a review, for its reviewers. A pending Requires review shows with the review button.
  - **Open** takes you to the content page to edit it.

Rules for these actions:
- **Your own permissions decide.** A button shows only if you could do the same thing on the item's own page (*Assess*, *Manage gaps*, *Manage risks*, decision and playbook rights). Being the initiative's owner grants nothing extra on its items.
- **Closed initiatives.** A Complete or Cancelled initiative (COM-1561) shows no work buttons. The items' own pages still work as normal.
- **Trail.** Leaving to an item's full page and coming back keeps the trail: Initiatives ▸ INI-3 ▸ G-41.

## Notes (technical)

- Reuse the existing drawers and forms.
- New risk and new decision take an optional `initiative_id`, which writes an `initiative_items` added row in the same transaction. Check the caller can edit the initiative; otherwise it's created but not added, and the screen says so.
- Gaps need no new link: they belong to their control.
- React Query: invalidate the initiative's item lists and percentage after each write. Reuse the cache; no refs in render (see the React hooks lint memory).
- Add a Browser smoke journey: start an initiative, add a control, assess it, raise a gap, add a risk with a treatment plan.

**Chain:** on the chain (API: initiative_id on create).

**Done when:** on staging, as admin in E2E Test Company, from the initiative alone:
- assess a control, then raise a gap on it;
- create a risk with a treatment plan (it shows "added directly" and via its control);
- record a decision linked to the control;
- review a content item.

Then as E2E Viewer, the same tabs show no work buttons.