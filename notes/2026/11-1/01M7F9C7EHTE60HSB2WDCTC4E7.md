---
id: 01M7F9C7EHTE60HSB2WDCTC4E7
created: 2026-11-15T09:42:22.417357Z
updated: 2026-11-15T12:47:08.646767Z
type: task
title: Collected checks stop reading through Access Control's Microsoft 365 and AD connections, and existing ones move to the read-only sources
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1840
sprint: spsp226
blocked_by:
- 01M7F9BCSDAHHXAF5SW66GZK72
- 01M7F9BN7NFN72MEH93PZHJRKT
- 01M7F9BXGRXPAXD7R8XTXJZPBD
comments:
- id: 01M7FKYHCH8YFTNREM65TKF2PS
  author: Steve Vine
  at: 2026-11-15T12:47:08.177483Z
  text: "Built and merged — PR #1842 (c05eabde). It changes the API. No migration.\n\nWhat you'll see:\n- **New designs and edits can't read Microsoft 365 through Access Control's connection.** Polaris isn't offered it, and a read through it is refused whether it's being tried, proposed, approved, edited or changed through Polaris. Polaris says the evidence comes from a read-only Microsoft Graph Collection integration and links to setting one up. If there isn't one yet, it says what's missing instead.\n- **Checks already approved keep collecting**, on schedule, Collect now and re-runs, so no evidence is lost. They're flagged **\"Reads through Access Control's connection: re-create\"** in three places:\n  - on Checks ▸ Overview under Needs attention (which also feeds Polaris's \"what's broken\");\n  - on the check's own page;\n  - on its card on the control's Evidence tab, with a Re-create button.\n  \n  The only other change allowed on such a check is re-ordering its columns.\n- **Re-create moves the check in place.** Polaris re-designs it against the Graph integration, keeping its CHK number, captures, history, schedule, rule, kept fields and column names, and a person approves it on Review. If Microsoft 365's \"What we use it for\" ticks aren't yet on the Graph integration, the Review card offers \"Use the same ticks for Microsoft Graph\".\n- **Once no check reads through it, it's gone for good.** Until then, Microsoft 365's \"What we use it for\" tab says it's no longer a source and how many checks still read through it. Afterwards, it says \"This no longer applies\" and points to the Graph integration.\n- **AD needs no move.** Since COM-1839, every AD read already uses the read-only account, existing checks included. Overview now says \"Active Directory needs a read-only account for evidence\", with a link, when it isn't set.\n- ADR 0154 is amended with all of this.\n\nDecisions:\n- A normal Re-create still gives a new CHK number and replaces the old check, as before. Only a move off Access Control's connection keeps the number and history, as this task asks.\n- Switched-off checks still count as \"reading through it\", so Microsoft 365 stays on the list until they're switched on and moved, or left off for good.\n- A batch Re-create on Checks still re-designs every check on the selected controls. To move one check, use Re-create on its page.\n\n**Moving production's checks** (the full note, with a query that lists every check, is in the PR):\n1. Set up the Graph integration with an account for each company that has Microsoft 365 checks, and the AD read-only account.\n2. Find the checks: Overview ▸ \"Reads through Access Control's connection: re-create\" ▸ Show.\n3. Tick what the Graph integration is used for, or accept the offer on the first Review card.\n4. Re-create the checks with a pass/fail rule first, then the evidence-only ones, and approve each on Review.\n5. You're done when Microsoft 365's \"What we use it for\" tab says it no longer applies.\n\nTests: backend tests for refusing new reads, flagging old checks, Re-create keeping the number and the \"gone for good\" state. Vitest for the flag, Re-create, the starting ticks and both states of the Microsoft 365 tab.\n\nThe Done-when checks on staging need the Graph app registration and the AD domain user from you (see COM-1838 / COM-1839)."
assignee: steve
label:
- improvement
priority: medium
task_status: review
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