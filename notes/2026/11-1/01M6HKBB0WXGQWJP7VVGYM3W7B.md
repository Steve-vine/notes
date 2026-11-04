---
id: 01M6HKBB0WXGQWJP7VVGYM3W7B
created: 2026-11-03T20:59:26.108175Z
updated: 2026-11-04T07:45:43.138128Z
type: task
title: Add controls to an initiative — each brings its gaps, linked risks, decisions and content, kept live; the Controls, Gaps, Risks, Decisions and Content tabs list them with their own owners and status
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1555
sprint: snyzymp
blocked_by:
- 01M6HKAW0ZEHMN8JEV15XMBARN
comments:
- id: 01M6HQNBCJ2SDPRV0X9BK2P51K
  author: Steve Vine
  at: 2026-11-03T22:14:48.466166Z
  text: |-
    Done: PR #1569 merged (fb59d030), migration 0769.

    What's there:
    - **Controls tab:**
      - *Add controls* opens a picker: search, narrow to a domain, "All controls in this domain", pick several at once, with controls already in the initiative shown as added.
      - Each row shows ref, title and domain, the assessment in this company (or "Not assessed"), its owner, next review, and open gaps and risks.
      - A remove button takes a control out, along with whatever only it brought.
    - **Gaps, Risks, Decisions and Content tabs:**
      - each item shows its reference, title, status, its own owner (content: its reviewers; decisions: "Accepted by …"), its date, and "via" the controls that bring it;
      - every row opens the item's own page;
      - the tab titles carry the counts.
    - **Live:**
      - gaps on the controls in this company;
      - risks linked to them;
      - decisions on the controls or on those risks;
      - content linked to them, plus their domain's policy.

      These are all worked out on every read, so a gap raised later appears by itself. Another company's posture never appears.

    My calls:
    - **The Controls tab doesn't show maturity,** to keep the table readable. The assessment pill says Partial or Implemented, or Not applicable when the control is out of scope.
    - **A risk counts as open** while it's Open or Treated.
    - **Removing a control removes only what nothing else brings.** A risk two controls share stays.

    To test on staging (after the sprint deploys), as admin in E2E Test Company:
    1. Add a control that has a gap, a linked risk, a decision and content.
    2. Check each tab: each item shows with its owner and "via" the control.
    3. Raise a new gap on that control from its own page.
    4. Back on the initiative's Gaps tab, the new gap is there.
- id: 01M6HYYTDXH559JV14ZZN9W0DR
  author: Steve Vine
  at: 2026-11-04T00:22:18.813798Z
  text: |-
    Pre-UAT (staging 9c0b06a2, 2026-11-04, E2E Test Company): **Passed** (through the API; the Playwright browser wasn't connected this session).

    Steps and what I saw, as E2E Admin A on INI-1:
    1. Added control INS.10, assessed Partial with E2E Assessor as owner. The Controls tab shows INS.10 with 25 open gaps (many left by earlier test runs) and 1 open risk.
    2. Each tab shows its items "via INS.10", with their owners:
       - Gaps: G-36 to G-60;
       - Risks: R-42;
       - Decisions: D-10, "Accepted by E2E Admin A";
       - Content: the IT Acceptable Use Policy and the Information Security Policy.
    3. Raised G-61 on the control from outside the initiative: it appeared on the Gaps tab by itself.

    For you to look at: the Add controls picker, including "All controls in this domain".
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Initiatives - New Feature" (ADR 0140, COM-1552). Builds on COM-1554.

## What people see

- **Add controls** on the Controls tab, for the owner or anyone with *Manage initiatives*:
  - a searchable picker with several chosen at once;
  - filtered by domain, with "all controls in this domain" as a shortcut;
  - controls already in the initiative are shown as added.
- **Controls tab.** One row per control, showing:
  - reference and title;
  - its assessment in this company (status, maturity);
  - the assessment owner;
  - next review date;
  - counts of open gaps and risks.

  A control can be **removed**, which also removes what it brought, unless that item was also added directly or came through another control.
- **What each control brings,** each on its own tab:
  - **Gaps:** the control's gaps in this company, open and closed.
  - **Risks:** risks in this company linked to the control.
  - **Decisions:** decisions linked to the control, or to one of those risks.
  - **Content:** content linked to the control, plus its domain's policy (policies cover their domain's controls by membership).
- **Live.** What a control brings is worked out each time, never copied:
  - a gap raised on it next month appears by itself;
  - a risk unlinked from it disappears.
- **Each row** shows the item's reference, title, status pill and **its own owner**:
  - gap and risk owner;
  - content reviewers;
  - decisions show who created them and who decided them (COM-1553).

  It also shows **where it came from** ("via AC-3", or "via AC-3, AC-7"). Each row links to the item's own page, and the trail leads back to the initiative.
- Items finished before they joined (a closed gap, a closed risk) show as such. Counting comes in COM-1560.

## Notes (technical)

- `initiative_controls` (initiative_id, core_control_id, added_at, added_by; unique pair). Audited.
- Linked items are **resolved at read time** from the existing links:
  - gaps via the company's assessment for the control;
  - `risk_control_links` filtered to the initiative's company;
  - `decision_links` targeting the control or the resolved risks;
  - `content_control_links`, plus the domain's policy.
- One resolver (e.g. `core/initiatives/members.py`) returns every item with its sources. COM-1556, COM-1559 and COM-1560 all read it. Keep it set-based: an initiative with 40 controls must not issue a query per control.
- `GET /initiatives/{id}/items?kind=` serves the tabs. Mind the page tests' prefix stubs for new sub-routes (memory: subresource routes vs prefix stubs).

**Chain:** on the chain (migration + API).

**Done when:** on staging, as admin in E2E Test Company:
- adding a control that has a gap, a linked risk, a linked decision and linked content shows each on its tab, with its owner and "via" the control;
- raising a new gap on that control from its own page then shows it in the initiative without touching the initiative.