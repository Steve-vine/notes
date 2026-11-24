---
id: 01M86YWCRMKQ41NTVR3263E15X
created: 2026-11-24T14:20:44.180791Z
updated: 2026-11-24T21:52:13.009765Z
type: task
title: Two privacy tests stop failing at random when a generated id happens to contain the value they look for
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2141
sprint: szwetpq
assignee: steve
label:
- tech_debt
priority: low
task_status: active
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