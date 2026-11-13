---
id: 01M7A5PY8MKEWWDEZJSWS34GTM
created: 2026-11-13T10:02:06.996053Z
updated: 2026-11-13T10:04:28.918061Z
type: task
title: 'Vulnerabilities: add a system to an issue, and move a vulnerability freely between systems and company-wide'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1786
sprint: spsp226
assignee: steve
label:
- improvement
priority: medium
task_status: active
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