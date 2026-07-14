---
id: 01KXGTF3YAHZ2N0VSRJRWS3KV7
created: 2026-07-14T17:23:19.11422034Z
updated: 2026-07-14T17:23:27.629345225Z
type: task
title: Domain identifier (code) + auto-generated control refs
label:
- brief
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 85
sprint: s114vjm
---
M18 follow-up. Give each **domain** a mandatory 3-letter **identifier (code)**, and **auto-generate control refs** from it instead of typing them by hand. Builds on <issue id="535aa687-e944-4c50-a8a9-0d707d49091f" href="https://linear.app/stevevine/issue/DEV-628/backend-editable-domains-and-controls-crud-disable-control-detail-adr">DEV-628</issue>/629 (editable library). Backend + frontend, one PR.

### Behaviour

* **Domain code**: a 3-character identifier (e.g. `ACC` for Access Control). **Mandatory** on create, **unique**, stored **upper-case** (input is upper-cased server-side). Editable on the domain.
* **Control ref auto-generated**: on control create the ref is built as `{domain.code}.{n}`, where `n` = (highest existing control number in that domain) + 1 (e.g. domain `ACC` with `ACC.2…ACC.16` → next is `ACC.17`); first control in a domain → `.1`. The client no longer supplies a ref.

### Backend

- [ ] **Migration 0021**: add `domains.code` `VARCHAR(3)` NOT NULL UNIQUE (indexed). **Backfill** each domain's code from its controls' ref prefix (`split_part(ref,'.',1)`) — verified: all 35 domains already have unique 3-char prefixes (ACC, ASM, …). Down: drop column.
- [ ] **Model/schema**: `Domain.code`; `DomainCreate.code` required (validate `^[A-Za-z]{3}$`, upper-case via validator); `DomainUpdate.code` optional (upper-cased, uniqueness-checked); expose `code` in `DomainOut`.
- [ ] **Control create**: drop `ref` from `CoreControlCreate`; compute it server-side = `{domain.code}.{max_suffix+1}` over the domain's controls (parse the integer after the first dot; ignore non-numeric; consider all rows incl. soft-deleted so a ref is never reused). Keep the generated ref unique (guard).
- [ ] Domain create/update upper-cases `code` and returns 409 on duplicate.
- [ ] **Tests**: domain create requires + upper-cases + uniqueness-409s the code; control create auto-assigns the next ref; sequence holds across several creates and across domains; migration backfill populates all codes.
- [ ] Regenerate OpenAPI schema.

### Frontend

- [ ] **Domain create modal** (`DomainsPage`): add a mandatory **Identifier** field (3 chars, auto-upper-cased, helper text); surface the uniqueness 409.
- [ ] **Domain edit** (`DomainDetailPage`): add the code field (editable, upper-cased); show the code in the domain header/list.
- [ ] **Control create** (`ControlsPage` + `DomainDetailPage` "Add control"): **remove the Ref input** — show "Ref is assigned automatically (e.g. `ACC.17`)". Title/description only.
- [ ] Regenerate `api/schema.d.ts`.

Open question for review: keep manual ref editing on the control detail page (for corrections) or make ref read-only now that it's derived? Leaning **keep editable** (uniqueness still enforced), since reparenting/legacy fixes may need it.

Refs: ADR 0027, 0010 (Core control model), <issue id="535aa687-e944-4c50-a8a9-0d707d49091f" href="https://linear.app/stevevine/issue/DEV-628/backend-editable-domains-and-controls-crud-disable-control-detail-adr">DEV-628</issue>/629.

---
*Migrated from Linear [DEV-636](https://linear.app/stevevine/issue/DEV-636/domain-identifier-code-auto-generated-control-refs) · created 2026-06-25 · completed 2026-06-25*  
*Related to (Linear): DEV-628, DEV-644, DEV-637*