---
id: 01KZ3Q9AG5EGAQ6CQZ347PQY10
created: 2026-08-03T11:48:59.525975Z
updated: 2026-08-08T08:35:40.125167Z
type: task
title: GitLab reference pack — the acceptance proof
project: 01KX671DATY39VW6GWK3M2T3DN
number: 508
sprint: syte7bx
comments:
- id: 01KZG86XDA41NKYHSNJTXPAD1D
  author: Steve Vine
  at: 2026-08-08T08:35:39.562304Z
  text: |-
    Done — PR #544 (branch feature/ise-508-gitlab-pack, stacked on #543). Closes the sprint.

    **Result: ZERO changes under `app/`.** The only files added are `docs/examples/gitlab-pack.yaml` and its index entry. A complete GitLab integration exercising all three capabilities — projects as estate entities, GitLab's own incidents as Alert signals joined to those projects, three parameterised evidence queries — authored purely from the published brief.

    **Proved against the live API, not merely validated.** A pack that validates but doesn't work would prove nothing:
    - **200 real gitlab.com projects across two pages → 200 entities, 0 skipped.** Exercises `link_header` pagination, the page cap and the entity mapping against responses nobody curated.
    - **Real issue payloads through the shipped `map_alerts`** → findings whose `entity_key` joins to `gitlab:project:278964` in exactly the shape the entities mapping mints, with `UNKNOWN` severity landing on `info` via the declared map, GitLab's millisecond ISO timestamps parsed, and labels arriving as tags.

    **Three design choices the exercise confirmed**, each of which looked like over-refinement when built:
    1. `header` and `prefix` as *separate* knobs — GitLab wants a bare token in `PRIVATE-TOKEN`, so a single "bearer token" switch would have failed on the very first real product tried.
    2. Parameterised endpoints being evidence-only — every useful GitLab read is `/projects/{id}/…`, and sync has no id to supply.
    3. Filtering the alert endpoint to the live set (`issue_type=incident&state=opened`) — the brief's guidance survived contact with a source whose full issue history is enormous.

    **⚠️ The one friction point, and it's a vocabulary gap rather than a design fault: ISE has no canonical entity type for a code project.** The pack maps projects to `other`. That's the honest answer under ADR 0094 §3 — borrowing `application` or `service` would assert something about the estate that GitLab never said — and it works (entities appear, carry tags, join signals), but `other` gives up the filtering and iconography a canonical type earns.

    It required **no code change**, which is why I recorded it in ADR 0094's acceptance section rather than fixing it here: it's a question about the canonical vocabulary (ADR 0086) and the estate model, not about packs, and adding a type deserves its own consideration. Say the word and I'll open a follow-up for a `code-project` type. Worth noting the pressure arrived exactly where §1 predicted it would — on the menus, which is where that signal is supposed to show up.

    Two small authoring notes for the record: YAML bit me on `gitlab:project: key` in a description (colon-space is a mapping indicator, needs quoting), and an *invalid* token gets a hard 401 from GitLab where no header at all is anonymous — which is why the live proof used an anonymous variant of the same document rather than a bogus token.

    ADR 0094 gains an "Acceptance" section recording the result; the examples test covers the new pack automatically since it globs the directory.
assignee: steve
label: null
priority: medium
task_status: review
---
Author a real pack (GitLab: projects + open issues/alerts + evidence queries) purely from the published spec, uploaded through the UI, with zero ISE code changes. If this cannot be done without touching core, Option B is not done. The pack ships as a docs example alongside the spec.