---
id: 01M7J4CQZ5E4MZCYY8XMRRJ02G
created: 2026-11-16T12:12:59.749055Z
updated: 2026-11-16T23:03:23.1699Z
type: task
title: 'Check page: a Details section says what the check does, "Latest capture" becomes "Evidence" showing only the evidence itself, and picking a History entry shows that capture''s evidence'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1870
sprint: s7nqsy0
comments:
- id: 01M7J962Q66JPCSR4NJJ8Z6SRA
  author: Steve Vine
  at: 2026-11-16T13:36:44.26231Z
  text: |-
    Done — PR #1857, merged to main (b9bfbc17). Not on staging yet.

    - Details replaces the side About panel. It shows Description, Reads, Collects, Schedule with the next run, Evidences (the control, linked, fully or partly), Replaces (if it does) and Approved by.
    - Evidence replaces "Latest capture". It shows only the capture's items: every one, 50 to a page, with the columns in the check's order and named as the check names them. The column menus, renames, moves and lookups are gone; they stay on the control's Evidence tab and in Review. An empty capture says so, and so does a held one.
    - History is unchanged, except that clicking a capture shows it in Evidence. The capture stays highlighted, a line names it ("Showing the capture of 30 Oct–5 Nov 2026, taken …"), and Back to latest returns.
    - Order: Details, Evidence, History, Workflows. The side column keeps Changes.
    - I kept "Collects" in Details as well as the items you listed, because it says what the check does.

    To check on staging: open CHK-26's page. Check that Details reads correctly and that Evidence is a plain table of every change. Click an older capture in History, then Back to latest.
- id: 01M7JEBTWY0P1XDDRHNQNPDHV3
  author: Steve Vine
  at: 2026-11-16T15:07:15.741949Z
  text: |-
    **Pre-UAT: Passed** (staging 43d03f09, E2E Test Company, E2E Admin A, on CHK-2's page). One note below about what "latest" shows.

    Steps and what I saw:
    - **Details** replaces the side About panel. It shows:
      - Description;
      - Reads ("A Collection service: GET /users/octocat/repos");
      - Collects ("A snapshot of how it's set up");
      - Schedule with the next run ("Weekly · next 21 Nov 2026");
      - Evidences ("ACC.13 (partly)", with ACC.13 linked to its Evidence tab);
      - Approved by ("E2E Admin A on 6 Nov 2026").
    - Order on the page is Details, Evidence, History, Workflows. The side column has only Changes.
    - **History ▸ pick a capture** (6 Nov 12:21, 8 items): Evidence shows "Showing the capture, taken 6 Nov 2026, 12:21." with Back to latest, then a plain table of all 8 items. There are no column menus or buttons in the header, and the picked entry stays highlighted.
    - Picking the 210-item capture (6 Nov 10:56) gives 50 rows a page, with pages 1–5.
    - **Back to latest** returns to the latest view.

    The note: with nothing picked, Evidence says "Not collected yet." The header says "Last collected 6 Nov 2026, 12:21" and History lists 5 filed captures. The cause is that CHK-2's integration was deleted: "latest" only counts captures from accounts it reads now. It's an unusual case, but "Not collected yet" is wrong when there are captures. Something like "Nothing from the account it reads now; pick a capture in History" would be accurate. Not raised as a defect; Steve to decide.

    Not covered: E2E Test Company has no records check, so I couldn't see the period wording ("Showing the capture of 30 Oct–5 Nov…"). For a snapshot it reads "Showing the capture, taken …", without the "as at" date. Look at CHK-26's page in Test Company for the records case.

    Screenshots: ~/compass-uat/s7nqsy0/COM-1870/ (chk2-page.png, chk2-history-picked.png, chk2-210-items-paged.png)
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Asked for by Steve while testing sprint "Automation - Workflows" on staging (2026-11-16).

## Today

- What the check does sits in a side panel called About.
- "Latest capture" shows the Review sample table: the first 10 rows, with the column tools (rename, move, lookups and other mappings).
- History lists every capture, but picking one doesn't show its evidence.

## Done when

- **Details** is a section that says what the check does:
  - **Description** (its About text);
  - **Reads**;
  - **Schedule**, with when it next runs;
  - **Evidences**: the control, linked, fully or partly;
  - **Approved by**: who approved it, and when.

  It replaces the side About panel. (When COM-1866 lands, the date it collects by goes here too.)
- **Evidence** replaces "Latest capture". It shows only the capture's evidence: its table of items, columns as the check names them, every item, paged or scrollable. The column tools, mappings and other controls are removed (column changes stay on the control's Evidence tab and in Review). A capture with no items says so.
- **History** stays as it is, but picking an entry shows that capture in the Evidence section. A line names which capture is shown (period and when it was taken), with **Back to latest**. The entry stays highlighted. A held capture still opens its review as today.
- Order on the page: Details, Evidence, History, Workflows. The side column keeps Changes.
- Tests cover: Details shows each item; Evidence shows every item with no column tools; picking a History entry shows that capture, and Back to latest returns.

Independent, unless showing a past capture's full items needs an API route (it then joins the chain).