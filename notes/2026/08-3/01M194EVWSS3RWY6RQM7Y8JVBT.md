---
id: 01M194EVWSS3RWY6RQM7Y8JVBT
created: 2026-08-30T10:46:48.473338Z
updated: 2026-08-30T15:32:37.329256Z
type: task
title: Extra fields are reportable
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 533
sprint: sz42uhw
blocked_by:
- 01M194DR53W6QGX7KCYFGVWQGV
- 01M194DW79NQT4EQCCMZXZMJ0X
comments:
- id: 01M19CCBP1EBJ20JFMN56KDFPW
  author: Steve Vine
  at: 2026-08-30T13:05:14.94536Z
  text: |-
    Shipped — PR #540, merged to main as 778d9d5.

    An admin's fields now arrive in the report builder's field list beside the built-ins, as columns and as filters, with the operators their type implies. Both questions the task names are expressible and tested.

    **The design point.** A subject's field list is the built-ins plus whatever an admin has defined, resolved at run time from a session. What that does *not* change, and I was careful about: a definition still cannot write SQL — it names a field and the catalogue decides what the field is. An admin chooses a label and a type, never an expression.

    The four consequences, all designed rather than discovered:

    - **Operators follow the type**, from the same mapping the built-ins use. A pick-list is an enum whose values are the options the admin wrote, so a report renders their own words back.
    - **A removed field is refused in words** — it names the field and says the values are kept, rather than showing `extra:8f3c…`.
    - **A scalar subquery per field, not a join.** You were right that one join per field will not do; subqueries compose, so three fields is still one row per object, and there is a test that counts.
    - **Values inherit the subject's departed rule** for free, because the subquery correlates on the subject's own row. Nothing second beside it.

    Keys are namespaced and keyed on the definition's **id**, not its label, so a saved report goes on meaning the same field after a rename. `describe()` takes the resolved subject where the caller has one — a frozen run summary describing fewer conditions than the run applied is the one thing it must never be.

    **One bug found on the way.** A date condition's value arrives from JSON as a string; against a mapped `DateTime` column SQLAlchemy borrowed the column's type to bind it, but a derived date expression has no column type to borrow — the bind went out as `varchar` and Postgres has no `date < varchar`. Coerced by field type in one place now, which makes the built-in path explicitly typed rather than accidentally so.

    **No frontend change beyond a test** — the wizard already renders whatever the catalogue serves, which is what should have happened. Required fields and a "missing a required field" queue stayed out of scope, as decided.
assignee: steve
company: null
label:
- feature
priority: high
task_status: done
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