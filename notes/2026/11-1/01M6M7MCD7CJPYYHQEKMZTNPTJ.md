---
id: 01M6M7MCD7CJPYYHQEKMZTNPTJ
created: 2026-11-04T21:32:22.823939Z
updated: 2026-11-05T19:21:28.561047Z
type: task
title: Remove controls' previous references from Compass completely
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1585
sprint: srkxswe
comments:
- id: 01M6MJ80A64NQ1MXBC569YHPSF
  author: Steve Vine
  at: 2026-11-05T00:37:51.5584Z
  text: |-
    Done: PR #1610, merged to main as b69117dc. This one is on the chain: migration 0784.

    What changed: a control has one reference. The old pre-renumbering ref is removed everywhere:
    - the control page no longer shows "was …"
    - the main search, the Library search and Audit evidence search no longer match it, and no result says "(was …)" or "· was …"
    - the controls export loses its Previous ref column
    - Polaris no longer shows it or finds a control by it; "previous ref" is gone from seven tool descriptions
    - renumbering keeps no old ref
    - controls.csv loses its Legacy ID column

    Migration 0784 drops the database column. A downgrade adds it back, but empty: the old values are gone.

    The control's key, which the importer uses to recognise controls, is unchanged. ADR 0059 has an amendment withdrawing §3, which had kept old refs searchable.

    Tested:
    - integration tests show there's no longer a column for an old ref, search never says "was", and Polaris finds nothing by an old ref
    - the tests that counted moved controls now count key ≠ ref, still 191
    - all 3,761 Vitest tests pass
- id: 01M6MKBTM6QDR5MQEBH5248WF8
  author: Steve Vine
  at: 2026-11-05T00:57:25.382387Z
  text: |-
    Pre-UAT: Passed (staging b69117dc, migration 0784 applied, E2E Admin A).

    Seen:
    - INS.3's page header reads "INS.3 Active ESSENTIAL Information Security Governance…" with no "was INS.1".
    - Main search for "INS.1" lists only INS.1 and INS.11–INS.19 as controls, with no "(was …)".
    - The controls export header is "Ref,Title,Domain,Tier,Status,Frameworks,Linked documents", with no Previous ref.
    - The control's API answer no longer has legacy_ref.

    Screenshot: ~/compass-uat/initiatives-improvements/COM-1585/ins3-no-was.png
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Every control carries a "previous reference": its number before the control library was renumbered (e.g. INS.3 "was INS.1"). **Steve (2026-11-04): the old IDs have never been used in Compass and should be removed completely.** They currently confuse search results (COM-1584).

**Wanted behaviour:** a control has one reference, its current one. No screen, export, search or Polaris answer mentions an old number. Renumbering controls in future doesn't start keeping old numbers again.

**Where they show today:**
- The control page shows "was INS.1" beside the reference.
- The Library's control search, the global search (results read "INS.3 (was INS.1)") and Audit evidence search all match on them, and evidence results show "· was …".
- The controls export has a "Previous ref" column.
- Polaris returns `previous_ref` and resolves a control by its old number.
- Renumbering records the outgoing number automatically.

**Done when:** none of the places above shows or matches an old number. Searching "INS.1" anywhere finds INS.1 (and controls starting INS.1), never INS.3. The export has no Previous ref column. Renumbering a control leaves no trace of its old number.

**Implementation:**
- Migration: drop `core_controls.legacy_ref` (append-only, with a downgrade that re-adds it nullable).
- Model `models/core_control.py`.
- Seed `seed/controls.py:193`, and remove the `Legacy ID` column from `data/controls.csv`. Keep `Key`: it's the data key, see the control-key-vs-ref memory.
- `core/control_numbering.py` `record_legacy`.
- API schemas `api/v1/schemas.py` and `audit_schemas.py`. Search in `api/v1/search.py:165/175`, `core/evidence_search.py:132`, `api/v1/audit_search.py` and `api/v1/controls.py` (list query and export `_EXPORT_HEADER`).
- Polaris `assistant/tools/controls.py:67/81` and `common.py:108`.
- Frontend `pages/ControlDetailPage.tsx:214`, `audit/EvidenceSearchResults.tsx:115`, and the test fixtures that set `legacy_ref`.
- Regenerate schema.d.ts. The seed import runs every deploy, so make sure it no longer writes the field.

**On the chain:** migration plus API change. COM-1584 (search ordering) overlaps on `_library_query`; whichever lands second rebases.

Found by Steve while testing Initiatives (2026-11-04).