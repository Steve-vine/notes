---
id: 01KZ6CA633EJXGSVQDFFYE50JH
created: 2026-08-04T12:34:56.739507Z
updated: 2026-08-05T12:02:45.69466Z
type: task
title: Estate reset permanently orphans registered documents — kept content, severed tags, nothing restores them
project: 01KX671DATY39VW6GWK3M2T3DN
number: 533
order: 2.0
sprint: skxht3g
comments:
- id: 01KZ6SKFD6J2V6HWK6T66T2JWR
  author: Steve Vine
  at: 2026-08-04T16:27:12.678766Z
  text: |-
    PR #458 — https://github.com/Steve-vine/ise/pull/458 (migration 0093)

    Built as specified: `registered_labels` on all three register rows, written through `set_tags` (the one choke point both the register path and the manual tag-edit API pass through, so no caller can forget), and re-applied at the end of `reset_collected_data` inside the same transaction.

    ISE-397's line is preserved rather than reopened — a tag no register carries stays gone, pinned by a test. The reset moment is still clean; the register tags are re-authored from configuration a moment later. The data_reset module docstring carries the amendment as the ticket asked.

    Migration 0093 backfills from today's links. Data-path tested per [[ise-migration-data-paths-need-populated-tests]]: to 0092, seed a key:value tag AND a valueless one plus an untagged registration, then upgrade. Used COALESCE not concatenation — `key || ':' || value` is NULL for a bare tag, so `legacy` would have vanished silently.

    Two additions beyond the letter of the ticket, both cheap and both about the failure being invisible: the reset reports `register_tags_restored` separately from the deletion counts (folding it into "deleted" would misreport it), and the Danger Zone toast says the registered documents stay connected — that is the reassurance the screen owes someone who just pressed Nuke.

    The DoD test drives the REAL reset path and was verified to fail with the restore stubbed out.

    STILL NEEDS YOU: the live estate's 4 documents were untagged by the 2026-08-03 wipe before this existed, so the backfill has nothing to copy for them. Re-tag them once in the UI (app:chinwag / app:kora) after deploy and they persist through every future reset. I did not touch production data.
assignee: steve
label: null
priority: medium
task_status: done
---
Live-found 2026-08-04: Steve asked Assist and an incident chat about "Chinwag-V2 deployment" — a registered Confluence document sitting in the register with full content — and the AI correctly reported knowing nothing. Root cause chain:

1. Documents reach AI context (and entity detail pages) **only** via the tag join — `documents_for_entities` (`documents.py:304`, ADR 0042 §3) matches document tags against entity tags through the canonical dictionary.
2. The Nuke deletes the whole tag pool **including register tags** — the deliberate ISE-397 line (`data_reset.py` module docstring: kept-register tags were holding the pool open after reset, so the pool now goes and register tag links cascade with it).
3. **Nothing ever restores document tags.** `set_tags` for documents runs in exactly two places: `register()` (`documents.py:187`) and the manual tag-edit API (`documents_api.py:230`). The hourly scrape sweep refreshes content and summaries but never tags. Same pattern holds for the other registers (`repos.py:209`, `status_pages.py:159` — registration-time and manual only).

Net: after every reset, every registered document/repo/status-page keeps its content but is silently unlinked from the entire estate, forever, until a human re-tags it by hand. The "kept" side of the reset line is functionally crippled in a way nothing surfaces — the register screens look fine, and the failure only shows up as an AI that has never heard of your runbooks.

## Fix

Persist the authored labels on the register row itself (e.g. `Document.registered_labels`, JSONB, written by `register()` and the tag-edit API as the source of truth) and **re-apply them through `set_tags` after a reset** — either directly at the end of `reset_collected_data`, or lazily on each register's next sweep. Same treatment for repos and status pages, which share the `set_tags` shape.

This does not conflict with ISE-397's rationale: the problem then was *pool rows surviving* the wipe via kept links; re-creating the tags *after* the wipe leaves the reset moment clean and simply treats authored register tags as what they are — configuration, like the registers themselves. The reset docstring's line should be amended to record the new behaviour.

Migration required (new column ×3 registers, or one shared shape). Data path test per [[ise-migration-data-paths-need-populated-tests]]: registered + tagged rows at N-1, reset, verify links re-materialise.

## Also in scope — the immediate repair

The live estate's 4 documents (3 × Chinwag-V2, 1 × Kora) are currently untagged from the 2026-08-03 wipe. Whoever takes this task: after the fix, backfill their labels (`app:chinwag` / `app:kora` to match the live entities) — or Steve re-tags manually in the UI beforehand and the task verifies the tags then survive the next reset.

## Definition of done

Register a document with tags → Nuke → the document's tags are back (immediately or by next sweep) and it surfaces on matching entities' detail pages and in AI investigation context, verified by a test that runs the actual reset path.
