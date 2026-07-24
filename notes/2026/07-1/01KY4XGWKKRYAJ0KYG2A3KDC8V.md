---
id: 01KY4XGWKKRYAJ0KYG2A3KDC8V
created: 2026-07-22T12:41:31.50762Z
updated: 2026-07-24T14:42:59.358883Z
type: task
title: Fix-at-source tag remediation via governed Actions
project: 01KX671DATY39VW6GWK3M2T3DN
number: 210
sprint: s5khymf
comments:
- id: 01KY5W78B7T2AS9FQSN3RYCQTZ
  author: Steve Vine
  at: 2026-07-22T21:38:01.703473Z
  text: |-
    **Done — PR #205** (stacked on #204). On staging as `staging-20260722-2134`.

    **ADR 0043** records the decision. The framing that mattered: ISE mutating a target system was already settled by ADR 0017 — what is new here is that it writes **configuration** rather than running state. Metadata that persists, that other systems key off, and that ISE reads back as a knowledge source. Four rules fall out of that:

    - **Computed, never generated.** Parameters come from the dictionary and the entity's alias in that integration, never from a model. That inverts the reviewer's question from "is this right?" to "do we want this done" — much cheaper to answer well, and it removes a failure mode for no lost capability.
    - **Additive and corrective only.** Set a governed key to its canonical value. No removal, no ungoverned keys, no arbitrary tags — which is exactly what keeps T1 honest, since the prior value is captured and nothing can be destroyed.
    - **Proposed once.** No sweep, no re-proposal after a revert. ISE and a Terraform run taking turns reasserting a label would be worse than either being wrong, and it is precisely what a well-meaning "keep the estate compliant" loop produces.
    - **The source stays the source.** After a retag ISE waits for the next sync to *observe* the new value rather than writing its own expectation into the pool — otherwise its belief would rest on having acted rather than on having seen, which is how a CMDB drifts.

    **Connector actions.** `set_label` (Kubernetes) is a single-key strategic-merge patch — adds or overwrites one label, touches nothing else. `set_host_tag` (DataDog) is read-modify-write **confined to the `users` tag source**; that detail is load-bearing, because DataDog's update replaces a whole source's tag set, so writing the default source would destroy what the agent reports *and* start a fight with the integration reporting it. Both T1.

    **Two bugs my own tests caught while writing them**, both worth knowing about:

    1. The dedup query used `("proposed", "approved")` and missed **`awaiting_approval`** — which is the status a T1 change actually lands in. It would have queued duplicate corrections for exactly the tier this feature produces.
    2. `dictionary.resolve` returns a value unchanged both when it *is* canonical and when the dictionary has no opinion about it. Conflating those told an operator `env:pr0d` was "already the canonical value". Now `pr0d` is refused with advice, which is what ADR 0041 §5 intends — ISE will not guess what it should become.

    **UI:** "Fix in \<integration\>" on the tag drilldown, per entity, shown only where ISE has both a tag-write operation and a write credential. Read-only stays the default, so most estates see no buttons — and an offer ISE cannot honour is worse than no offer. The notification says the change is waiting in Approvals and that nothing has changed yet.

    **To smoke test** you'll need a write credential on DataDog or g5 (Settings → Integrations → Add write credential); without one the buttons are correctly absent. Then: Tags → a non-standard value → drilldown → Fix in… → the change appears in Approvals as T1 with the computed parameters visible.

    Gates: ruff, mypy (270 files), 1052 backend tests (+12), 343 frontend (+3), all four frontend gates green. Three frozen-catalogue guards updated deliberately — two connector tier maps and the AI action-catalogue allow-list.
assignee: steve
label: null
priority: low
task_status: done
---
Future model captured from the Tag Dictionary design (Canon, 2026-07-22) — deliberately unassigned to any sprint.

Today ISE never writes tags back to a source: the compliance report is a work list for humans. The future extension: from a compliance finding ("this host's `env:Prod` should be `env:prod`", "this workload is missing `env`"), ISE *proposes* the correction at the source (retag in DataDog, relabel in Kubernetes) through the governed Actions layer — default-deny, tiered approval, ADR 0017/0021 — so tag hygiene can be remediated from the same screen that surfaces it, with the same approval ceremony as any other infrastructure change.

Prereqs: Tag Dictionary shipped (Sprint 20); connector Actions for tag/label mutation classified in each `action_catalogue()`. Needs its own ADR when picked up (writes to source config are a new action class).