---
id: 01M6EKMBGM4NTB8WA0GV76AXKA
created: 2026-11-02T17:06:38.228401Z
updated: 2026-11-04T07:45:33.778756Z
type: task
title: The Security Feed module — one shared feed of items merged from many sources, read on a schedule and kept in full; Modules ▸ Security Feed with its tabs, two new permissions, and each source's health on the Sources tab
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1511
sprint: s6xh9g1
blocked_by:
- 01M6EKKGVQYRGNX1RQQAHFFHCR
comments:
- id: 01M6EQBF0X9HBT44HGFSD5ZVGT
  author: Steve Vine
  at: 2026-11-02T18:11:41.213122Z
  text: |-
    Done: PR #1528 merged (65107502), migration 0757.

    What's there:
    - Modules ▸ Security Feed (after Vulnerabilities) is gated on View security feed. It has a Feed tab and a Sources tab; Watch lists and Products arrive with COM-1519 and COM-1518. Until anything is read, the Feed tab says what will appear and from which sources.
    - Sources: each source's status (On, Off, Needs setting up, Loading history, Problem), last read, items (total and last 7 days) and the last problem in plain words. Managers have Read now and an on/off switch.
    - Underneath: one item per issue, merged from every source; each source's words kept as its own; the worst severity wins; history records rescores, known-exploited, products, versions and rejection, and marks the item Updated. Reads checkpoint and resume, so a long first load survives a restart. Nothing is ever deleted.
    - Two permissions, View and Manage security feed, go to the built-in Admin only.

    My calls:
    - Each built-in source is a file of its own, registered automatically, so the later source tasks touch nothing shared.
    - Creating the built-in sources' rows is kept out of the activity log; switching one on or off is logged.

    To test on staging (after the sprint deploys): Security Feed shows its tabs, Sources lists the sources with counts, and a reader without View security feed doesn't see the module.
- id: 01M6G9X1NZ5J4MJVXCVCHVBHFX
  author: Steve Vine
  at: 2026-11-03T08:55:06.174882Z
  text: |-
    Pre-UAT (staging, 2026-11-03, E2E Test Company): **Passed**, with two fixes logged.

    Steps and what I saw:
    - As E2E Admin A: Modules ▸ Security Feed shows the tabs Feed, Watch lists, Products and Sources. Sources has one row per source: name, description, kind, status (On / Not read yet / Loading history), last read, items and "in the last 7 days", with Read now on each row.
    - Before any source had read, the Feed said what would appear.
    - One item per issue: CVE-2025-68686 carries CISA's words and NVD's link on one page. The Cisco IOS XE advisory is its own page, linked to its CVEs.
    - As E2E Viewer and E2E Analyst (no Security Feed rights): there's no menu entry, and the address shows "You need permission to view the security feed".

    Found:
    - "In the last 7 days" counted the whole 12-month history load ("Microsoft: 8,179 in the last 7 days"). Fixed in COM-1538.
    - After the deploy, a background worker process ran out of memory and kept restarting. Fixed in COM-1532, now 5/5 on staging.

    Screenshots: ~/compass-uat/sprint-102/COM-1511/
assignee: steve
label:
- feature
priority: high
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

- **Modules ▸ Security Feed** follows the company picker. Its tabs are:
  - **Feed** (COM-1521);
  - **Watch lists** (COM-1519);
  - **Products** (COM-1518);
  - **Sources**.

  The module shows only to people with *View security feed*.
- **Sources tab:** one row per source, giving name, kind (Government, CVEs, Vendor, Added by an admin), on or off, last read, items in the last 7 days, items in total, and the last error in plain words ("NVD refused the request: rate limit — add an API key on Integrations"). **Read now** sits on each row, for a manager.
- Sources arrive with their own tasks (COM-1512 to COM-1516). This task delivers the frame and one test source that the suite uses.
- Until a source has read anything, the Feed tab says what will appear and which sources are switched on.

## How items behave

- **One item per issue.** An item is one CVE, wherever it came from. NVD, CISA and Microsoft reporting CVE-2026-1234 is **one** item with **three sources**. An advisory with no CVE is its own item.
- A vendor advisory that covers five CVEs is linked to each of the five items, and also kept as an advisory of its own with its own page.
- Each source's words (title, description, severity, links, dates) are kept **as that source's**: untrusted, plain text, never editable (ADR 0099). When sources disagree on severity, the item shows the highest and lists each source's own.
- When a source revises an item (new score, more versions, added to the known-exploited list), the item shows **Updated**, with what changed and when.
- **Nothing is deleted.** A source switched off keeps everything it brought.

## Who can do what

- *View security feed*: see the module, the feed, items and sources.
- *Manage security feed*: switch sources on or off, read now, plus the management in later tasks.
- Built-in Admin gets both. The starter roles stay frozen.

## Notes (technical)

Tables:
- **Global**, not company-scoped: `feed_items`, `feed_item_sources` (per-source payload JSONB, first and last seen, the source's reference) and `feed_sources`.
- **Company-scoped** state arrives in COM-1520.
- `feed_items` holds the merged view: CVE id or advisory key, title, published and updated dates, the highest severity, a CVSS score and vector, `known_exploited` and a full-text `tsvector`.

The source framework:
- a registry of readers, each with an interval and an idempotent `read(since)`, run by Celery Beat;
- every Celery task gets a `TASK_LABELS` entry, or the unit suite fails;
- readers take IDs, are JSON-only, and are safe to re-run;
- a first-run backfill window is set per source (12 months, ADR 0139 §3).

Mind the staging overlay pins (Beat 350Mi, worker). Check worker memory once NVD's backfill runs in COM-1513.

Plain text throughout: strip HTML from source text on the way in. Keep links as structured `{url, label, kind}`.

Add the two permissions to `core/permissions.py` and a permission group "Security Feed". The Modules menu entry follows the screen conventions.

Browser smoke: register the new screens and tabs for the test accounts.

**Chain:** on the chain (migration + API).

**Done when:** on staging, as admin in E2E Test Company:
- Security Feed shows its four tabs;
- the test source's items appear on the Sources tab's counts;
- a reader without *View security feed* doesn't see the module.