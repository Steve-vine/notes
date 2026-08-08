---
id: 01KZ3Q984VYH0PYFXPE8SD6Q8Q
created: 2026-08-03T11:48:57.115925Z
updated: 2026-08-08T09:07:16.024298Z
type: task
title: 'Pack lifecycle: update, remove, State-toggle conformance'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 507
sprint: syte7bx
comments:
- id: 01KZG7V99KGMTFYZ3QEAMRVFBS
  author: Steve Vine
  at: 2026-08-08T08:29:18.515838Z
  text: |-
    Done — PR #543 (branch feature/ise-507-pack-lifecycle, stacked on #542).

    **Removal now stands integrations down instead of refusing.** ISE-501 refused to uninstall while any Integration existed; that was the cautious read and the wrong one. It made removal a manual clean-up job, and a pack you can't remove without first deleting its integrations is a pack whose removal costs you the estate history attached to them. Standing down is right because of what it does *not* do: the Integrations survive, switched off with `last_sync_error` explaining why (silence would be indistinguishable from a broken source — ADR 0072 §4), and their entities **age out through the ordinary lifecycle** rather than being torn down. Retirement is a judgement the lifecycle already makes well, and re-installing inside that window puts everything back. Disabling a pack's Type does the same, since the effect is identical.

    **Pack version provenance.** `Connector.provenance()` joins the base contract — empty for a built-in (its behaviour *is* the released image, already recorded by the deployment) and `{pack, pack_version}` for a pack, which can be replaced between two syncs with no release. It lands in the sync audit record. Without it, "which mapping produced this entity?" has no answer once the document has moved on. Declared on the base class rather than duck-typed so `sync` can call it unconditionally and a new connector can't forget to have one.

    **⚠️ And the part worth your attention: checking pack conformance found a gap that was NOT pack-specific.** ADR 0072 §2 asks for two gates — the dispatch query filters, the unit of work guards. In the shared evidence path only the first existed:

    - listing evidence sources filters on `enabled` ✅
    - **fetching** evidence loads the system by id and never re-checked it ❌

    So a switched-off integration stayed readable to any caller already holding its id — from an earlier listing, from an incident, or from a model that guessed — on both the AI tool surface and MCP. That's exactly the shape §2 was written to prevent, and it affected every connector, not just packs. Fixed with one helper used by both surfaces, degrading with a reason rather than raising so a caller can say *why* a source went quiet.

    Tests: 4 lifecycle unit, 7 toggle-conformance regressions, 3 new integration tests (stand-down on removal, stand-down on disable, re-install restores the Type). UI copy updated too — the tooltips still promised the old refusal, so they now say that switching a pack off reaches its integrations, with the count.

    Brief gains "Updating and removing a pack" and a "The State toggle" section so an author knows a pack obeys the toggle exactly as a built-in does, with the dry run as the single stated exception.
assignee: steve
label: null
priority: medium
task_status: done
---
Updating a pack to a new version re-validates and takes effect on the next sync; removing a pack disables its instances cleanly (entities age out via normal estate lifecycle, never torn down). ADR 0072 conformance: pack-driven sync/detection/evidence all gate on `System.enabled` with the standard regression-test pattern. Includes the pack-version audit trail.