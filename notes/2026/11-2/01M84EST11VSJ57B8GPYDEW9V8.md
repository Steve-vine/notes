---
id: 01M84EST11VSJ57B8GPYDEW9V8
created: 2026-11-23T15:01:13.377307Z
updated: 2026-11-23T17:44:11.184566Z
type: task
title: An audit's trail shows a Restricted register by name to people who can open it
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2108
sprint: ssj8zkq
comments:
- id: 01M84KFC32ZYFZP0Z1J5TRRZBX
  author: Steve Vine
  at: 2026-11-23T16:22:54.306072Z
  text: |-
    Fixed and merged to main: PR #2101 (3fb60ff0b). No migration or API change. Not on staging yet.

    What people see:
    - The register's owner, its editors and administrators read its name on a request's History and the audit's Activity, for providing, taking off and withdrawing.
    - Someone who can't open it reads only "a Restricted register". This is decided when the line is read, so it follows a person being added or removed as an editor.
    - The auditor portal doesn't read this trail, so an auditor can't get a register's name through it. The auditor's own Viewed and Downloaded lines follow the same rule for Compass users.

    Worth knowing:
    1. Lines written before this fix never recorded which register they meant, so they keep the hidden wording even for the owner, including the UAT-4 line in the screenshot. To check this task, provide a register again. COM-2094 isn't in any release, so production has no such lines.
    2. Typed text isn't caught: a Restricted register's name typed into a withdrawal reason is shown as written.
    3. Possible follow-up, not changed: someone with no right to view registers still sees an unrestricted register's name in the trail, while the request itself tells them "A register you can't open".

    Tested against real Postgres: owner, editor and administrator on both views; someone who can't open it; a person added and removed as editor; a line from before it was restricted. Two existing assertions had the old behaviour built in and were corrected. CI green.

    Not yet checked on staging: that comes with the re-test.
- id: 01M84N77JDMTDX9J6G58RAVGK9
  author: Steve Vine
  at: 2026-11-23T16:53:24.685311Z
  text: |-
    Pre-UAT on staging f6abe2fd5: PASSED on a request's History. On the audit's Activity tab it PASSED for an administrator, and the other readers COULDN'T be checked.

    Setup: AUD-5 is cancelled and won't take a new register, so I made internal audit AUD-6 "E2E UAT 122 Retest Audit", with E2E Viewer, Analyst and Assessor as named auditors so they could read it. For the test, E2E UAT 122 Restricted (URS) was owned by E2E Assessor with E2E Analyst as editor, and E2E Admin A was only an administrator on it. As Admin A I provided URS to RT-1, took it off and provided it again. I provided the unrestricted Parties register (UPA) to RT-2, then made UPA Restricted.

    - The owner, an editor and an administrator see the name on both:
      - Request History: PASSED. Assessor (owner), Analyst (editor) and Admin A (administrator) each read "Added E2E UAT 122 Restricted (URS), as at 23 Nov 2026 to request RT-1" and "Took E2E UAT 122 Restricted (URS)… off request RT-1".
      - Audit's Activity: PASSED for Admin A, with the same lines by name. COULDN'T CHECK for the owner and editor: their accounts have no Activity tab on the audit.
    - Someone who can't open it sees only "A Restricted register" on both:
      - Request History: PASSED. E2E Viewer reads "Added a Restricted register, as at 23 Nov 2026 to request RT-1" and "Took a Restricted register…", and the request's evidence list reads "A Restricted register". No name or prefix anywhere on the request.
      - Audit's Activity: COULDN'T CHECK. Only the Admin role has that tab among the test accounts, and an administrator can open every register.
    - A line written before the register was restricted follows the same rule: PASSED on request History. RT-2's line, written while UPA was unrestricted, reads by name for Admin A (its owner) and "Added a Restricted register…" for Viewer, Analyst and Assessor. Admin A's Activity tab also shows it by name.
    - Withdrawing: COULDN'T CHECK. It needs an auditor to open the register, and the Auditor portal is off.

    Small defect (low): the "as at" date inside these lines ignores the reader's date format. E2E Assessor, on US dates, sees the line's time as "Nov 23, 2026, 4:46 pm" but its text as "as at 23 Nov 2026". See 06-assessor-owner-request-history.png.

    Screenshots: ~/compass-uat/sprint-122/COM-2108/
- id: 01M84R46NG9M1EZTNED3ENA51K
  author: Steve Vine
  at: 2026-11-23T17:44:11.184357Z
  text: |-
    Pre-UAT on staging f6abe2fd5 (Auditor portal): COULDN'T CHECK.

    - The withdrawing line, on a request's History and the audit's Activity: COULDN'T CHECK. A register can only be withdrawn after an auditor has opened it, and the Auditor portal stayed off because Claude Code's permission check refused switching it on. Details are on COM-2095.

    Ready for a re-run: Restricted register UAR is provided on AUD-7 request AQ-4, which E2E Viewer owns, so Viewer can read that request's History as someone who can't open the register. Nothing has been withdrawn.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Sprint "Registers - Phase 2". Found in the pre-UAT pass of COM-2104 on staging e2248892e (23 Nov 2026). Screenshot: `~/compass-uat/sprint-122/COM-2104/03-admin-request-history.png`.

## The problem
Admin A owns a Restricted register and provides it to an audit request. The request's History and the audit's Activity tab read "Added a Restricted register, as at 23 Nov 2026 to request UAT-4", while the same request lists the register by name just above. The hiding from COM-2104 is applied to people who can open the register as well as those who can't.

## What people see
- Someone who can open the register (its owner, editors, an administrator) reads the line in full, with the register's name.
- Someone who can't still reads "A Restricted register".
- This holds on a request's History and the audit's Activity, and for providing, removing and withdrawing it.

## Done when
- The owner, an editor and an administrator see the register's name on both.
- Someone who can't open it sees only "A Restricted register" on both.
- A line written before the register was restricted follows the same rule.

No migration or API change expected.