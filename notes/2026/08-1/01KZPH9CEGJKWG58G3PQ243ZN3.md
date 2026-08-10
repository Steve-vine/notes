---
id: 01KZPH9CEGJKWG58G3PQ243ZN3
created: 2026-08-10T19:09:44.272517Z
updated: 2026-08-10T22:54:23.448044Z
type: task
title: A signal's env tag never reaches ISE's vocabulary — findings and entities hold disjoint environment values
project: 01KX671DATY39VW6GWK3M2T3DN
number: 649
sprint: s1rgnyx
assignee: steve
label:
- improvement
priority: medium
task_status: todo
---
Deferred out of [ISE-638] 2026-08-10 so it would not creep into that fix. An alert that knows it is `env:Test` is triaged exactly like one from production.

**The environment is already on the signal.** The DataDog connector puts the monitor's own tags, its group scope and its query scope into `FindingData.tags` (`connectors/datadog.py:1513`), and `tags.reconcile_finding_tags` links them. The Kora synthetic's finding genuinely carries `env:Test`, `env:UK`, `service:openanswer`. Nothing has to be plumbed — it is there.

**But signal env and entity env are disjoint vocabularies.** `env` values on staging, 2026-08-10:

| Value | On findings | On entities |
| --- | --- | --- |
| `Production` | 21 | 0 |
| `UK` | 13 | 0 |
| `Test` | 4 | 0 |
| `Depricated` | 2 | 0 |
| `US` | 2 | 0 |
| `Development` | 1 | 0 |
| `mgnt` | 0 | 75 |
| `staging` | 0 | 67 |
| `production` | 0 | 42 |
| `bstr` | 0 | 4 |
| `prod` | 0 | 3 |
| `test` | 0 | 1 |

**Not one value appears on both sides.** So you cannot filter incidents by environment, cannot compare a signal's environment to its entity's, and an agent reading a signal's tags learns a string ISE's own dictionary does not recognise.

**Why — and it is a deliberate rule, not a bug.** `tag_dictionary.Dictionary.resolve` canonicalises a value case-insensitively, *but only for DIMENSIONLESS values*: `Dictionary.values` holds those, while dimensioned ones live in `dim_values` and are left alone, because "without knowing the entity's sibling tags there is no honest answer" (ISE-472, ADR 0073 §7 — `prod` beside `app:` is application `prod`; beside `project:` it is infrastructure `production`).

**Every `env` value in the dictionary is dimensioned** — application: `demo`, `dev`, `prod`, `test`; infrastructure: `bstr`, `mgnt`, `production`, `sandbox`, `staging`. So env is never canonicalised on ingest, and a signal — which has no `app:`/`project:` sibling tag to place it — has no dimension at all. `Production` stays `Production` forever.

**Two further problems the data shows:**
- **`env:UK` / `env:US` are not environments** — 15 findings where the source uses the `env` key for region. `env` is `value_mode='defined'`, a closed vocabulary, and these are in no list.
- **`env:Depricated`** — a source-side misspelling ingested verbatim.

**And nothing reports it.** `tag_compliance` measures `EntityTag` only (`tag_compliance.py:120`) — its three categories (missing / alias-resolved / **unlisted**) describe these signal values precisely, but findings are never assessed, so the hygiene surface shows none of it.

**The decision to settle: what dimension does a signal's environment belong to?**

1. **Inherit it from the linked entity.** Once [ISE-638]/[ISE-639] give signals an entity, the entity's sibling tags decide the dimension and `resolve_dimensioned` does the rest. Composes with work already queued, and is the only option that gives an honest answer — but it leaves unlinked signals uncanonicalised.
2. **Never canonicalise a signal's env; display it raw and clearly source-attributed.** Honest, cheap, and keeps ISE from asserting a dimension it cannot know — but the two vocabularies stay disjoint, so triage still cannot use it.
3. **Resolve against both dimensions and flag a conflict** via `dimension_conflict`, routing the ambiguous ones to the proposals queue. Most complete; most machinery.

Option 1 is the natural fit given batch 1, with option 2 as the fallback for anything still unlinked. Whatever is chosen, **`env:UK` should not be silently accepted as an environment** — that is a `defined` key carrying an unlisted value, which is exactly what the compliance surface exists to name.

**Acceptance**: a Test alert is distinguishable from a Production one in the queue and to an agent; signal env values are either canonicalised or explicitly marked unresolvable; unlisted values on signals appear on the tag-hygiene surface instead of nowhere.