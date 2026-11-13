---
id: 01M7A5PY8MKEWWDEZJSWS34GTM
created: 2026-11-13T10:02:06.996053Z
updated: 2026-11-13T14:34:41.29858Z
type: task
title: 'Vulnerabilities: add a system to an issue, and move a vulnerability freely between systems and company-wide'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1786
sprint: spsp226
comments:
- id: 01M7A92YPH933TBSD4D216P043
  author: Steve Vine
  at: 2026-11-13T11:01:06.385453Z
  text: |-
    Built — PR #1779 (feature/com-1786-vuln-add-system-move, a27880fe), auto-merge set. On the chain: migration 0835_vulnerability_moved_from. ADR 0129 has an appended "Amendment (2026-11-13, COM-1786)", which also amends COM-1776's "no move back".

    **Add a system…**
    - Where it is: on an opened issue row in the Register (next to the whole-issue actions) and on a vulnerability's page. One or more systems can be picked, and "New asset…" is in the picker.
    - What it creates: each system gets its own vulnerability on the same issue, so it shows under that issue row and the row's open/total counts it.
      - It copies the title, kind, description, CVEs, CVSS, recommendation and severity.
      - The owner is the system's owner, or the company default. The fix-by date counts from today.
    - A system that already records the issue is refused, with an "Open VUL-n" link.
    - An added system on a pen-test issue is in the next retest of that report.

    **Move…** (replaces "Move to a system…")
    - Destinations: another system, company-wide, or from company-wide onto a system.
    - A reason is required. It works in any state and as often as needed.
    - The vulnerability keeps its reference, history, comments, owner, fix-by date and state.
    - The only refusal: the destination already records the issue. Only one company-wide entry per issue. The refusal shows a link.
    - The history and activity log read "moved vulnerability VUL-12 … from AST-3 · Web to Company-wide — reason".

    **Scanners after a move:** a vulnerability moved off a system that a scanner or feed reports keeps getting that system's sightings, and no new vulnerability is created. The page says "Moved from X; X's sightings still come here". It is general, keyed on the issue and the old system, never per scanner. Scanners still never create company-wide vulnerabilities.

    **Polaris**
    - vulnerabilities_move (system by name, or company-wide, plus a reason) replaces vulnerabilities_move_to_system.
    - New: vulnerabilities_add_system.
    - Both always ask first. The Vulnerabilities area has 40 tools; the limit is 128.

    **Calls made** (all recorded in the ADR):
    - Where a vulnerability came from is kept as a small list, not one field, so a vulnerability moved A→B→C still collects sightings from both A and B.
    - That's only remembered when a scanner or feed actually reported the issue on the old system. A hand record moved off the wrong system remembers nothing.
    - If the old system later gets its own vulnerability of the issue again, that one takes the sightings.
    - An added system's source reads "Recorded by hand". So a pen-test issue row with added systems shows "Several" as its Source.
    - Add a system copies from the first open vulnerability of the issue. Company-wide is reached through Move, not Add.
    - Both Add and Move refuse a deleted asset (follows COM-1784).

    **Not done:**
    - A retest already in draft doesn't pick up an added system; the next retest does.
    - Polaris's add-system names existing systems only; it can't make a new asset inline.
    - Bulk Move is out of scope, as the task says.

    **Checks:** ruff, mypy and the unit suite (2196) pass. Integration tests pass, including the new test_vulnerability_move.py: add, retest, moves in every direction, sightings after A→B→C, hand record with no redirect, deleted-asset refusal. Also the company-wide, feed, pen-test, record and Polaris tests. The full vitest suite (4017) passes. schema.d.ts was regenerated.

    **Still to check:** the Polaris and staging items in "Done when" wait for the pre-UAT pass.
