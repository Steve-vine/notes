---
id: 01KZ6S97N6QJN78YD6NX28EVJG
created: 2026-08-04T16:21:37.062253Z
updated: 2026-08-05T19:02:37.970312Z
type: task
title: Webhooks return to the core application — no synthetic integrations, no managed sources on the Webhooks page
project: 01KX671DATY39VW6GWK3M2T3DN
number: 539
sprint: skxht3g
comments:
- id: 01KZ6SBR41CBDSZ8SB1YAXV3GJ
  author: Steve Vine
  at: 2026-08-04T16:22:59.457Z
  text: |-
    Implementation pointer: the Dashboards work (ADR 0053 / Canon comment 2026-07-25) already excludes findings from synthetic webhook Systems in service-status maths ("webhooks have no reliable all-clear"). So a discriminator for synthetic-webhook Systems already exists somewhere in the dashboard evaluator — locate it and reuse the same predicate for the Integrations/Overview filtering, rather than minting a second definition of "synthetic". If the predicate is just connector_type='webhook', note that BOTH orphans and legitimate future hidden plumbing share it, which is fine for option (a).

    Sequencing (also in Canon comment 2026-08-04): land before Sprint 47 starts — the pack registry must not inherit webhook-as-integration.
- id: 01KZ7AXZVP93ZGMTBX4WV7ZAE0
  author: Steve Vine
  at: 2026-08-04T21:30:02.997917Z
  text: |-
    Built — PR #461, ADR 0078, migration 0096. PR CI green (backend, backend-lint, frontend, api-types).

    Option (a) as leaned toward, with one deviation worth your eye: the synthetic System's page stays REACHABLE rather than being made a dead link. An incident promoted from a webhook alert links to its signal's origin, and that page is where per-source severity tuning lives — removing it would have lost the tuning with no replacement. Instead `SystemRead.internal` makes the page declare "this is not an integration", point at Settings → Webhooks, and drop every control that would lie (sync toggle, cadence, health pill, State switch). So the concept disappears from every integration-facing surface without the tuning going with it.

    Your implementation pointer was right and used: the dashboard evaluator's webhook exclusion (ADR 0053 §2) is rewired onto the same predicate — `connectors.webhook.is_internal_system` / `internal_system_ids` — rather than a second definition of "synthetic" being minted. It is `connector_type='webhook'`, which as you noted covers orphans and future hidden plumbing alike.

    Teardown decides between two outcomes rather than always deleting: signals and per-source severity overrides go with the source, but a Finding that opened an Issue is history an operator may still be working, so the System is RETIRED (disabled, invisible either way) instead. The audit record says which happened. Migration 0096 applies the same rule to the two live orphans — "Test-Webhook" has no incident so it is deleted outright; "ISE Estate" will be retired if anything it raised opened an incident, deleted if not.

    Also: the filter lives on `GET /systems` itself, not in each caller, because that one endpoint feeds Settings → Integrations, the Overview tiles AND every system picker. Consequence worth knowing before the smoke: a webhook source is no longer selectable in system dropdowns (signal filters, tag-rule scoping), so filtering alerts by webhook source is done on the Alerts screen's origin instead.

    Smoke suggestions: create a source, fire one `level: alert`, confirm no new Integrations row or Overview tile; check FreshService/Moneypenny-Development are gone from Settings → Webhooks but still on Events; delete the source and confirm the plumbing goes; confirm the two orphans are gone after the staging deploy runs 0096.
assignee: steve
label: null
priority: high
task_status: done
---
Direction from Steve 2026-08-04, after functional testing exposed the current model end-to-end: **webhooks are part of the core application, not an integration** — restore that division. His concern, verbatim in substance: the current shape "ambiguates the division between core application and integrations", and that ambiguity will bite in Sprints 47–49 (Integration Decoupling / Integration Packs), which formalise exactly what an integration *is*. A webhook-as-System must not get baked into the pack model's registry and contract.

## What testing found (the symptoms)

- Creating a webhook source in Settings → Webhooks and then receiving one `level: alert` lazily mints a **synthetic System** named after the source (`webhook_signals.ensure_system`, ADR 0048) — which then appears in Settings → Integrations and as an Overview tile, indistinguishable from Azure/EntraID. Its `connected` health is a constant (nothing is checked), and its State toggle is a decoy (the source's own `enabled` is the real switch). An operator cannot tell it's plumbing.
- **Deleting the source orphans the System** — `delete_webhook_source` (`webhook_sources_api.py:247`) has no teardown counterpart to `ensure_system`. Two live orphans exist: **"Test-Webhook"** (from today's testing) and **"ISE Estate"** (same bug, struck long ago, unnoticed — its source no longer exists; Steve re-enabled the ghost believing it was the webhook integration). No UI path removes them.
- The reverse leak: **managed sources** for polled integrations (`ensure_managed_source`, ISE-311 / ADR 0051 §4) put "FreshService" and "Moneypenny-Development" rows on the Settings → Webhooks page — integration plumbing surfacing in the core-app webhook UI. Confusion in both directions.

## Required end state

1. **Settings → Webhooks lists only operator-created inbound sources.** Managed per-integration event sources are internal — not listed (they already reject edit/delete via `_reject_if_managed`; now they also stop being shown).
2. **A webhook source never appears as an integration**: nothing webhook-synthetic in Settings → Integrations, no Overview tile, absent from any add-integration picker if `webhook` is offered there today (verify).
3. **Deleting a source deletes/retires its backing plumbing** — no orphans.
4. **Repair migration** for the two live orphan Systems (and the recovered smoke-test finding attached to Test-Webhook — decide keep-reattributed vs delete). Populated-data test per [[ise-migration-data-paths-need-populated-tests]].

## Implementation decision for plan mode — where do webhook findings hang?

ADR 0048's "ordinary Finding on a synthetic System" bought the whole signal pipeline for free: per-source severity overrides (ADR 0026 scopes by System), dedup on (system, source_key), Alerts-origin naming. Options:

- **(a) Keep synthetic Systems as pure hidden plumbing** — cheapest, preserves all three properties; every integration-facing surface filters them out. The concept disappears from the UI while the FK machinery stays. If chosen, per-source severity tuning needs a home the operator can reach (surface overrides on the Webhooks page, since the System page is no longer reachable).
- **(b) One core "Webhooks" System (hidden)** — simpler still, but per-SOURCE severity overrides and per-source dedup scoping collapse; check whether any live overrides depend on it before choosing.
- **(c) Findings reference the source directly** — the honest model but new promotion machinery, exactly what ADR 0048 avoided; disproportionate unless (a) proves leaky.

Lean (a). Whatever is chosen: **this needs an ADR** — it amends ADR 0048 (the synthetic System becomes an explicit non-integration implementation detail) and ADR 0051 §4 (managed sources stop appearing on the Webhooks page). Append-only; supersede, never rewrite.

## Why now (sequencing)

Sprints 47–49 build the integration registry/contract and declarative packs. The webhook boundary must be clean *before* that work fixes the definition of "integration" in code — retrofitting afterwards means touching the pack model. This task should land ahead of Sprint 47.

## Definition of done

An operator can create, use, and delete a webhook source entirely within Settings → Webhooks; nothing webhook-related ever appears in Settings → Integrations or Overview; FreshService/GitHub rows are gone from the Webhooks page; the two orphan Systems are gone from the live estate; alerts from sources still arrive, attribute, dedup and severity-tune exactly as today.
