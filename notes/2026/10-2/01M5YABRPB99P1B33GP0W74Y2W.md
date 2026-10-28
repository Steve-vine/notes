---
id: 01M5YABRPB99P1B33GP0W74Y2W
created: 2026-10-27T09:16:48.715525Z
updated: 2026-10-28T02:10:23.422199Z
type: task
title: A retest report closes what was fixed — linked to the original pen test, Polaris proposes which earlier findings are resolved, still open or new, and a person confirms
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1380
sprint: ssp4evc
blocked_by:
- 01M5YABFJ99MSWN9RDY3ZFKNDY
comments:
- id: 01M604BNBR7XPQQY45V8GZ5FHK
  author: Steve Vine
  at: 2026-10-28T02:10:22.712538Z
  text: |-
    Built — PR #1396, merged to main (no migration: COM-1378 carried the columns).

    What's there:
    - Import ▸ Pen-test report has "This is a retest of…", offering the company's confirmed reports.
    - The retest's page lists each earlier finding (one per vulnerability the original recorded) with Resolved, Still open or Not retested, plus any new findings added as usual.
      - Earlier findings can't be edited or dropped, only given an outcome.
      - Polaris proposes the outcomes when it reads, matching against the earlier findings it's given. Otherwise you set them.
    - Confirm needs an outcome for every earlier finding. Then:
      - Resolved → Fixed, confirmed by the retest. One you had already marked fixed gets "Confirmed fixed by retest" on its timeline.
      - Still open → stays open, reopening if it had been fixed, and the retest is added as its latest pen-test sighting.
      - Not retested → nothing changes.
      - New findings → recorded as in a first report.
    - The original report's page lists its retests and how many findings each resolved.
    - A retest must follow a report whose findings were confirmed.

    Who can do what: work vulnerabilities.

    To try on staging: confirm a first report, then bring in its retest with "This is a retest of…", set the outcomes and confirm. The resolved ones show Fixed and the original lists the retest.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 92, Vulnerabilities - Scanner sources (ADR in COM-1374). Builds on COM-1379.

Pen-test findings have no scanner to confirm a fix. The tester's retest is the confirmation.

## What people see

- **Import ▸ Pen-test report** has **"This is a retest of…"**, choosing an earlier pen-test import.
- **The retest's import page lists each of the original's findings**, each with:
  - a proposal: **Resolved**, **Still open** or **Not retested**;
  - a page reference;
  - plus any **new** findings the retest raised.
  - Polaris fills the proposals when it's on; otherwise a person sets them.
- **On confirm:**
  - Resolved findings become **Fixed — confirmed by retest**. A person's earlier "fixed, waiting to confirm" turns confirmed;
  - Still open stays open and gains a sighting from the retest;
  - Not retested changes nothing;
  - new findings are recorded as in the first import.
- **The original import page** shows its retests and how many findings each resolved.

## Who can do what

Work vulnerabilities.

## Notes (technical)

- A retest is an import with a parent import. The proposal rows reference the original findings' vulnerabilities.
- Polaris gets the original findings as context for the read, so it can match them.

**Chain:** on the chain (migration + API).

**Done when:** a retest closes the resolved findings, keeps the open ones open and records new ones, all after a person's confirm.