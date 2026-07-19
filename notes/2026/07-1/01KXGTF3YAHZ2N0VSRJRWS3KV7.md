---
id: 01KXGTF3YAHZ2N0VSRJRWS3KV7
created: 2026-07-14T17:23:19.11422034Z
updated: 2026-07-14T17:23:33.595840616Z
type: task
title: Domain identifier (code) + auto-generated control refs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 85
sprint: s114vjm
comments:
- id: 01KXGTFJ2VMQAT5YC0S72M03T0
  author: Steve Vine
  at: 2026-07-14T17:23:33.595726094Z
  text: |-
    [Migrated from Linear — Steve Vine, 2026-06-25 20:38 UTC]
    Done — PR [#79](https://github.com/Steve-vine/compass/pull/79), branch `steve/dev-636-domain-code-auto-control-refs` (sequenced on top of the merged DEV-637).

    **What was built**: migration 0021 (`domains.code` VARCHAR(3) NOT NULL UNIQUE, backfilled from control-ref prefixes); `Domain.code` + required/upper-cased/uniqueness-checked `DomainCreate.code`/`DomainUpdate.code`; control create now drops the client ref and the server computes `{code}.{max numeric suffix + 1}` (incl. soft-deleted controls so refs aren't reused); importer sets code from the CSV. Frontend: mandatory Identifier field on domain create/edit, Code column + header badge, Ref input removed from both control-create modals.

    **Verification**: backend `test_controls` + 6 dependent modules green, `ruff`/`mypy` clean; frontend typecheck/eslint/prettier/build clean, 108 vitest tests pass.

    **Decisions (your call at review)**:
    1. **Ref editing kept on the control detail page** (the brief's open question) — auto-generated on create, but the detail edit form retains a manual ref field for corrections/reparenting; uniqueness still enforced.
    2. **Next ref = max numeric suffix + 1, not count + 1** — seeded refs are sparse (Access Control's highest is `ACC.29` with 21 controls), so the next ACC ref is `ACC.30`. Flagging in case you expected count-based.

    Moving to In Review.
assignee: steve
label:
- brief
priority: medium
task_status: done
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