---
id: 01M1PNST6K9V67EAX5WDQS6Z3P
created: 2026-09-04T17:00:00.595627Z
updated: 2026-09-04T19:15:28.541228Z
type: task
title: A Business Application cannot be renamed, and the estate lets you try
project: 01KX671DATY39VW6GWK3M2T3DN
number: 777
sprint: s7nj09w
assignee: steve
label:
- bug
priority: high
task_status: todo
tech: null
---
Smoke finding, 2026-09-04. `MongoDB Atlas.prod` now answers to two names, and
neither surface knows about the other.

**State on staging right now:**

```
entity.name        = mongodb-atlas.prod      (name_pinned_by Steve.Vine@moneypenny.co.uk)
business_application.app_name = MongoDB Atlas
business_application.environment = prod, region = NULL
```

**Why they disagree.** A Business Application's identity is `app_name` +
`environment` + `region` (ADR 0096 §2, ADR 0097). `entity.name` is written
**once**, at creation, from `display_name(app_name, environment, region)`
(`business_applications.py:657`), and nothing ever resyncs it. The API then
ignores `entity.name` entirely and derives the name it returns from `app_name`
on every read (`business_applications_api.py:468-470`). So after an estate
rename:

- Business Applications list and detail page → **MongoDB Atlas.prod** (derived)
- Estate entity page, search, graph, anything reading `entity.name` → **mongodb-atlas.prod**
- Estate Observations → **MongoDB Atlas.prod** (`business_applications.py:861, 922`)

**There is no rename anywhere in the Business Application UI.** `PATCH
/business-applications/{id}` accepts `context` and `criticality` and nothing else
(`DefinitionWrite`, line 754). `app_name`, `environment` and `region` are
settable only at creation. So the estate entity's name field is not a bad door —
it is the *only* door, and it opens onto the wrong name.

**The estate rename should never have accepted this entity.**
`PUT /entities/{id}/name` is the ISE-493 **name pin**, whose entire premise is
stated in its own docstring: "The discovered name is decided by a race — the
first source of record to claim an entity names it — so a wrong winner is
otherwise uncorrectable." A Business Application has no discovering source and
no namer. There is no race to correct. The endpoint has no type guard, so it
pinned a name on a derived one and produced a divergence that nothing reconciles
or reports.

**And the pin cannot be undone.** Clearing it (`PUT` with an empty name) only
drops `name_pinned_by`; the docstring is explicit that the current name stays
"until the entity's namer next syncs" — and a Business Application never syncs.
The estate name is now permanently `mongodb-atlas.prod` with no in-app way back,
and no way to change `app_name` to match it. This is the first pinned
business-application or business-service entity in the estate, so nothing else
is affected yet.

**Proposed**

1. **Decide what a Business Application's name is**, and record it — this is the
   ADR-shaped question underneath the bug. `app_name` is currently derived from
   the application tag's *value*, which is what makes the identity match the
   estate and what `detect_candidates` fingerprints against
   (`business_applications.py:509-530`). A freely-typed display name and a
   tag-derived identity are two different things, and today one field is quietly
   doing both jobs. Either the identity stays tag-derived and gains a separate
   authored display name, or renaming is a first-class edit of the identity with
   the fingerprint consequences handled.
2. **Give the Business Application page the rename**, whichever of those wins —
   it is the object's own page and the only place the act makes sense.
3. **Refuse the estate name pin for derived entity types.** `business-application`
   and `business-service` names are composed by ISE, not discovered; the endpoint
   should 422 with a pointer to the right screen rather than silently create a
   second name. The estate page should not offer the control for these types at
   all.
4. **Repair this row.** `entity.name` needs to go back to matching `app_name`,
   and the pin cleared — which no API can currently do.

Related: ISE-773 (the Role column is authored somewhere else and never says
where) is the same shape of defect — a value shown on one screen, authored on
another, with no route between them.
