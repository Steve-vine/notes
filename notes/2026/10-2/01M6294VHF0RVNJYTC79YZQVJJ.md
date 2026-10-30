---
id: 01M6294VHF0RVNJYTC79YZQVJJ
created: 2026-10-28T22:12:31.407121Z
updated: 2026-10-30T08:01:20.074025Z
type: task
title: 'ADR: continuous control checks — Compass tests what it already reads on a schedule, a failing check raises a gap that closes itself when it passes, the control''s status stays a person''s call; and a "what changed" summary for any period'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1415
sprint: s6j9773
comments:
- id: 01M63C0WYSK4XJD6JH6DMR4VQ7
  author: Steve Vine
  at: 2026-10-29T08:22:01.945374Z
  text: |-
    Done — ADR 0132 written (PR #1432, auto-merge on), plus the Posture ▸ Checks row in the IA brief.

    My calls, listed at the end of the ADR for you to overturn:
    1. Can't tell is grey and does nothing.
    2. A check's gap is due in 30 days (per-company setting).
    3. A cancelled gap isn't raised again until the check has passed in between.
    4. Dormant = no sign-in for 90 days.
    5. The email goes to named people, not a role.
    6. Checks are evidence in the audit pack.
    7. NEW: a control the company hasn't assessed gets no gap — creating an assessment would put it into the figures as Not implemented, which is a check moving posture. The check still shows red on the control with "Assess the control to track this as a gap".
    8. NEW: the directory checks judge the whole directory. It belongs to the install (ADR 0083), and Compass can't yet tell which company each account is in (on staging 1 of 1,258 enabled accounts holds a business role). A company the directory doesn't serve switches them off in Settings.
    9. NEW: check settings (on/off, thresholds) need Record assessments, and live on a Settings tab of Posture ▸ Checks; the email is set up on the Compliance page and needs Run reports. There is no "Manage company settings" permission for Posture.
    10. The cloud-finding → control mapping (KMC.4, CLD.16, BCR.13, VUM.1, VUM.8).

    Also: a control with an in-date exception keeps any open check gap as it is, and raises no new one.
assignee: steve
label:
- brief
priority: high
task_status: done
---
Sprint 96, Continuous Control Checks (ADR 0132).

Write `decisions/0132-continuous-control-checks.md`, and add the Posture ▸ Checks page and Settings ▸ Checks to `brief/information-architecture.md`.

## What it decides

**A check** is a named pass/fail test Compass runs itself, over data it already reads. It has:
- a key and a name ("Everyone has MFA registered");
- the controls it speaks to;
- the integration it needs;
- how often it runs;
- a threshold where one makes sense, such as the number of days before an account counts as dormant.

**The result** is one of three:
- **Passing**;
- **Failing**, with how many items fail and which ones;
- **Can't tell**: the integration isn't connected, a licence or permission is missing, or the data is too old. Can't tell is never a fail, and it never raises or closes a gap. The data rules behind this already exist ("no row is unknown, never no MFA").

**History.** A new result is kept only when the state or the failing count changes, plus one result a day so the trend has points. Results are never edited.

**When a check fails (Steve, 2026-10-28, option 2):**
- Compass raises a gap on the company's assessment of each control the check speaks to. The gap is marked **Raised by Compass check**.
- The gap gets the control's owner on that assessment (or nobody) and a target date from Settings (default 30 days). It goes to Actions like any gap.
- **When the check passes again, Compass closes the gap as Complete**, with "Check passing since <date>".
- **The control's status and maturity never change.** The assessor sees the check and decides.

**A person can still work the gap:**
- They can comment on it, change the owner or move the date.
- If they **cancel** it with a reason, the check stays red on the control, but no new gap is raised until the check passes and then fails again. That stops gap churn.
- Once sprint 94 has landed, a control with an in-date exception raises no gap from its checks. The check still shows, marked "Excepted until …".

**Scope.** Checks run per company. Each company can switch each check off; a switched-off check shows as "Off" and closes the gap it raised, with the reason "Check switched off".

**First checks (this sprint):**
- **Directory:** MFA registered; MFA required by Conditional Access; admin roles have MFA; dormant accounts; leavers' accounts still enabled; how many people hold the top admin roles.
- **Cloud and vulnerabilities:** encryption at rest, public access, backups and out-of-support software, all read from the "Compass checks" findings already in the Vulnerabilities register; no critical or high vulnerability past its fix-by date.

**Later, each as its own check under its integration:** Microsoft Secure Score, Kubernetes cluster settings, backup job results.

**What changed.** The Compliance page gets a summary of what moved in a chosen period, built from the history Compass already keeps: assessment and risk revisions, gaps, acceptances, check results and the nightly snapshots. An optional email sends it to chosen people monthly or quarterly. It is read-only and adds no new records beyond the email settings.

## My calls (for Steve to overturn)

- Can't tell is shown in grey and does nothing.
- The default target date for a check's gap is 30 days.
- A cancelled gap is not re-raised until the check has passed in between.
- Dormant means no sign-in for 90 days, matching the library's wording (IDM.6).
- The email goes to people chosen in Settings, not to a role.
- Checks are evidence in the audit pack, not just on screen.

## Notes (technical)

- Model checks on Evidence of operation (`core/evidence_of_operation.py`): a registry of declared checks, each with an `evaluate(db, company, today, settings) -> CheckOutcome`. Adding one means declaring it there; no screen changes.
- Look up controls by `CoreControl.key`, never the displayed ref (COM-1062). Candidate keys:
  - CRD.3 (IDM.13), CRD.5 (IDM.14), ACC.24 (IDM.6), ACC.5 (IDM.2), ACC.7 (ACC.3);
  - KMC.6 (KMC.4), DBR.1 (BCR.13), s42.CLD.7 (CLD.16), PAM.1 (VUM.1), VUM.4 (VUM.8).
- Gap: add `raised_by_check` (check key) beside `raised_via`. Auto-close goes through the same path as a person closing it, so History and Actions behave as they do today.
- Directory scope: the mirror is one tenant. Give a company's people the same scope Access Control uses for that company (see `membership_provenance.coverage`), and state it in the ADR.

**Chain:** independent (docs only).

**Done when:** the ADR is merged and Steve has read the calls above.