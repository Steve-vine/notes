---
id: 01M14W3AV7PF8DFJEKKB4CSEQN
created: 2026-08-28T19:03:44.231025Z
updated: 2026-08-28T19:03:44.231025Z
type: task
title: 'The report catalogue: subjects, fields and the runner'
task_status: todo
assignee: steve
label: feature
priority: high
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 487
company: null
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