- id: 01M7ANA18JTWC7S18DCGBECNMY
  author: Steve Vine
  at: 2026-11-13T14:34:41.298247Z
  text: |-
    Pre-UAT on staging ee0d160c, E2E Test Company, as E2E Admin A: **Passed**, with three small defects fixed forward in a new task (below).

    1. **Add two systems from an issue row:** Passed.
       - Hand issue "E2E UAT5 1786 Debug endpoint exposed (no CVE)", VUL-18. I added web-a and web-b from its row.
       - The row went from "1 system / 1 of 1" to "3 systems / 3 of 3" without a reload.
       - VUL-19 and VUL-20 were created with the same severity and kind, owner E2E Admin A, fix by 13 Dec 2026.
    2. **An issue without a CVE gains a system and stays one row:** Passed.
       - The hand issue above stayed one row.
       - The pen-test issue "E2E UAT4 Weak password policy across the estate" (VUL-7) gained VUL-21 on web-a and became "2 systems / 2 of 2".
       - Source reads "Several", as designed.
    3. **Move from the wrong system:** Passed. I moved VUL-18 from wrong-host to right-host with a reason.
       - Its reference, owner, fix-by date, state and earlier comment are all unchanged.
       - The Timeline and History show the move.
       - Nothing is logged in error.
       - Because VUL-18 was a hand record, its page correctly shows no "sightings still come here" line.
    4. **Company-wide and back, more than once:** Passed. VUL-20 went web-b → Company-wide → web-b → Company-wide → web-b, and owner and fix-by never changed. A second company-wide entry was refused with "VUL-20 already records this issue company-wide. Open VUL-20".
    5. **Moving onto a system that already has the issue:** Passed. It was refused with "VUL-19 already records this issue on … web-a. Open VUL-19". Add a system refuses the same way.
    6. **Scanner sighting after a move:** Passed, using a real Nessus file import.
       - The import created VUL-22 on wrong-host (10.86.17.86). I moved it to right-host, and its page reads "Moved from … wrong-host; … wrong-host's sightings still come here".
       - Re-importing gave "New vulnerabilities 0, Already in the register 1", and VUL-22's last seen updated.
       - Once wrong-host had its own vulnerability of that issue again (VUL-23), the next scan went to VUL-23 and the "Moved from" line cleared.
    7. **Polaris does both:** Passed.
       - Add a system: VUL-24 was created on web-a, after an ask-first card.
       - Move: VUL-19 was moved to Company-wide with its reason, from one clear card.
       - Both show "via Polaris" in Admin ▸ Activity.
    8. **History and Activity in screen words:** Passed. For example: "moved vulnerability VUL-20 … from AST-60 · E2E UAT5 1786 web-b to Company-wide — <reason>" and "added vulnerability VUL-19 … on AST-59 · …web-a, added to VUL-18's issue".

    **Defects (fix-forward):**
    - **A. Polaris asks twice for one Add a system, and the first card shows an id.** The first card shows "Company: 5e053577-…", its step fails, and a second, correctly worded card has to be allowed. Polaris passed the company's id, and the tool only matches a company by its name.
    - **B. Polaris says it the wrong way round.** After adding the old system back, it said the old system's sightings still go to the moved vulnerability. In fact the new vulnerability takes them.
    - **C. The Move window always shows "A scanner's later sightings on X still come here".** This includes hand records, and "on Company-wide" when moving from company-wide. The page itself is right.

    **For Steve:** after VUL-23 took wrong-host's sightings, VUL-22 (on right-host) keeps a Nessus sighting from 15:00 that no later scan will update or close. That is as designed. Is that what you want?

    **Test data:**
    - Assets AST-57 to AST-60.
    - VUL-18 to VUL-24, all open.
    - Three Nessus imports, "E2E UAT5 1786 scan …".
    - Four Polaris conversations.

    Screenshots: ~/compass-uat/spsp226/COM-1786/
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
## Why

Steve, testing on 2026-11-13. Once a vulnerability is in the register, its system can't be changed.
- To fix a wrong system today, you log the entry in error and record it again. That leaves a dead entry behind.
- An entry without a CVE that is recorded later on another system becomes its own issue row. It doesn't join the issue it belongs to. Pen-test findings without a single CVE behave the same way.
- Company-wide can only move onto a system (COM-1776). Steve wants it to work both ways "without any limitations".

## What changes

### 1. Add a system… (to an issue)
- Where it appears:
  - on an issue row in the grouped register (next to the whole-issue actions from COM-1778);
  - on a vulnerability's page.
- Pick one or more systems. "New asset…" is in the picker, as in COM-1775.
- Each system gets its own vulnerability on the **same issue**, so it shows under that issue row.
  - It copies the title, kind, description, CVEs, CVSS, recommendation and severity.
  - Its owner and fix-by date are set as for a new record. The fix-by date counts from the day the system was added.
- A system that already records that issue is refused, with a link to the vulnerability that has it.
- For pen-test issues, the added systems are part of the finding's retest, the same as the systems chosen at confirm.

### 2. Move… (one vulnerability)
- On the vulnerability page, "Move…" replaces "Move to a system…". It goes to:
  - **another system**, or
  - **company-wide** (no single system), or
  - from company-wide **onto a system**.
- A reason is required. The vulnerability keeps its reference, history, comments, owner, fix-by date and state.
- No limits on direction or how often. It works in any state, and a closed one can be moved to correct the record.
- The only refusal: the destination already records the same issue. Show a link to that vulnerability. The same applies to company-wide: only one company-wide entry per issue.
- The history shows "Moved from X to Y" with the reason, in screen words. So does the activity log.
- **Scanners and feeds:** a vulnerability moved off a system the scanner reports remembers where it came from. A later sighting of that issue on the old system goes to the moved vulnerability, so no new one is created. The page says so ("Moved from X; X's sightings still come here"). To stop a scanner's sightings landing on the wrong system, fix the target's matching; Move doesn't change it.
- The COM-1776 rule that scanners never *create* company-wide vulnerabilities still applies.

### 3. Polaris
- `vulnerabilities_add_system`: issue or vulnerability, system ids.
- `vulnerabilities_move`: vulnerability, to a system id or company-wide, reason. It replaces `vulnerabilities_move_to_system`.
- Both are say-before-you-do changes and are logged as the person via Polaris.

### 4. Bulk
- Whole-issue bulk actions are unchanged.
- "Move…" in bulk is out of scope.

## Records
- Amends ADR 0129: one vulnerability per system still holds, but a vulnerability can now move between systems and company-wide.
- Amends COM-1776's "no move back to company-wide".
- Update the Vulnerabilities help text and the Polaris instructions.

## On the chain
New and changed API: add-system endpoint, and the move endpoint takes "company-wide" and any system. Possibly a column recording where a moved vulnerability came from, for sightings. So it goes on the chain.

## Done when
- From an issue row, adding two systems puts both under that issue row. The issue's open/total updates.
- An issue without a CVE (hand-recorded or pen test) can gain a system later and stays one row.
- A vulnerability on the wrong system moves to the right one with a reason. Its reference, history, comments, owner and fix-by date are unchanged. Nothing is left logged in error.
- A system vulnerability can move to company-wide and back again, more than once.
- Moving onto a system that already has the issue is refused, with a link.
- A scanner sighting on the old system after a move updates the moved vulnerability and creates no new one.
- Polaris does both, on staging, as the test admin in E2E Test Company.
- The history and activity log read in screen words.