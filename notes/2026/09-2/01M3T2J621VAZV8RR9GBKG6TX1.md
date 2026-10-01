---
id: 01M3T2J621VAZV8RR9GBKG6TX1
created: 2026-09-30T21:12:09.025834Z
updated: 2026-10-01T09:27:35.062231Z
type: task
title: Staging's AD connection runs on Kerberos, and the sprint's AD smoke test goes ahead
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 820
sprint: sme8esk
blocked_by:
- 01M3T2J0776H4TM32KJ3TGSJMR
comments:
- id: 01M3VCGN2K4TCB59JMADRGAWA8
  author: Steve Vine
  at: 2026-10-01T09:25:19.059254Z
  text: "Ready for staging: COM-816..819 are merged (main d7bd47d), built and green. I'm deploying to staging now, and the deploy will be confirmed in a follow-up comment.\n\n**Checked beforehand:**\n- **Staging has no AD connection saved yet** (and the setup is still *Entra ID only*), so you fill in the card from scratch. With Kerberos, no certificate is needed.\n- **Clock:** staging runs on the single node g5, which is NTP-synchronised. Kerberos only needs the DCs within 5 minutes of it.\n- **Nothing else rides along:** staging was at 4f6c1bc, so this deploy ships only the four Kerberos commits.\n\n**Your steps:**\n1. **Twingate:** add **TCP 88** and **TCP 389** to the resource for mpwxdc01/02 (636 can stay).\n2. **Admin ▸ Integrations ▸ Active Directory:**\n   - Connection security: **Kerberos**\n   - Domain: `moneypenny.local`\n   - Domain controllers: `mpwxdc01.moneypenny.local` and `mpwxdc02.moneypenny.local`, one per line, full names\n   - Service account: as `MONEYPENNY\\name` or `name@moneypenny.local`, plus its password\n   \n   Save, then press **Test connection**. Expect *Connected to moneypenny.local through mpwxdc01… with Kerberos*. If it says something else, the message says what's wrong:\n   - port 88 unreachable → Twingate\n   - clock off by N minutes\n   - account refused\n3. **Directory setup → Hybrid**, through the preview (COM-785).\n4. **The AD smoke test outstanding since batch 2:**\n   - AD is read, and each hybrid person appears once.\n   - A joiner is created in a managed OU (tick the OUs first; they need the delegated rights).\n   - A group change is made in AD.\n   - A leaver is disabled.\n   - A change made directly in AD is spotted."
- id: 01M3VCMSWPYV1SPNTNP9JE6P03
  author: Steve Vine
  at: 2026-10-01T09:27:35.062075Z
  text: |-
    **Deployed to staging:** d7bd47d (`staging-20261001-0925`), with the deploy and smoke check green.
    - The API, worker, beat and frontend are on the new images, with no restarts. The worker is ready and the Twingate sidecar is running.
    - Database migration 0218 (the LDAPS/Kerberos setting) is applied.

    Over to you for the steps in the comment above. Twingate ports 88/389 come first, then the AD card with Kerberos, then Test connection.
assignee: steve
label:
- chore
priority: high
task_status: review
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