---
id: 01M61Y7GH2VVNHPZQ3GDRSPDAD
created: 2026-10-28T19:01:44.098245Z
updated: 2026-10-29T08:13:36.582132Z
type: task
title: Request an exception from the control itself — one form asks why, what compensates, who owns it, who approves and until when, and sends it for approval
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1402
sprint: s81z16q
blocked_by:
- 01M61Y6JF41HKD3AJSN4QSMJZ8
comments:
- id: 01M62KG3YBB17C2ATK1N5NMCJZ
  author: Steve Vine
  at: 2026-10-29T01:13:26.219425Z
  text: |-
    Done — PR #1420 merged.

    What's in it:
    - "Request an exception" on the control's Risks card (control page and Assessments panel), for an in-scope control that isn't Implemented and has no exception yet. It needs risk write.
    - One form: Why · Compensating controls (optional) · a new risk or an existing one · Owner · Approver · Until. A new risk has its title pre-filled "Exception: ACC.8 …", a category, and residual likelihood and impact in the rubric's words, with an appetite line under them. Owner defaults to the control's owner. Approver must be someone who can accept risks. Until defaults to the acceptance period.
    - Refused plainly: "Over appetite for Operational — this can't be accepted; treat it instead" (the form says so too and won't send). Also refused: an approver who can't accept risks (so the requester, if they can't); "ACC.8 is met — it doesn't need an exception"; out of scope; a control as its own compensation.
    - Sent: the control reads "Exception awaiting approval". The approver's Action reads "Approve acceptance of R-14 — exception to ACC.8 · …". Approved → "Excepted until". Declined → the pill goes, and whoever asked gets "The exception to ACC.8 (R-14) was declined: <reason>" in Actions.
    - Renew within 30 days of running out: on the control's Risks card, and next to the approved acceptance in the risk's Treatment plans. Same form, pre-filled with the risk, the why and the approver. A new acceptance goes for approval; the old one stands until it runs out.

    My calls:
    - The endpoint is POST /exceptions with the company and control in the body, not POST /assessments/{id}/exception, because a control nobody has assessed can be excepted too.
    - One acceptance waiting at a time per risk (409 on a second).
    - The "declined" Action lasts two weeks, or until they ask again.
    - Inherent scores on a new risk default to the residual you enter.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint 94, Control Exceptions (ADR 0130, COM-1398). Builds on COM-1399 and COM-1400. Without this, an exception takes four screens (raise a risk, score it, link the control, add an accept treatment).

## What people see

- **Request an exception** on an in-scope control that isn't Implemented — on the assessment panel's Risks card and on the control's page.
- **One form:**
  - **Why** — the justification (becomes the accept treatment's rationale);
  - **Compensating controls** — optional, picked from the control library;
  - **Risk** — either **a new risk** (title pre-filled "Exception: ACC.8 <control name>", category, residual likelihood and impact on the rubric's words, with the appetite line shown) or **an existing risk** of this company;
  - **Owner** — defaults to the control's owner;
  - **Approver** — someone holding *Approve risk assessments and accept risks*;
  - **Until** — defaults to the acceptance period in Settings (12 months).
- **Refused, plainly:** residual over appetite ("Over appetite for Operational — this can't be accepted; treat it instead"); approver = the requester if they don't hold the permission; out of scope; Implemented.
- **Sent:** the control shows **Exception awaiting approval**; the approver gets "Approve acceptance of R-14" in Actions as today, its text naming the control. Approved → **Excepted until**. Declined → the pill goes, and the requester gets a line saying so.
- **Renew** on an excepted control (and on the risk's acceptance card) within 30 days of running out: the same form, pre-filled from the current one, a new acceptance sent for approval. The old one stands until it runs out.

## Who can do what

Requesting needs risk write (the same as adding an accept treatment today). Approving is unchanged; nobody approves their own.

## Notes (technical)

- One endpoint creating (or reusing) the risk, the exception link, the mitigating links and the accept treatment in one transaction — e.g. `POST /assessments/{id}/exception` — reusing `risk_treatments` validation (appetite, approver permission, expiry after today) rather than restating it.
- Renew = a new accept plan on the same risk; `standing_acceptance` already takes the latest standing one.

**Chain:** on the chain (API).

**Done when:** on staging, Steve requests an exception to a Partial control from its panel, a second person approves it, and the control shows Excepted until; Renew sends a new one.