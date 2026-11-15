---
id: 01M7F9C7EHTE60HSB2WDCTC4E7
created: 2026-11-15T09:42:22.417357Z
updated: 2026-11-15T10:57:58.472307Z
type: task
title: Collected checks stop reading through Access Control's Microsoft 365 and AD connections, and existing ones move to the read-only sources
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1840
sprint: spsp226
blocked_by:
- 01M7F9BCSDAHHXAF5SW66GZK72
- 01M7F9BN7NFN72MEH93PZHJRKT
- 01M7F9BXGRXPAXD7R8XTXJZPBD
assignee: steve
label:
- improvement
priority: medium
task_status: active
---
## What happened

This follows from the ADR on read-only evidence. Today, Polaris's design reads and collected checks can use the Microsoft 365 connection (platform `graph` in `core/collection/core_reads.py`, offered by `available_sources` in `core/collection/runner.py`) and AD with Access Control's account. Once the read-only Microsoft Graph integration and the read-only AD account exist, the read-write connections should no longer be used for evidence.

## What people see

- **Polaris no longer offers Microsoft 365 through Access Control's connection** when it designs or changes a check.
  - Microsoft 365 evidence comes only from the read-only Microsoft Graph integration.
  - AD evidence comes only from the read-only account.
  - If neither is set up, Polaris says what's missing and links to it.
- **Checks already approved that read through the read-write connections keep collecting**, so no evidence is lost. They're flagged:
  - on Checks ▸ Overview: "Reads through Access Control's connection: re-create";
  - on the check's own page;
  - in Polaris's "what's broken".
- **Do something with them ▸ Re-create moves them.** Polaris re-designs each against the read-only source, keeping the check's number, fields, schedule and history (as Re-create does now), and a person approves it on Review.
  - With COM-1835, the Microsoft 365 connection's "What we use it for" ticks are offered as the starting ticks on the Graph integration.
- **Once no check on an install reads through them,** Microsoft 365 and AD disappear from the read-write connections' list of evidence sources for good. Their "What we use it for" tab says it no longer applies and points to the read-only source.

## Done when

- On staging, after the read-only Graph integration and AD account are set up:
  - a new design for a Microsoft 365 control reads only through the Graph integration;
  - an existing check reading Microsoft 365 is flagged, and Re-create moves it with its number and history kept;
  - the same applies for an AD check and the read-only account.
- With no read-only Graph integration, a Microsoft 365 control's design says what's missing instead of using Access Control's connection.
- Backend tests confirm the read-write connections aren't offered or readable for new designs or edits, and that existing ones are flagged. Vitest covers the flag and the Re-create path.
- A note for Steve in the PR on moving production's checks: which checks, and the order to do it in.

**On the chain** (it changes the sources the API offers and adds the flag). Blocked by the ADR task, the read-only Microsoft Graph integration and the read-only AD account.