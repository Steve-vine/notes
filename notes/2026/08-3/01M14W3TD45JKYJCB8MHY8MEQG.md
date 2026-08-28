---
id: 01M14W3TD45JKYJCB8MHY8MEQG
created: 2026-08-28T19:04:00.16498Z
updated: 2026-08-28T19:04:00.16498Z
type: task
title: 'A report is a row: definitions, and the library that holds them'
label: feature
priority: high
assignee: steve
task_status: todo
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 488
company: null
---
ADR 0062 §2. The stored definition — subject, conditions, presentation, identity — and the API that keeps a library of them.

`report_definitions`: name, description, the governance question it answers, subject, conditions, columns, sort, plus the usual company scoping, actor and timestamps. Conditions and columns are held as JSONB and validated against the catalogue (COM-487) on write, so an invalid definition cannot be saved in the first place.

CRUD, plus the three things that make a library rather than a table:

- **Duplicate** — the operation the whole design rests on. *Ninety days is thirty here* must be two clicks, and must not touch the original.
- **Export** — one definition as a small file.
- **Import** — the same file, validated against the catalogue, refused with a readable reason if the target doesn't declare a field it names.

Deleting a definition is restricted to its author and an admin. A seeded standard report cannot be deleted at all — it would come back on the next deploy, and a delete that silently undoes itself is worse than a refusal.

Activity-logged like every other authored object.