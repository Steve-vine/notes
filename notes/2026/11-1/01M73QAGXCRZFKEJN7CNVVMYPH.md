---
id: 01M73QAGXCRZFKEJN7CNVVMYPH
created: 2026-11-10T21:55:13.452229Z
updated: 2026-11-10T21:58:50.437184Z
type: task
title: 'Ask Polaris to set up a feed: from the service''s documentation it proposes the reads, the mapping and what closes a record, with a preview of the records it would create, for a person to approve'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1702
sprint: sep79bz
blocked_by:
- 01M73Q8M80365XPSJR7G8BG302
assignee: steve
label:
- feature
priority: medium
task_status: todo
---
Part of ADR 0145 (COM-1695). It's the same pattern as Polaris designing a check (ADR 0142 §2, §9): Polaris proposes, and a person approves.

**Chain:** on the chain — API

## What the person sees

- On a Collection integration, **Ask Polaris to feed…** with a choice of Vulnerabilities, Inventory or Secrets, and optionally a line saying what to bring in ("Dependabot alerts", "API tokens").
- Polaris reads the service's documentation (its docs link and any page it finds from there), tries reads against the company's accounts, and proposes one or more feeds. Each proposal has:
  - the reads;
  - the mapping, slot by slot, with the reason for any slot it leaves empty;
  - the closing rule, and why;
  - a **preview** of the records it would create, from a real read.
- Or it answers that the service **can't feed this area**, and why. If the reason is a capability the configuration lacks ("the alerts are only listed per repository"), it names the capability. Those answers are kept and listed for Steve (sprint sj4f1kj uses them to decide what to build next).
- The proposals land as feeds **Waiting for approval** (COM-1697). Approving is the area manager's own act, on screen.
- **Ask Polaris to check this feed** on a held or broken feed: Polaris compares the latest read with the approved mapping and proposes a corrected mapping, or says the change is genuine (e.g. "you fixed 200 alerts last week").
- What it says follows ADR 0142's cost amendment: what will happen, never what it costs.

## Done when

- New Polaris job kinds `define_feed` and `revalidate_feed`, limited to their kind's tools (read a public page, try a read, fill in the proposal). They change nothing until approved.
- Tested with a fake model and a fake service: a proposal round-trips into a Waiting-for-approval feed; "can't feed" answers are stored with the missing capability; the job stays within spend limits.
- The proposal never contains a key. Polaris never sees one (ADR 0142 §8).

## Notes

- `core/collection/polaris_design.py`, `polaris_revalidate.py` and `core/polaris/job_kinds.py` are the models to follow.
- Give Polaris the area's shape and the mapping language's documentation as its contract, so its output is checked against the same schema the form uses.