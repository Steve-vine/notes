---
id: 01M4C61EN0Y3H4JB73G6S3XHYW
created: 2026-10-07T21:59:14.848733Z
updated: 2026-10-07T22:28:01.762825Z
type: task
title: The managed-OU rights check survives a deleted sample account — and keeps the rights warnings up to date
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 860
sprint: sme8esk
comments:
- id: 01M4C7P4DE8M8GGNR9H6Y6W3JH
  author: Steve Vine
  at: 2026-10-07T22:28:01.070762Z
  text: |-
    Done: PR #865, merged to main (3c92fb2). Not deployed to staging yet.

    **This was worse than stale warnings.** The rights check runs inside the AD health check. So since the test account was deleted, **Test connection** on the AD card has also said *"The connection check failed unexpectedly"*, even though the connection itself works.

    **What changed:**
    - To check Compass's rights in an OU, Compass asks AD about an account inside it. If that account has been deleted since Compass last read AD, Compass now moves on to the next one (up to 5).
    - If none are left, the check records "nothing to ask about", not "missing rights".
    - It only picks accounts Compass hasn't already seen disappear.
    - A problem checking one OU is shown against that OU, and the others are still checked.
    - The rights check can no longer turn a working connection's Test connection into a failure.

    **Proven by tests:**
    - the first sample deleted, so the next is used
    - every sample deleted, and the check still completes
    - a failing rights check, and Test connection still says *Connected*
    - against the Samba DC, a missing account is passed over

    **Smoke test (after deploy):** on the AD card, Test connection says *Connected … with Kerberos* again, and the managed OUs show a fresh "rights checked" time.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
Found investigating ACR-56 (staging, 2026-10-07).

## What happened

The check of Compass's rights on each managed OU (COM-778) runs with the AD health check. It has failed on every run since a test account was deleted from AD. It asks AD about a *sample account* in the OU, AD answers "no such object", and the error isn't caught. So the whole check fails and the OU rights warnings on the AD card stop refreshing (15 failures in Celery's results on 2026-10-07).

## What should happen

An account that has gone since Compass last read AD isn't a problem: the check uses another account in the OU, or checks the OU without one. The warnings stay current. A real problem checking one OU is shown against that OU, not by failing the whole check.

## Notes (technical)

- `core/ad_scope.py::ou_rights` → `_effective(connection, sample_user_dn, "allowedAttributesEffective")` raises `LDAPNoSuchObjectResult`. The sample is taken from the mirror, which can be up to one AD read stale.
- Treat no-such-object as "no sample": try the next account, or fall back to the OU-level rights. Wrap any other LDAP error per OU into that OU's message.
- Test (fake_ad): the sample DN is deleted between the read and the check → the check completes and that OU's rights are still reported.

**Done when:** the rights check completes with a deleted sample account, in CI, merged to main.