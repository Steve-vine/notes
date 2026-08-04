---
id: 01KZ5VX07Q924JBMBC5BKXXWT3
created: 2026-08-04T07:48:07.543248Z
updated: 2026-08-04T11:40:35.660816Z
type: task
title: Untagged-roots notice should say which tag each root is missing
project: 01KX671DATY39VW6GWK3M2T3DN
number: 529
order: 1.25
sprint: skxht3g
assignee: steve
label:
- improvement
priority: low
task_status: active
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
