---
id: 01M62B7Y0F46SBJ3ZJMRENSH1C
created: 2026-10-28T22:49:09.391948Z
updated: 2026-10-28T22:50:30.80715Z
type: task
title: Polaris reviews each clause — flags what conflicts with what we actually do, what's outside or within our positions, what differs from our standard contract and what's a new commitment, quoting the clause, citing the Compass record and suggesting a response
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1439
sprint: s2v7d6y
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 98, Contract Review (ADR 0134, COM-1435).

## What people see

- **Review with Polaris** on a review (or on chosen sections) works every clause assigned to Polaris. Progress shows as it goes, and results appear clause by clause.
- **Each clause gets zero or more flags**, worst first, each with a coloured pill:

| Flag | Means | Judged against |
|---|---|---|
| **Conflicts with what we do** (red) | we'd be promising something Compass shows we don't do | control assessments and their status, policies and standards, incident notification rules and their deadlines, recovery targets (RTO/RPO, BIA once sprint 95 is in), data asset locations, subprocessors (Trust Centre and Vendors), SAP activities and their cadence (pen tests, DR tests), certificates in the Evidence register, check results (sprint 96) |
| **Outside our positions** (red) | beyond the fallback, or in our "never" | the topic's approved position |
| **Within our fallback** (amber) | not our preferred position, but acceptable | the approved position |
| **Differs from our standard contract** (amber) | the clause says something our standard doesn't, or the opposite | the chosen standard contract version, quoting our clause |
| **New commitment** (blue) | we'd be agreeing to do something nothing in Compass tracks | — |
| **Matches** (green) | in line with our position and with what we do | the record it matched |

- **Every flag shows:**
  - the clause words it's about (highlighted in the clause);
  - **what we do**, quoting and linking the record: for example, "Incident rule: tell clients within 72 hours (Incident policy §4.2)", or "IDM.13 MFA: Partially implemented, assessed 3 Sep";
  - **a suggested response** in two parts: a client-facing comment and, where useful, suggested replacement wording, both drawn from the position's wording where there is one.
- **Can't tell** (grey): Polaris says what it would need ("No position on insurance yet", "No data location recorded for the CRM"), and the clause goes to the review's owner.
- **Re-run** a clause or the whole review after a position or a Compass record changes. Earlier flags are kept in the clause's history.

## Who can do what

- Running Polaris needs *Review contracts*, or being the review's owner. It runs with that person's permissions (ADR 0109).
- A flag may cite a record the reader can't open; then they see the citation's name, not the record.

## Notes (technical)

- Polaris works through in-API tools (ADR 0127) that read each source.
  - Reuse the DDQ answer-source finder (`ddq_find_answer_sources` / `core/ddq_answers.py`) for controls, content and evidence.
  - Add readers for incident rules (`core/incident_notifications.py` with the company's overrides), recovery targets (`containers.rto_minutes` / `rpo_minutes`), data asset locations, subprocessors and SAP series.
- Tables: `contract_clause_flags(clause_id, kind, severity, quote_span, our_text, cited_kind, cited_id, response_comment, response_wording, position_version_id, standard_clause_ref, run_id)`, kept per run.
- Positions used must be **Approved** versions. A Draft position is ignored and noted as "position not yet approved".
- A one-review test fixture of a realistic MSA with expected flags runs as an eval, not a unit test (non-deterministic). It isn't a CI gate.

**Chain:** on the chain (migration + API).

**Done when:** on staging, against a real client MSA, Polaris flags the breach-notice clause as conflicting with our incident rule (citing it), flags a liability cap outside our position, and marks at least one clause Matches. Steve agrees with most flags.