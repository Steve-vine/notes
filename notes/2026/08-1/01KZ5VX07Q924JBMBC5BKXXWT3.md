---
id: 01KZ5VX07Q924JBMBC5BKXXWT3
created: 2026-08-04T07:48:07.543248Z
updated: 2026-08-05T14:25:18.49241Z
type: task
title: Untagged-roots notice should say which tag each root is missing
project: 01KX671DATY39VW6GWK3M2T3DN
number: 529
order: 1.25
sprint: skxht3g
comments:
- id: 01KZ6A2AP2ZF0BRH5A1WVPE7F5
  author: Steve Vine
  at: 2026-08-04T11:55:42.146806Z
  text: |-
    Built — PR #453, branch feature/ise-529-untagged-roots-detail. No migration. Branched from main, independent of the other three.

    WHAT LANDED
    `UntaggedRoot` and the API row carry `present` and `missing`. The notice now reads "network-envproductionuspri-vpc (9 contained) has project, missing env", and a root missing both says "missing project, env" rather than "has , missing project, env".

    ONE DECISION I MADE DIFFERENTLY FROM THE TASK'S SUGGESTION
    You offered `has_project: bool` / `has_env: bool` or a `missing` list. I went with lists of key NAMES, because the role bindings are configurable (ISE-472) — `has_project` would become a lie the moment someone binds `platform` to a different key, and the API would be stating a vocabulary the deployment does not use. There is a test that rebinds `platform` to `service` and asserts the message follows to "missing service, env".

    ONE READ, NOT TWO
    Which canonical keys an entity carries decides BOTH the environment dimension and which half is missing, so the query is now shared with `_stated` rather than duplicated. That is the only structural change; the detection rule is untouched.

    TESTS
    - A project-only root reports missing ("env",) — your live case exactly.
    - A root with neither reports both.
    - An env-ONLY root is still a gap and names `project` as missing. This one is worth flagging: `env:` without the sibling discriminator states no dimension at all (ISE-472), so it is correctly flagged, and the key the message must name is the discriminator rather than the env tag. Easy to get backwards.
    - The role-rebinding test above.
    - Frontend: both message shapes render, verified to FAIL with the rendering suppressed.

    NOT DONE, AS YOU SPECIFIED
    The detection rule is unchanged — all 15 are genuinely unstated. Nothing infers an environment from a name or providerconfig.

    VERIFICATION
    Full backend suite 2187 passed; frontend 576 passed; ruff, mypy, eslint, prettier, npm run build clean. OpenAPI + api types regenerated.
assignee: steve
label: null
priority: low
task_status: done
---
From functional testing 2026-08-04, straight after ISE-521/522 landed the `network` layer and the Estate page notice grew to "15 platform roots state no infrastructure environment".

## The confusion, live

Steve opened `network-envproductionuspri-vpc` from the list, saw `project:envproductionpri` on it, and reasonably asked why it was still flagged. The answer took a DB dig: under ADR 0073 §7 / ISE-472 the infrastructure environment is stated by an **`env` tag** (with `project:` as the sibling discriminator) — and that VPC has `project` but **no `env` tag at all**. The notice's wording ("until they carry project + env tags") names the pair but never says which half a given root is missing, so a root with one of the two reads as a false positive.

The live 15 split three ways, each a different remediation — none visible from the current notice:

- 8 Crossplane AWS VPCs: `project` ✅ `env` ❌ (the cluster composition stamps both; the network composition stamps only project — fix is one composition change)
- 6 Azure VNets: neither
- 1 AKS cluster (`k8-mp-dev-uks-aiv2`): neither

## Change

`untagged_roots()` (`environments.py:184`) already loads each root's stated tags to decide inclusion — extend `UntaggedRoot` with what is present/missing (e.g. `has_project: bool`, `has_env: bool`, or a `missing: ["env"]` list) and surface it in the Estate page notice: *"network-envproductionuspri-vpc — has project, missing env"*. Roots missing both just say so. Sort order can stay (most-containing first).

Vertical slice: API field + notice rendering + a test that a project-only root reports `missing env` specifically. API change → OpenAPI snapshot regen (`dump_openapi` + `generate:api`).

## Not in scope

- No change to the detection rule itself — the 15 are all genuinely unstated, the rule is right.
- No inference from names/providerconfig (`envproductionuspri`, `providerconfig-aws-production` make the answer obvious to a human; ADR 0073 deliberately refuses to guess).

## Definition of done

An operator reading the untagged-roots notice can see, per root, which of project/env it already carries and which it is missing, without opening the entity.
