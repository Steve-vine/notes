---
id: 01M1Q5JNATFCQPEQYFPEAGAPVX
created: 2026-09-04T21:35:43.450631Z
updated: 2026-09-04T21:35:50.090348Z
type: task
title: The Business Service list drops the region and shows two applications as one name
project: 01KX671DATY39VW6GWK3M2T3DN
number: 781
sprint: s7nj09w
assignee: steve
label:
- bug
priority: high
task_status: backlog
tech: null
---
Smoke finding, 2026-09-04. The Business Service `AI Receptionist` composes
`chinwag.prod.uk` and `chinwag.prod.us`. The Business Service list renders both
as **`chinwag.prod`** — the same string, twice.

**Confirmed on staging:**

```
service           entity_name        app_name  env   region   list shows
AI Receptionist   chinwag.prod.us    chinwag   prod  us       chinwag.prod
AI Receptionist   chinwag.prod.uk    chinwag   prod  uk       chinwag.prod
```

**Cause — `business_services_api.py:110`:**

```python
display = f"{application.app_name}.{application.environment}"
```

Hand-rolled, and it drops the region. `business_applications.display_name()`
exists for exactly this and its docstring says so in as many words: *"The one
place the dotted form is decided, so a regionless Business Application reads
exactly as it always has."* It is not the one place — there are three, and the
other two are wrong.

ADR 0097 put region in the Business Application's identity precisely so that
`chinwag.prod.uk` and `chinwag.prod.us` are different things. Truncating the
name collapses that identity back, on the one screen whose whole job is showing
which applications a service is made of.

**Three consequences in the same block**

1. **The names collide** (line 110). Two rows, one name, no way to tell which is
   which — and the row links by `entity_id`, so the link works and the label
   lies.
2. **The fault list inherits it** (line 121): `faults.append(display)`. If only
   the US application is not customer-facing, the warning names an ambiguous
   `chinwag.prod` and the operator cannot tell which half to fix.
3. **The order is unstable** (line 100):
   `.order_by(BusinessApplication.app_name, BusinessApplication.environment)`
   has no region tiebreak, so two applications differing only by region have no
   defined order and can swap between reads — two identical labels that also
   move.

**A second instance of the same bug — `discovery.py:310`:**

```python
f"`{application.app_name}.{application.environment}` — confirming attaches "
```

The alias proposal's evidence text. This one matters more than a label: the
operator is being asked to confirm an attachment, and is told the alias matches
"the Business Application `chinwag.prod`" when two exist. Confirming writes an
alias against a specific one.

**Proposed**

- Replace both with
  `business_applications.display_name(app_name, environment, region)`. The
  function already handles the regionless case, so nothing that reads correctly
  today changes.
- Add `BusinessApplication.region` to the `_read` ordering.
- Add a test with two applications differing only by region — the estate has had
  this shape since ADR 0097 and neither call site has ever been exercised
  against it.
- Consider making the concatenation impossible to hand-roll: the frontend
  already consumes `ComposedApplication.display_name` from the API
  (`BusinessServicesPage.tsx:194, 267`), so the backend is the only place this
  can go wrong — a lint rule or a grep in review for `app_name}.{` would have
  caught both.
