---
id: 01M7BH0MYJ8E4YV801DQR8A8B3
created: 2026-11-13T22:38:53.906586Z
updated: 2026-11-13T22:38:53.906586Z
type: memo
title: Compass comparison / Eramba
project: 01KXGC5PTGYHV30VM3E78G76S1
---
Comparison of Eramba (open and enterprise GRC) against Compass, 2026-11-13, to find candidate future features. Based on Eramba's website and implementation guides (not hands-on), each item checked against the Compass codebase. Companion to "Compass comparison / CISO Assistant".

**Summary:** Eramba is much narrower than CISO Assistant and Compass already covers most of it. Four things are new compared with the CISO Assistant list; five more repeat items already on that list, which is a sign they're widely expected.

## New compared with the CISO Assistant list
1. **Awareness training with quizzes.** A training programme assigned to a group of people: videos (uploaded or YouTube), a disclaimer to accept, policies to acknowledge, and a multiple-choice quiz with a pass mark and an attempt limit. Runs once or repeats on a schedule, with invitations and reminders. Each person ends up Compliant, Not compliant or Missed, with a completion % per round. Compass's Attestations cover only the "read and acknowledge a policy" part. Enterprise-only in Eramba.
2. **Questionnaires to internal people.** Any questionnaire loaded and sent to colleagues to answer in a portal (e.g. a department self-assessment, a control owner's check-in). Compass's questionnaires go to vendors, and DDQs are ones customers send us; nothing goes to our own staff.
3. **Status rules and notifications you define yourself.** An administrator writes rules like "a risk whose review is overdue shows amber and emails its owner", emails any saved list or report to a team on a schedule, or sends a notification to another system. Compass's warnings and emails are built in per area; scheduled reports exist only in Access Control.
4. **More flexible risk scoring and treatment rules.** Separate impact scales (financial, reputational, regulatory) instead of one impact score; a choice of adding or multiplying likelihood and impact; rules per way of handling a risk (e.g. "Mitigate needs at least one control and one policy linked"). Compass has risk appetite but one fixed way of scoring, and nothing enforces what a treatment must include.

## Also in CISO Assistant, so on both lists
- **Automation on events** — logic runs when a record is created, changed or changes status (CISO #9).
- **Custom fields, tabs and form layouts** on every area (CISO #18).
- **A report builder** — reports built from chart widgets for an area or a single record, emailed on a schedule (overlaps CISO #6).
- **CSV import into any area**, used heavily when getting started (CISO #20).
- **Ready-made NIS2 and DORA content** (CISO #5 and #17; parked in Compass).

## Already in Compass
Policy management with reviews and attestation; control testing and upkeep tasks (the Security Assurance Plan and control checks); compliance against requirements with exceptions and projects; asset, vendor and business-process risks; exceptions, audit findings, initiatives, incidents and business continuity plans with tests; privacy data flows (lawful basis, retention, international transfers); automated access reviews (recertification); the AI assistant over MCP.

## Takeaway
- Add to the shortlist: **awareness training (1)** — ISO 27001 and SOC 2 both expect proof of training, and Compass already has the attestation half — and **internal questionnaires (2)**.
- Across both comparisons, the strongest repeated signals are self-service configuration (automation, custom fields, notifications) and a report and dashboard builder; both competitors have them.

## Sources
- https://www.eramba.org
- https://www.eramba.org/learning
- https://www.eramba.org/learning/courses/79 (Risk Management)
- https://www.eramba.org/learning/courses/87 (Compliance Management)
- https://www.eramba.org/learning/courses/97 (Awareness Programs)