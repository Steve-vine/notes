---
id: 01KXGWGMXNSTRSN1JSF7K8SCXE
created: 2026-07-14T17:59:06.421142136Z
updated: 2026-07-14T18:05:44.878950782Z
type: task
title: 'Content kinds foundation: source→kind migration, Kind column, Domain filter'
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 128
sprint: ssdk92z
label: null
---
Foundation for the four-kind content library (M23). Everything else in the milestone builds on this.

**Model / API**

* Replace `ContentSource` (`authored`/`imported`) with `kind`: `uploaded | templated | linked | managed`.
* Migration: rename the column/enum; existing `authored` rows → `templated` (`imported` is dead post-ADR 0031).
* Expose `kind` on `ContentItemOut`; accept it on create (default `templated` for backwards compatibility). List endpoint gains a `domain` filter param if not already present.
* New nullable per-kind columns land with their own issues, not here.

**Frontend (Content list)**

* **Kind column** (pill, styled like Status) between Type and Status.
* **Domain filter** Select alongside the existing Type/Status filters; selecting a domain shows all content for that domain.

**ADR**

* New ADR **0035 — Content kinds** recording the taxonomy, the shared-governance principle (title/domain/type/status/reviewers/cadence/review records uniform across kinds), and per-kind behaviour. ADR 0034 covers the M365 half only.

---
*Migrated from Linear [DEV-755](https://linear.app/stevevine/issue/DEV-755/content-kinds-foundation-sourcekind-migration-kind-column-domain) · created 2026-07-02 · completed 2026-07-02*