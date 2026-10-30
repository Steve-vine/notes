---
id: 01M62B7Y0F46SBJ3ZJMRENSH1C
created: 2026-10-28T22:49:09.391948Z
updated: 2026-10-30T08:16:01.32865Z
type: task
title: Polaris reviews each clause — flags what conflicts with what we actually do, what's outside or within our positions, what differs from our standard contract and what's a new commitment, quoting the clause, citing the Compass record and suggesting a response
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1439
sprint: s2v7d6y
blocked_by:
- 01M62B7CAZYNSEQBTTAMMN829S
comments:
- id: 01M64V06M8HCADKDZ8FDKGW4H8
  author: Steve Vine
  at: 2026-10-29T22:03:02.152144Z
  text: |-
    Done — PR #1457 merged (b1c8f8e0), migration 0743.

    What's there:
    - **Review with Polaris:** a button in the review header, and one beside each section heading. It opens Polaris's window with the request in the prompt box; nothing is sent by itself.
    - **How Polaris works through the clauses:** for each clause it fetches what the clause is judged against, then records flags worst first:
      - **What it's judged against:**
        - the topic's approved position (a draft is never used; Polaris is told "position not yet approved");
        - our standard contract's clauses on the same thing;
        - what we do, from incident rules (with this company's changes), recovery targets, data locations, subprocessors, the plan's tests and audits, and certificates;
        - related controls, policies and evidence (the DDQ catalogue).
      - **Only what the person can see:** each source is included only if the person running Polaris may see that module. Polaris works as them.
    - **Each flag shows:**
      - its pill: red for conflict and outside our positions, amber for within fallback and differs from standard, blue for new commitment, grey for can't tell, green for matches;
      - the quoted words, highlighted in the clause;
      - what we do, citing the record (linked where it has a page);
      - the suggested comment and wording, and the position and standard clause it rests on.
      - "History" shows earlier runs, which are kept when a clause is re-run.
    - **What Compass checks, rather than taking Polaris's word:**
      - a position flag needs an approved position;
      - a cited record must exist and be this company's, and is named from the record itself;
      - a "differs" flag must name one of our standard clauses;
      - Can't tell must say what it needs.
    - **Counts:** the Reviews register's flag counts and a position's "Used in" / "Last used" now fill in.

    My calls:
    - **Topic corrections:** Polaris can correct a clause's topic when it flags it; the clause shows "set by Polaris".
    - **Clauses with a person:** from COM-1440, Polaris only flags clauses that are still with Polaris, and its Can't tell passes the clause to the review's owner.

    To test on staging: run it against a real client MSA. Expect the breach-notice clause flagged as a conflict citing our incident rule, a liability cap outside our position (once that position is approved), and at least one Matches.
- id: 01M658J7F4BWS3AF3X4F92V2EN
  author: Steve Vine
  at: 2026-10-30T02:00:04.324425Z
  text: |-
    Pre-UAT pass (Claude, staging): **Couldn't check**, because it needs Polaris's AI provider.

    Seen: "Review with Polaris" opens Polaris with the request already in the prompt box, and nothing is sent until you send it.

    For Steve, on CR-1 "E2E 20261030 ACME MSA 2027" in E2E Test Company, run Review with Polaris and check:
    - 12.2's 24-hour breach notice is flagged as a conflict, citing our incident rule;
    - 11.1's unlimited liability is flagged outside the approved Limitation of liability position;
    - at least one clause matches.

    Screenshot: ~/compass-uat/sprint-98/COM-1439/.
assignee: steve
label:
- feature
priority: high
task_status: done
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