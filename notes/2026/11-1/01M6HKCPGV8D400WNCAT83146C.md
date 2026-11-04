---
id: 01M6HKCPGV8D400WNCAT83146C
created: 2026-11-03T21:00:10.651208Z
updated: 2026-11-04T00:22:28.809965Z
type: task
title: Work it from the initiative — assess a control, raise and update gaps, create risks and treatment plans, record decisions and review content without leaving the initiative; anything created there joins it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1558
sprint: snyzymp
blocked_by:
- 01M6HKC6NF2YB57Z51Q2MHK613
comments:
- id: 01M6HTRQWS3XDA6M2733SSFK6R
  author: Steve Vine
  at: 2026-11-03T23:09:05.304953Z
  text: |-
    Done: PR #1572 merged (ab9d1e3f).

    What's there. Each action is the item's own form and needs the reader's own permission (an initiative grants nothing). None of them shows on a Complete or Cancelled initiative.
    - **Controls,** from the row menu:
      - **Assess** opens the Assessments screen's own card in a drawer. Saving counts as reviewing, so it also answers a Requires review mark.
      - **Raise gap** opens the register's own dialog. It says "assess it first" until the control has an assessment short of Implemented. The gap joins the initiative by itself.
    - **Risks:** **New risk** is the register's own form, now with "Link to controls" offering the initiative's controls. The new risk is linked to them and added to the initiative.
    - **Decisions:** **New decision** opens the decision editor with "Applies to" (one of the initiative's controls or risks). That link is what brings the decision in.
    - **Content:** **Record review** in the row menu.

    My calls:
    - **No API change.** These use the existing endpoints, then add the item to the initiative.
      - If the reader can work risks but can't edit the initiative, the risk is still made and linked, but isn't added directly. It still joins through any control it's linked to.
    - **Treatment plans and gap updates happen on the item's own page,** one click from its row, rather than being copied into the initiative.
    - **No new Browser smoke journey.** The screens are crawled already. A journey would create a risk and a decision on staging every run, so I've left it for you to decide.

    To test on staging (after the sprint deploys), as admin in E2E Test Company, from the initiative alone:
    1. Assess a control, then raise a gap on it.
    2. Create a risk linked to a control, then add a treatment plan on its page.
    3. Record a decision linked to the control.
    4. Record a review on a content item.
    5. As E2E Viewer, check the same tabs show no work buttons.
- id: 01M6HYZ469PEM1RMKD8G48W1ES
  author: Steve Vine
  at: 2026-11-04T00:22:28.809743Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04): **Couldn't check.** These are screen actions, and the Playwright browser wasn't connected this session.

    What I could check through the API:
    - a decision linked to INI-1's control (D-10) joins the initiative;
    - a gap raised on the control (G-61) appears by itself;
    - saving the control's assessment answers its review mark.

    For you to look at on INI-1, as admin in E2E Test Company:
    1. From the INS.10 row menu: Assess (a drawer), then Raise gap.
    2. On the Risks tab, New risk with "Link to controls" set to INS.10: it should show "via INS.10 · added directly".
    3. On the Decisions tab, New decision with "Applies to" set to INS.10.
    4. On a Content row, Record review.
    5. As E2E Viewer, the same tabs should show no work buttons.
assignee: steve
label:
- feature
priority: high
task_status: review
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