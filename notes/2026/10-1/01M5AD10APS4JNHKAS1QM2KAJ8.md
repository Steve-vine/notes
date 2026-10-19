---
id: 01M5AD10APS4JNHKAS1QM2KAJ8
created: 2026-10-19T15:38:33.174649Z
updated: 2026-10-19T15:38:33.174649Z
type: task
title: Notifications list only what applies — Impact records how many people and where they live, and each notification rule says when it applies
label: feature
assignee: steve
priority: high
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1120
---
Sprint 76 follow-up. Requested by Steve smoke-testing staging, 2026-10-19. Blocked by the page layout task (COM-1117), which makes **Impact** the card these fields go in. Builds on notifications (COM-1071) and the breach assessment (COM-1070).

## Today

Every Privacy incident lists all seven Privacy notification rules: the ICO, the UK people affected, and five HIPAA ones. Customer contract is added for Privacy and Security. The handler marks each sent or not required by hand, even when it plainly can't apply, e.g. HIPAA rules for a UK-only breach, or the HHS 500+ and the under-500 log on the same incident.

## What people see

### On the incident: Impact

Beside **People affected**:

- **Number of people affected**: one number, **estimated** or **confirmed**. Today the count is asked twice, once in Involved and again as "estimated / validated" in the breach section; this makes it one answer, shown in both places.
- **Where they live**: UK, EU, US, elsewhere (tick any), or Not known yet.
- **Most in any one US state** (asked only when US is ticked): a number, or "More than 500 in one state? Yes / No / Not known".
- **Whose data it is** (asked only for Privacy incidents): ours / held for a customer / held for a covered entity under a business associate agreement.

The breach section's answers already in place are used too: **UK GDPR risk to people**, **Protected health information involved**, and the **HIPAA conclusion**.

### On the Notifications card

- Rules that can't apply show as **Doesn't apply**, greyed, with the reason in plain words, e.g. "Doesn't apply: no one affected lives in the US" or "Doesn't apply: fewer than 500 people affected". They need no decision and don't hold up closing.
- A handler can still **Apply anyway** with a reason, e.g. a contract or a regulator's request. It then becomes a normal row with its deadline.
- **Unknown means it applies.** Until a fact is answered, every rule that might apply stays listed, so nothing is missed through an empty field.
- As the facts change, the list updates. A row already **sent** or **decided not required** is never changed automatically. If the facts now say it doesn't apply, it gets a note to check.
- Deadlines, Actions and the warning emails count only the rules that apply.

### In Admin ▸ Rubrics: when each rule applies

Each notification rule gains **Applies only when** beside its categories. Pick any of:
- where people live (UK / EU / US);
- number of people affected (at least / fewer than);
- more than 500 in one US state;
- UK GDPR risk (a risk or higher / a high risk);
- protected health information involved;
- HIPAA conclusion is "Breach — notify";
- whose data it is.

The shipped rules get these filled in:

| Rule | Applies only when |
|---|---|
| UK GDPR — tell the ICO | Lives in UK; GDPR risk is a risk or higher |
| UK GDPR — tell the people affected | Lives in UK; GDPR risk is a high risk |
| HIPAA — tell the individuals | Lives in US; health information involved; conclusion is Breach — notify |
| HIPAA — tell HHS (500 or more) | as above, and 500 or more people |
| HIPAA — HHS yearly log (under 500) | as above, and fewer than 500 people |
| HIPAA — tell the media | as above, and more than 500 in one state |
| HIPAA — business associate tells the covered entity | Health information involved; held for a covered entity |
| Customer contract | Held for a customer |

Rules an admin has edited keep their edits; the conditions are added only where the rule is still as shipped. Every change is a new revision, as today.

## My calls (Steve to confirm)

- **Where people live** stands in for which law applies. In law it also turns on where the company is established, and whether it's a HIPAA covered entity or business associate. A per-company setting ("subject to UK GDPR / HIPAA") could narrow it further. Left out for now; say if you want it.
- **EU** is offered as a place, though no EU rule ships. An admin could add an EU GDPR rule (lead supervisory authority, 72 hours) using it.
- The number used is the **confirmed** count when there is one, otherwise the estimate.

## Notes (technical)

- New incident facts: `people_affected` (unify with the breach section's estimated/validated counts, plus a confirmed flag; migrate existing values: validated else estimated), `people_locations` (array), `max_in_one_us_state` / `over_500_in_one_state`, `data_held_for`.
- Obligation conditions: a JSON column or a small conditions table on `incident_notification_obligations` and its revisions. Evaluate in `core/incident_notifications.py` `sync_incident_notifications`, re-run whenever these facts, the breach answers or the categories change.
- A row's state gains `not_applicable_auto` (reason text) and an override. Decided rows are never auto-changed.
- Seed update by migration for rows still at revision 1 (append-only; raw SQL; new enums created explicitly).
- Actions source and the deadline-warning beat skip auto-not-applicable rows. The closure check treats them as settled. Exports show them with their reason.
- Assistant: `incidents_set_people_affected` takes the new facts; `incidents_list_notifications` shows Doesn't apply with the reason; an apply-anyway tool. Run every `test_assistant*.py`.
- ADR 0116 §7 amendment: triggering is categories **and** conditions.

**Done when:** on staging, a Privacy incident affecting 40 people in the UK only, at a GDPR risk, lists the ICO as due in 72 hours, and every HIPAA rule as Doesn't apply with its reason. Changing it to 600 people in the US with health information and a Breach — notify conclusion brings in HHS (500+) and the individuals, and leaves the yearly log as Doesn't apply.