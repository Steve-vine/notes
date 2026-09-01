---
id: 01M0Z97CSYY5PCWNAXCXVM05XX
created: 2026-08-26T14:57:42.206276Z
updated: 2026-09-01T13:55:52.752082Z
type: task
title: A control keeps its identity, gains a clean number, and says what good looks like
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 417
sprint: s8cjs5n
comments:
- id: 01M107BQZ4RJCZRQJG6797GEMA
  author: Steve Vine
  at: 2026-08-26T23:44:21.987885Z
  text: |-
    Done — PR #423, merged to main.

    ADR 0059 is in `decisions/0059-a-control-keeps-its-identity-and-gains-a-clean-number.md`.

    **What shipped**

    - Identity is the UUID, and always was. Assessments, evidence, mappings and the audit trail all join on it, so **renumbering breaks no referential integrity** — that is the fact that made the rest of the sprint affordable. What it breaks is the `ACC.8` in somebody's ticket, and `legacy_ref` is the whole of that fix: "was ACC.8" on the control page, and resolvable in search.
    - `key` is the corruption fix. `import_controls` was insert-missing-only and keyed on `ref`; the moment COM-423 renumbered, the deploy-time seed would have found no control called `ACC.8` and **re-inserted all 269 as new rows** — silently, on deploy, in production. Keyed on `key`, which never moves, it inserts nothing. `test_reimporting_after_a_renumber_inserts_nothing` is the regression test.
    - A control authored in-app takes a key in the `app.` namespace rather than its ref, so a later seed CSV cannot claim the same key and be silently skipped.
    - §6: a library revision is a data migration, not an importer change. The recurring deploy-time import stays insert-missing-only so a deploy can never clobber an in-app edit.
    - `renumber_domain` implements the two-phase update once. Every control parks on a `~`-prefixed ref before taking its final one — staging *all* of them, not only those whose ref changes, is what makes it independent of the direction of each move.

    **What it turned out to protect**

    More than the brief anticipated. COM-423 renumbered **203 of the 269** controls, and the same keying flaw existed in the *crosswalk* seed — it looked controls up by ref, so all 425 mappings would have silently failed to resolve on the next import. Rekeying that on `key` too was a direct consequence of this ADR. Several test fixtures had the same habit and now address controls by key.

    **One small thing worth knowing**

    A test of mine assumed refs sort naturally. They do not — `ACC.10` string-sorts before `ACC.2`, which is exactly why `display_order` exists elsewhere in the schema. Anything ordering controls needs to sort on the numeric part.

    **Tests**: `test_control_identity.py` — 9 cases covering the renumber, the legacy ref, search resolution, the `app.` namespace and the re-import guard. Full CI green.
assignee: steve
label:
- feature
priority: urgent
task_status: done
---
ADR 0059. Blocks the domain and control rewrite tasks — settle the rules before
anyone renumbers a single row.

Three problems in one decision.

**The numbering has holes.** Roughly 130 of them. Information Security retains 9
of 22 numbers, Secure Development 8 of 15, Access Control 21 of 29. Nothing
records what was removed or why, and several holes sit exactly where today's
gaps are. After the domain consolidation the refs would be worse still — a
control numbered `CRD.3` living in a domain coded `IDM`.

**The reference is doing two jobs.** It is both the stable identity people cite
and a human-readable position in a list. Those conflict the moment anything
moves.

**A control statement says what, never how well.** `description` exists and is
empty on all 269. An assessor rating maturity has one sentence to go on, and two
people rate the same control differently because they are imagining different
implementations.

## What changes for the reader

Every control has a clean number within its domain — `IDM.1` … `IDM.19`, no
gaps, no strays from a domain it no longer belongs to. Where a control has moved
or been renumbered, its old reference is still shown and still searchable, so
anything written down before this sprint resolves.

And every control answers "what would good look like here" in a consistent
shape, so two assessors reading the same control picture the same thing.

## The rules

**Identity** stays the UUID. It always was — assessments, evidence and mappings
join on it, so renumbering breaks no referential integrity. What breaks is human
continuity, and that is what `legacy_ref` is for.

**Number** is `<domain code>.<n>`, n from 1, contiguous, ordered so the domain
reads as an argument rather than an accident: policy and governance first, then
process, then technical enforcement.

**`legacy_ref`** holds the pre-sprint ref, is unique where present, resolves in
global search (ADR 0021) and is shown as "was ACC.8" on the control page. It is
never reused and never edited after this sprint.

**`description`** becomes non-null for every control, in three parts:

- **What this means** — one or two sentences of plain English, expanding the
  statement without repeating it.
- **What good looks like** — three to five bullets of observable practice. Not
  aspiration: things you could walk in and see. Where a framework sets a number
  (14 days for high and critical updates, MFA on all cloud services), state the
  number.
- **Evidence** — what an assessor would ask to see. Two or three items.

Worked example, so the rewrite tasks have no ambiguity:

> **END.7 — Removable media is encrypted before data can be written to it.**
>
> *What this means:* Corporate devices refuse to write to a USB stick or
> external drive unless it is encrypted, so data cannot leave on unprotected
> media even by accident.
>
> *What good looks like:*
> - Device policy enforces encryption on write to removable media on every
>   managed workstation and laptop, not just those handling sensitive data.
> - Blocked write attempts are logged and visible to the security team.
> - Exceptions are named, time-limited and approved, not open-ended.
> - Users see a message explaining why the write failed and what to do.
>
> *Evidence:* the device management policy showing the enforcement setting; a
> report of managed devices with the policy applied; a sample of blocked-write
> events; the current exception list with approval dates.

## Implementation

- `core_controls` gains `legacy_ref` (String(20), unique, nullable);
  `description` becomes not-null (backfilled by the rewrite tasks — stage the
  constraint after them, not in this migration).
- `ref` is unique and stays unique. Renumbering happens inside one transaction
  per domain, or the unique index fights the intermediate state — use a
  two-phase update or a deferred constraint.
- Global search indexes `legacy_ref`.
- The control API returns both; the UI shows `legacy_ref` as secondary text.
- `import_controls` is insert-missing-only and keyed on `ref` (ADR 0027) — after
  renumbering, the old CSV would re-insert all 269 as new rows. Rekey the
  importer on a stable `key` column, or retire the CSV path for controls and
  make the rewrite a migration. **Decide this in the ADR** — it is the one thing
  here that can corrupt the library.

Tests: renumbering a domain leaves assessments, evidence and mappings intact;
`legacy_ref` resolves in search; re-running the importer after a renumber
inserts nothing; a control without a description fails validation.
