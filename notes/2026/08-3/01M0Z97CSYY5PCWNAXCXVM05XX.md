---
id: 01M0Z97CSYY5PCWNAXCXVM05XX
created: 2026-08-26T14:57:42.206276Z
updated: 2026-08-26T15:02:00.918001Z
type: task
title: A control keeps its identity, gains a clean number, and says what good looks like
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 417
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- feature
priority: urgent
task_status: backlog
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
