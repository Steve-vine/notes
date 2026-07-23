---
id: 01KY6XZHWWPXGX3WX3WW0KNBY5
created: 2026-07-23T07:28:00.924627Z
updated: 2026-07-23T07:28:10.213814Z
type: task
title: Development-governance ADR
imported_from: linear
assignee: steve
label: chore
task_status: done
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 2
comments:
- id: 01KY6XZTZ5WYSEKD7398RCB0J4
  author: Steve Vine
  at: 2026-07-23T07:28:10.213412Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    ADR 0007 written and the ways-of-working TBD resolved.

    **What was done**
    - Created `decisions/0007-development-governance.md` (house ADR format, Accepted, 2026-06-19) covering all four checklist items: branch naming, merge strategy, CI gates, Definition of Done.
    - Edited `brief/ways-of-working.md` — replaced the `[TBD]` blockquote with a link to ADR 0007.

    **Decisions locked (per planning)**
    - **Branch naming:** `brief-NNN-slug`, NNN = DEV issue #, fixed `brief-` prefix for all labels. Overrides Linear's `steve/dev-NNN-slug`.
    - **Merge:** squash-merge, one brief = one commit on `main`.
    - **CI gates:** lint · build · test · typecheck green to merge — categories are policy now, workflows land per-stack in M1 (DEV-476/DEV-478).
    - **DoD:** checklist done · CI green · this kind of comment · PR reviewed · follow-ups parent-linked (never folded in) · Done + squash-merged.

    **Notes / things to know at review**
    - CI gate *enforcement* doesn't exist yet (no app code), so this PR can merge before gates are wired — called out in the ADR's Consequences as expected.
    - This brief itself ships on `brief-477-development-governance-adr`, exercising the new rule (note DEV-477 is a `chore`, confirming the prefix is label-independent).

    **PR:** https://github.com/Steve-vine/notula/pull/1
    **Branch:** `brief-477-development-governance-adr` · commit `7634c88`
---
Pin the development-governance specifics that `brief/ways-of-working.md` flags as TBD, so the brief→PR→merge loop is unambiguous.

**Checklist**

- [X] Branch naming (lean: `brief-NNN-slug`)
- [X] Merge strategy (squash-merge is the lean — see the dependent-briefs note in ways-of-working)
- [X] CI gates required to merge
- [X] Definition of Done for a brief
- [X] Write it up as `decisions/0007-development-governance.md`, and resolve the ways-of-working TBD with a link

**Done when:** ADR 0007 is committed and the ways-of-working TBD points at it.

---

### Agreed approach (planned 2026-06-19)

ADR 0007 locks the following, derived from the existing ways-of-working lean and Steve's calls in planning:

1. **Branch naming:** `brief-NNN-slug`, where **NNN = the Linear DEV issue number** and the `brief-` **prefix is fixed for every issue regardless of label** (so this issue ships on `brief-477-development-governance-adr`). Deliberately overrides Linear's auto-generated `steve/dev-NNN-slug`.
2. **Merge strategy:** **squash-merge** — one brief = one commit on `main`. Underpins the "sequence dependent briefs, don't stack" guidance already in ways-of-working.
3. **CI gates:** required gate **categories defined now** as standing policy — **lint, build, test, typecheck**, green-required to merge. Concrete workflows land per-stack as M1 arrives (DEV-476 skeleton, DEV-478 build).
4. **Definition of Done for a brief:** checklist complete · CI green · issue comment capturing what was done + decisions + problems · PR reviewed · follow-ups filed as parent-linked issues (never folded into the brief) · moved to Done and squash-merged.

**Files:** created `decisions/0007-development-governance.md`; edited `brief/ways-of-working.md` to replace `[TBD]` with a link to the ADR.

**PR:** [https://github.com/Steve-vine/notula/pull/1](<https://github.com/Steve-vine/notula/pull/1>)

---

Linear DEV-477 · M0 — Brief, decisions & project setup · created 2026-06-19 · done 2026-06-19