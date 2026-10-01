---
id: 01M3T2J621VAZV8RR9GBKG6TX1
created: 2026-09-30T21:12:09.025834Z
updated: 2026-10-01T09:18:50.244909Z
type: task
title: Staging's AD connection runs on Kerberos, and the sprint's AD smoke test goes ahead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 820
sprint: sme8esk
blocked_by:
- 01M3T2J0776H4TM32KJ3TGSJMR
assignee: steve
label:
- chore
priority: high
task_status: active
---
Part of the on-premises AD sprint (Kerberos, ADR in COM-816).

Staging's domain controllers (mpwxdc01/02.moneypenny.local) have no LDAPS certificate and the domain has no CA, so every AD smoke test since batch 2 (COM-777..785) has been waiting. Kerberos needs no change on the DCs, which unblocks it.

## Steps

1. **Steve:** in Twingate, add TCP 88 and TCP 389 to the resource for mpwxdc01/02 (636 can stay).
2. Deploy to staging. On the AD card, choose **Kerberos**, list the DCs by their full names, and run **Test connection**.
3. Choose **Hybrid** through the setup preview (COM-785).
4. **Steve's smoke test**, the one outstanding from batches 2 and 3:
   - Compass reads AD, and each hybrid person appears once.
   - A joiner is created in a managed OU.
   - A group change is made in AD.
   - A leaver is disabled.
   - A change made directly in AD is spotted.

## Notes (technical)

- If Test connection reports clock skew, compare the g5 node's time source with the DCs' (w32tm) before changing anything in Compass.
- Check pod restarts after the deploy. The worker image grows with the Kerberos libraries, and the staging overlay pins resources (the memory on the staging overlay).

**Done when:** Test connection succeeds on staging with Kerberos against mpwxdc01/02, the health badge and System status are green, and Steve has smoke-tested the list above.