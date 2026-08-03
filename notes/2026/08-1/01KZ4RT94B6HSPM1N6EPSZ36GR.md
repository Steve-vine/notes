---
id: 01KZ4RT94B6HSPM1N6EPSZ36GR
created: 2026-08-03T21:34:58.187762Z
updated: 2026-08-03T22:32:38.607888Z
type: task
title: EntraID credential_spec documents the wrong CA policy scope — Policy.Read.All, not Policy.Read.ConditionalAccess
project: 01KX671DATY39VW6GWK3M2T3DN
number: 525
sprint: skxht3g
assignee: steve
priority: low
task_status: todo
---
Live-disproved 2026-08-03 during EntraID setup after the estate wipe.

## What happened

CA policy discovery 403'd on every sync (`entraid CA policy discovery failed — HTTP 403: AccessDenied: required scopes are missing in the token`) with `Policy.Read.ConditionalAccess` **granted, admin-consented, and demonstrably present in the token's `roles` claim** — proven by decoding the actual client-credentials token inside the api pod. Adding **`Policy.Read.All`** cleared it immediately (probe went 403 → 200, same app registration `40fd38b4-…`).

`Policy.Read.ConditionalAccess` is Graph's *documented* least-privilege scope for `GET /identity/conditionalAccess/policies`, but in practice the endpoint demands `Policy.Read.All` — the widely-reported trigger being policies that reference other policy objects (authentication strengths, named locations). Independent reports of the identical failure: Microsoft Q&A (Graph Explorer needs Policy.Read.All), Microsoft365DSC #3556, terraform-provider-azuread #1501.

## Change

`connectors/entraid.py:200` — the `credential_spec` scope list. Replace `Policy.Read.ConditionalAccess` with `Policy.Read.All`, with a comment recording that the documented least-privilege scope is rejected in practice and why (this task / the probe evidence), so nobody "fixes" it back to the narrower scope on the strength of the Graph docs.

Check whether the scope list is stated anywhere else (System detail page copy, docs/briefs, the EntraID ADRs 0063/0064) and correct those too — the spec is the setup instruction the next credential is built from, and it currently walks the operator straight into a 403 that looks like a consent mistake.

## Not in scope

No behaviour change — the connector already degrades the CA slice gracefully on 403 (`entraid.py:584`), which is correct. This is documentation-of-record only; docs-only is the stated exception to the screen rule.

## Definition of done

An operator granting exactly what `credential_spec` lists gets a working CA policy slice on first sync — no 403, `policy` entities minted.
