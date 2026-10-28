---
id: 01M61Y7GH2VVNHPZQ3GDRSPDAD
created: 2026-10-28T19:01:44.098245Z
updated: 2026-10-28T19:01:44.098245Z
type: task
title: Request an exception from the control itself — one form asks why, what compensates, who owns it, who approves and until when, and sends it for approval
priority: high
task_status: todo
assignee: steve
label: feature
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1402
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