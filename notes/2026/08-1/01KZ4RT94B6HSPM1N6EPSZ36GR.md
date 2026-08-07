---
id: 01KZ4RT94B6HSPM1N6EPSZ36GR
created: 2026-08-03T21:34:58.187762Z
updated: 2026-08-07T10:09:31.244532Z
type: task
title: EntraID credential_spec documents the wrong CA policy scope — Policy.Read.All, not Policy.Read.ConditionalAccess
project: 01KX671DATY39VW6GWK3M2T3DN
number: 525
sprint: skxht3g
comments:
- id: 01KZ4WZ4EEFFGPGHGW6P7MQTZR
  author: Steve Vine
  at: 2026-08-03T22:47:31.534185Z
  text: |-
    Built — PR #448, branch feature/ise-525-entraid-ca-policy-scope. No migration, no behaviour change.

    DONE AS ASKED
    - `credential_spec` now asks for `Policy.Read.All`, with your probe evidence written into the code at length — specifically so nobody narrows it back on the strength of the Graph docs, which is what caused the 403 in the first place. A test pins it for the same reason.
    - Grepped for the scope list everywhere: it appears in exactly two places, entraid.py and ADR 0063. No brief, no UI copy, no other ADR.
    - The 403 log line now names the scope. Graph's own message says "required scopes are missing" without saying which, and the obvious guess is the wrong one.

    ADR 0063 ALREADY CALLED THIS
    §2 anticipated it exactly: "if Graph in practice demands the coarser Policy.Read.All, the widening is recorded as a security-model standing-risk entry, never granted silently." So I did not touch the ADR (accepted, append-only — and its text is still correct, it described this outcome). The widening is entry 6 in docs/briefs/security-model.md, following the DataDog admin-key template: what the extra scope actually costs (every policy object in the tenant — authentication methods, authorization, device registration, cross-tenant access — where ISE calls exactly one endpoint), what already mitigates it, and the revisit trigger. Smaller blast radius than the DataDog key because it is read-only and cannot be escalated into a write.

    ONE THING BEYOND "DOCS-ONLY"
    Your DoD is "an operator granting exactly what credential_spec lists gets a working CA slice on first sync". `read_only_scopes` has never been rendered ANYWHERE in the app — every connector declares its minimum permissions, the API serves them, and no screen shows them. So the corrected spec would only have reached someone reading Python, and the DoD would not have been met.

    The credential form now shows the connector's declared scopes above the fields. Small and generic, lands for every connector — but EntraID is why it matters, because here the vendor's documentation actively misleads.

    VERIFICATION
    Full backend suite 2175 passed; frontend 572 passed; ruff, mypy, eslint, prettier, npm run build clean.

    FOR YOU: grant exactly what the form now lists and confirm the CA slice mints `policy` entities on the first sync — that is the half I cannot test from here.
assignee: steve
label: null
priority: low
task_status: done
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
