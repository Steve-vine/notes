---
id: 01KYNB13T7ZZGC7ZJENZXFE187
created: 2026-07-28T21:45:25.575877Z
updated: 2026-07-28T21:45:52.229438Z
type: task
title: third-party entity type + estate linkage for tracked services
project: 01KX671DATY39VW6GWK3M2T3DN
number: 355
sprint: s9cqr80
assignee: steve
label:
- feature
priority: medium
task_status: backlog
---
Tracked third-party services appear in the Estate as first-class entities, linked to the rest of the estate via tags.

**Entity type**
- Add `third-party` (displayed "Third-Party") to `ENTITY_TYPES` (`models.py:201`) + CHECK-swap migration (pattern: `0041_tag_rules` `_swap`, downgrade deletes rows of the new type).
- Update `document_claims._entity_type()` + `repo_claims` coercion so third-party SaaS named in docs/repos lands on the new type instead of `service` (the ADR 0041 "external SaaS a runbook names" case); `tag_dictionary_api` `expected_types`; `connectors/base.py EntityData._type_valid` follows the constant automatically.
- Lifecycle: statuspage reconcile stamps `last_seen_at` on each successful check; decide in the ADR whether `third-party` joins `NEVER_RETIRED_TYPES` (`estate_lifecycle.py`) or relies on stamping (recommend stamping + default window, so a page deleted from the register eventually retires its entities).

**Entity creation/reconcile**
- One entity per tracked service (name = provider + service), created/reconciled by the statuspage System when the tracked set changes; `tags.reconcile_entity_tags(db, statuspage_system_id, {entity_id: entry_tags})` — provenance = the statuspage System; tag rules then pull these entities into groups with zero new graph code. Deregistering a page cleans up its entities' tags slice.

**Frontend**
- `EstatePage.tsx` `ENTITY_TYPES` mirror; `EntityGraphView.tsx` `TYPE_ICON` (pick an icon, e.g. IconCloud); type lists in `TagDictionaryCard.tsx`, `SystemDetailPage.tsx`, `EntityDetailPage.tsx` — label "Third-Party". Entity detail links back to the status page entry.

**Acceptance**: registering a page with tracked services + tags creates Third-Party entities visible in Estate list + graph with correct icon; tags visible with statuspage provenance; a tag rule matching the entry's tags pulls the entities into its group; entity detail links to the page detail.