---
id: 01M84ET3T8HHZCZM29RBKTWADA
created: 2026-11-23T15:01:23.400229Z
updated: 2026-11-23T19:36:29.592433Z
type: task
title: The register entry picker finds entries by the start of their ID ("UOB-")
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2109
sprint: ssj8zkq
comments:
- id: 01M84KFJN334ZGAMTBF5RV2TEY
  author: Steve Vine
  at: 2026-11-23T16:23:01.027763Z
  text: |-
    Fixed and merged to main: PR #2104 (f6abe2fd5). No migration or API change. Not on staging yet.

    What people see:
    - In the entry picker, "UOB-" lists that register's entries, and "UOB-1" lists UOB-1, UOB-10 and so on, in number order. Lower case works.
    - A full ID and a word of the title still work.
    - The Entries list's own search is unchanged.

    Decision for Steve to check: the picker needs all three letters of the prefix. "UOB" lists the register, but "UO" searches titles only, so a short title word like "IT" doesn't list a whole register whose prefix starts with those letters. It shows the first 20 matches, and typing more narrows them.

    Tested against real Postgres: prefix, number order and lower case; a Restricted register's entries never offered to someone who can't open it, including by prefix; a per-company picker keeps to its company. CI green.

    Not yet checked on staging: that comes with the re-test.
- id: 01M84N7F7C4EMMXXGM5Q4M1BX2
  author: Steve Vine
  at: 2026-11-23T16:53:32.524494Z
  text: |-
    Pre-UAT on staging f6abe2fd5: PASSED.

    Accounts: E2E Admin A, and E2E Viewer (made an editor of UOB for this test; it can't open the Restricted registers). E2E Test Company. Steps: on UOB-2, Add link ▸ Entry in a register ▸ E2E UAT 122 Obligations, then typed each search into Find entries. UOB has entries 1 to 12; UOB-5 is archived.

    - "UOB-" lists the register's entries, and "UOB-1" lists UOB-1, UOB-10 and so on: PASSED.
      - "UOB-" and "UOB": UOB-1, 3, 4, 6, 7, 8, 9, 10, 11, 12, in number order. UOB-2 (this entry) and archived UOB-5 are rightly left out.
      - "UOB-1": UOB-1, UOB-10, UOB-11, UOB-12.
      - "UOB-12": UOB-12 only. A title word, "GDPR": UOB-1.
    - Lower case works too: PASSED. "uob-" gives the same list as "UOB-". "uob-1" and "Uob-1" give UOB-1, 10, 11, 12. "gdpr" gives UOB-1.
    - "UO": offers nothing, as the fix's comment says it should (all three letters of the prefix are needed, and no title here contains "uo"). "uo" is the same.
    - A Restricted register's entries are never offered to someone who can't open it: PASSED. As E2E Viewer, the picker's register list holds only E2E browser tests register, E2E UAT 122 Obligations and Legal, regulatory and contractual obligations: neither Restricted register appears. Asking the picker's own search directly for "URS-", "URS-1" and "UPA-" in those registers came back not found, with no entries.

    Screenshots: ~/compass-uat/sprint-122/COM-2109/
assignee: steve
label:
- bug
priority: low
task_status: done
---
Sprint "Registers - Phase 2". Found in the pre-UAT pass of COM-2088 on staging e2248892e (23 Nov 2026).

## The problem
On an entry's Links, Add link ▸ Entry in a register, after choosing a register, typing "UOB-" offers nothing. A full ID or a word of the title works.

## What people see
- Typing the start of an ID ("UOB", "UOB-", "UOB-1") offers the entries whose IDs start with it, in number order.
- A full ID and a word of the title still work.
- The picker still offers only entries the person can see, under the company rules.

## Done when
- "UOB-" lists that register's entries, and "UOB-1" lists UOB-1, UOB-10 and so on.
- Lower case works too.
- A Restricted register's entries are never offered to someone who can't open it.

No migration expected.