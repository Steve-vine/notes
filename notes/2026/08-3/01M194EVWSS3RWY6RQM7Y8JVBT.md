---
id: 01M194EVWSS3RWY6RQM7Y8JVBT
created: 2026-08-30T10:46:48.473338Z
updated: 2026-08-30T10:47:09.984836Z
type: task
title: Extra fields are reportable
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 533
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
- 01M194DW79NQT4EQCCMZXZMJ0X
assignee: steve
company: null
label:
- feature
priority: high
task_status: backlog
---
An extra field nobody can report on is a notepad. This is the task that makes it a governance tool: extra fields appear in the report builder as columns and as filters, alongside the built-in ones.

**What it looks like to the person building a report.** They pick a subject — Users, Groups, Devices, Directory roles, Conditional access policies — and the extra fields defined for that object type are simply in the field list, no different from the built-in ones. Choose them as columns; filter on them. "Groups where Business purpose is empty." "Conditional access policies with no Justification recorded." Those are the two questions this exists to answer, and both are audit questions.

**The design point, and the reason this is its own task.** Today a subject's fields are a static Python catalogue (`reports/catalogue.py`) — every field is declared in code with its type, its SQL expression, its operators and its renderer. Extra fields make part of that catalogue **data-driven**: the field list for a subject becomes built-ins plus whatever an admin has defined, resolved at run time. Consequences to design deliberately, not discover:

- Operators must follow the field's type — the same mapping the built-ins use (text gets contains/is empty, date gets before/after, yes/no gets is, pick-list gets is/is one of).
- A saved report definition references a field that an admin can later delete. Since deleting a definition hides but keeps values, a report referencing a hidden field should say so plainly rather than fail or silently drop the column.
- The expression is a join to the value table on the Entra object id, not a column on the mirror. Watch the shape when several extra fields are selected at once — one join per field will not do.
- Mirror subjects hide departed rows unless the definition says otherwise; extra-field values on a vanished object must follow that same rule, not a second one.

**Not in scope.** Required fields, and any "objects missing a required field" queue. Nothing is required yet, by decision — if that changes, it needs its own task, because "required" means nothing without somewhere that surfaces what is missing.

Blocked on the object types being reportable — realistically stack it behind groups and CA policies and extend as the others land.