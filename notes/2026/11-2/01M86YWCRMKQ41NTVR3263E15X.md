---
id: 01M86YWCRMKQ41NTVR3263E15X
created: 2026-11-24T14:20:44.180791Z
updated: 2026-11-25T09:17:31.811111Z
type: task
title: Two privacy tests stop failing at random when a generated id happens to contain the value they look for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2141
sprint: szwetpq
comments:
- id: 01M87WE0MJ52Q4E5955A2A0Y0W
  author: Steve Vine
  at: 2026-11-24T22:57:10.290433Z
  text: |-
    Merged: #2147, 4a08f1dda, 24 Nov 22:56 GMT. Tests only. Goes into v0.27.0. The "07700" retention check was fixed in COM-2059 (#2145).

    - AD evidence account test: the password is now a long, distinctive one rather than "pw", and the test also decrypts the stored value back to it.
    - Found in the sweep: the Trust Centre sign-in test searched for a random 6-digit code in every row of two tables, the same failure mode. It now checks the stored hashes directly and looks for the code only in that visitor's own rows, skipping ids and times.

    Checked by breaking the code on purpose (password stored unencrypted; code stored as plain digits) and seeing each test fail, then 15 runs each under load. Two remaining search-in-blob checks have negligible odds (about 1 in 100 million and 1 in a billion per run) and were left alone.
assignee: steve
label:
- tech_debt
priority: low
task_status: done
---
Flaky tests seen on PRs in the Registers and Backup sprints. Outside both sprints.

**Chain:** independent (tests only).

**What happens**

Two tests check that a sensitive value is gone by searching for a short string anywhere in stored text, and random ids sometimes contain it:
- `tests/test_dsr_retention.py::test_a_request_past_its_period_is_cleared_and_keeps_its_facts` checks that "07700" (a test phone number) isn't in a request's history. On PR #2128 an activity-log id contained "…0770036322ff" and the test failed (CI run 45406841586).
- `tests/test_ad_evidence_account.py` (~line 382) checks that the two-letter password "pw" isn't in an encrypted value, and random ciphertext sometimes contains it (seen on #2095 in sprint 122).

**Done when**

- Each test uses a test value long and distinctive enough that no id or ciphertext can contain it by chance, for example a full fake phone number and a long password. Or it checks the specific fields instead of the whole stored text.
- Each still fails if the value really isn't cleared or encrypted. Mutation-check that.