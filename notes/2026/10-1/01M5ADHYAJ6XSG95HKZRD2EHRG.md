---
id: 01M5ADHYAJ6XSG95HKZRD2EHRG
created: 2026-10-19T15:47:48.178329Z
updated: 2026-10-19T20:08:58.922643Z
type: task
title: Four more notification rules ship — law enforcement, the insurer, the card acquirer and the Board — with the incident facts that trigger them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1121
sprint: serbigk
blocked_by:
- 01M5AD10APS4JNHKAS1QM2KAJ8
assignee: steve
label:
- feature
priority: medium
task_status: active
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19. Blocked by COM-1120, which adds the "Applies only when" conditions these rules depend on.

## The new rules

Shipped in Admin ▸ Rubrics ▸ Incident rubric beside the eight existing ones, editable like them:

| Rule | Tell | By | Categories | Applies only when |
|---|---|---|---|---|
| **Law enforcement** | The police, e.g. Action Fraud / Police Scotland in the UK, the FBI (IC3) in the US | 24 hours | All | Criminal activity is known or suspected |
| **Insurer** | The company's insurer, as the policy says | 24 hours | All | Severity is P1 or P2 |
| **Card acquirer** | The acquiring bank (and through it the card schemes), as the merchant agreement says | 24 hours (placeholder) | Privacy, Security | Payment card data is involved |
| **The Board** | The Board of directors | 12 hours | All | Severity is P1 or P2 |

Each comes with "when it applies" and "what to include" wording, like the existing rules:
- **Law enforcement**: say what happened and when, what was taken or damaged, and the evidence held. Record the crime reference number on the notification.
- **Insurer**: the policy number, what happened, the likely cost, and what's been done. Many policies require their incident response firm or approval before spending; check the policy.
- **Card acquirer**: what happened, which card data and how many cards, the systems involved, and what's been contained. Don't change or wipe the affected systems before forensic advice.
- **The Board**: what happened, the severity, the impact, what's being done, and the notifications due.

## New facts on the incident (Impact)

- **Criminal activity?** Yes / Suspected / No / Not known, asked on every incident. E.g. theft, fraud, extortion, unauthorised access.
- **Payment card data involved?** Yes / No, suggested from the data types on the incident (a data type marked as payment card data). The handler confirms it, as with health information today. Asked for Privacy and Security incidents.
- **Severity** is already recorded at triage.

As in COM-1120, a fact not yet answered means the rule applies. A rule whose condition is answered "no" shows as **Doesn't apply**, with the reason.

## Rules

- **Clock for the severity rules.** The Insurer and Board deadlines count from when the incident **became P1 or P2**: at triage, or later if it's raised. An incident raised from P3 to P2 on day 3 gives the Board 12 hours from the raise, not an overdue deadline. If it's later lowered to P3 or P4 before the notification is decided, the rule turns to Doesn't apply.
- The other two count from Company aware, like today's rules.
- The Notifications card, Actions, the warning emails, exports and the closure check treat these exactly as the existing rules.

## My calls (Steve to confirm)

- **These are policy and contract rules, not law.** UK and US law sets no 24-hour duty to tell the police, an insurer or a board. The deadlines are yours, and each rule's wording says so. Card acquirer is set by your merchant agreement and card scheme rules: Mastercard expects 24 hours, Visa "immediately". 24 hours is the placeholder, flagged like Customer contract.
- **The Board is a notification rule.** So telling it is recorded with when, how and by whom, and shows on time or late, like a regulator.
- **Criminal activity** is asked on every incident, not only Security. An outage caused by sabotage, or an AI system used for fraud, is criminal too.

## Notes (technical)

- Recipient kinds: add `law_enforcement`, `insurer`, `payment_acquirer`, `internal_governance` to `incident_recipient_kind` (ALTER TYPE … ADD VALUE, outside a transaction block where Postgres needs it). Labels on screen, in exports and in Overview.
- Conditions (on top of COM-1120's): severity at most P2; criminal activity yes/suspected; card data involved.
- `counted_from` gains `severity_reached` (`incident_deadline_start` enum). Store when the incident first reached the qualifying severity; set at triage and on a severity change event. `refresh_notification_deadlines` recomputes.
- Incident facts: `criminal_activity` enum, `card_data_involved` bool null plus a suggestion from `ControlledDataCategory.payment_card_data`, mirroring `phi_involved` / `health_data_involved` in the breach section.
- Seed migration: four obligations, revision 1, raw SQL, categories by name. Rubric tests pin the count (8 → 12).
- Assistant: the new facts on the impact tools; run every `test_assistant*.py`. Run all `tests/test_incident_*.py`.

**Done when:** on staging, a P2 Availability incident lists the Board (12 hours) and the Insurer (24 hours), counted from its triage. Answering criminal activity "Suspected" adds Law enforcement. A Security incident with a payment card data asset suggests card data involved, and confirming it adds the Card acquirer.