---
id: 01M14W3AV7PF8DFJEKKB4CSEQN
created: 2026-08-28T19:03:44.231025Z
updated: 2026-09-01T13:55:51.958083Z
type: task
title: 'The report catalogue: subjects, fields and the runner'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 487
sprint: s42ntc9
comments:
- id: 01M16HHW16P6Q6SKDMPK4ER0P0
  author: Steve Vine
  at: 2026-08-29T10:37:55.110249Z
  text: |-
    Done and merged to main — PR #498.

    `reports/catalogue.py` declares six subjects (Users, Groups, Devices, Directory roles, Role assignments, Governed memberships) and their fields; `reports/runner.py` compiles (subject, conditions, columns, sort) into one select and applies company scoping, the vanished filter and the row cap outside any definition's reach. Validation is separate from running, ready for save (COM-488), seed import and CI (COM-493).

    Two decisions worth knowing about, because they were forced by the task's own constraint that a standard report must be expressible:

    **`days_inactive` falls back to the creation date.** *Inactive users* wants "over 90 days ago **or never**", and a flat AND-ed condition list cannot say "or". Rather than adding boolean grouping to the definition language for one report, the field reports an account that has been *read* and never signed in as inactive since it was created — an account made two years ago and never used is two years inactive, which is what a reviewer means. It stays unknown while the sign-in sweep has not reached the account, so an unread account can never satisfy a threshold. That makes Inactive users one condition, and there is a test named for it.

    **`holds_directory_role` includes eligible assignments; the Role assignments subject keeps them separate.** That looks inconsistent and is not: asking whether an account *is* privileged, a role somebody can activate at will is privilege (and this mirrors `account_holds_privilege` exactly, so the report and the approval gate cannot disagree). Looking at assignments, active and eligible are different facts and COM-444 forbids merging them. Both the code and the tests say why.

    The unknown-handling from COM-492/497 is carried all the way through: every type can be asked `is_empty`, the negative operators keep nulls rather than dropping them (a bare `!=` would turn "type is not Guest" into "type is Member" and hide every unobserved account), and a null renders as "Unknown" rather than a blank cell.

    One thing to flag for COM-493: **"role is privileged" has no field behind it.** Compass's own model (ADR 0061 §5, privileged_access.py) treats *any* directory role as privilege, so "Users holding privileged roles" is expressible as Role assignments where the holder is a person — which is the honest reading. If you want Microsoft's narrower `isPrivileged` flag on a role definition instead, that is a one-line `$select` plus a column plus a catalogue entry — a small follow-up task rather than something to bend this file for.

    Also here: `OPERATOR_LABELS` and `describe()` live in the catalogue so the wizard, the report's page, the CSV preamble and the PDF subtitle all render one sentence. Four copies would be four chances for a download to describe a different question from the screen it came off.
assignee: steve
label:
- feature
priority: high
task_status: done
---
ADR 0062 §3. The only code in the reporting feature: what Access Control can be asked about, and how it is asked.

**A subject** declares its rows and its fields. First cut: Users, Groups, Devices, Directory roles, Role assignments, Governed memberships.

**A field** declares a label a person reads, a type (text / number / boolean / date / enum / reference), and how it renders in a table, a CSV and a PDF. The *type* decides which operators apply — there is no per-field operator list to keep in step, and no way to write a comparison the field cannot answer.

**The runner** compiles `(subject, conditions, columns, sort)` into one SQLAlchemy select and applies, unconditionally and outside any definition's reach:

- company scoping wherever the subject is company-scoped (managed-ness, provenance, requests);
- `vanished_at is null` on mirror subjects, unless the definition explicitly asks for departed objects;
- the caller's visibility rules;
- a row cap with an explicit *truncated at N* marker on the output — never a silent cut.

A definition naming a field the catalogue no longer declares must fail **at import and in CI**, not at run time (ADR 0062 §3). Include the test that walks every seeded definition against the catalogue, so removing a field breaks the build rather than the report.

Derived fields belong here too, not in the definitions: *member count*, *has an owner*, *days since last sign-in*, *holds a directory role*. They are what makes the standard reports expressible without SQL.

Backend only — no endpoint in this task.