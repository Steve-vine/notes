---
id: 01KZDRKCSS8EDQE2JEMDXDZ7K1
created: 2026-08-07T09:24:22.457352Z
updated: 2026-08-07T10:34:59.890103Z
type: task
title: EntraID discovery stamps expiry dates onto entities (app-registration credentials, user passwords)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 594
sprint: snk16ew
comments:
- id: 01KZDWMPXJME9FT1AYNET94K2E
  author: Steve Vine
  at: 2026-08-07T10:34:59.889991Z
  text: |-
    Done — PR #510 (branch feature/ise-594-entraid-expiry-attributes). No migration needed (JSONB attributes), as expected.

    **App registrations.** `credential_expires` (+ `_kind`, `_name`) now lands on the service principal's entity. Refactored so discovery and the ISE-583 observation ladder share one `_soonest_credential` helper — they must not be able to disagree about which credential is soonest, since a screen citing one date while the signal cites another is worse than either alone. Tested explicitly.

    Three storage rules, each with a reason:
    - The DATE, never days-remaining — days go stale between syncs with nothing saying so.
    - Never the band — a band is a per-System tunable (ADR 0088); frozen into the estate graph it would silently disagree with a retuned ladder. A threshold says what a signal is worth, which is not an estate fact.
    - Always stamped INCLUDING nulls — `discovery.py`'s attribute merge is additive, so a key that stops being sent keeps its last value for ever. A rotated-away credential would otherwise leave its old date standing as a promise.

    Known gap, inherited not introduced: ADR 0076 §1 says an SP-less registration is not an entity, so entity-level expiry covers instantiated apps only (~39 SP-less ones in the live tenant remain Observations, where they were already visible). Stated in the ADR amendment rather than left to be discovered.

    **Users — needed a new Graph grant.** The task said to verify and descope if unavailable. It IS derivable, but not from data ISE could already read: Entra publishes no password expiry date at all, only `lastPasswordChangeDateTime` (User.Read.All, already held) and the domain's `passwordValidityPeriodInDays` on `/domains`, which needs `Domain.Read.All` — NOT among the six grants ADR 0063 §2 lists.

    I first shipped the descoped version, flagged it, and Steve agreed to add `Domain.Read.All` to the read SP (2026-08-07). So the derivation is now built: `password_last_changed`, `password_never_expires`, and derived `password_expires`. Recorded in ADR 0063 §2 as a seventh grant per its own rule that a widening is a recorded decision, never one slipped in by a connector change.

    The derivation refuses to guess at every step — no last-change date, no domain policy, an unrecognised domain (an acquired company's), a null validity period, or Entra's 2147483647 "never" sentinel each yield NO date rather than a plausible one. A null period is deliberately not defaulted: Microsoft's implied default has changed across tenant vintages, and a confidently wrong expiry for every user in the tenant would be believed. It also degrades cleanly to the pre-grant behaviour if `/domains` 403s, so it deploys safely whether or not the consent has landed yet.

    Guests claim nothing at all: they authenticate in their home tenant, and their UPN's domain (`…#EXT#@ourtenant.onmicrosoft.com`) is ours, so any derivation from it would lie.

    **Trap avoided.** Widening the user `$select` is a real regression risk: Graph validates `$select` as a whole, so one unprojectable field fails the entire `/users` call — and this connector's failure mode for a failed sweep is an empty list, which run long enough retires EVERY user in the estate. Added a fallback to the narrow projection, with a test that drives a Graph which rejects the field and asserts the users survive.

    **Screen** (the task said attributes render "for free" — they don't; there is no generic attributes table, attributes are cherry-picked per type). Added a Credential expiry / Password panel to the entity page with a countdown badge. `relativeTime` could not be reused: it reads every future timestamp as "just now", exactly backwards for a thing whose point is that it hasn't happened yet. New `expiryLabel` is unit-tested for that directly.

    Also fixed a fixture faithfulness issue: the test FakeGraph returned the same rows regardless of `$select`, which let the fallback test pass for the wrong reason. It now projects.

    35 EntraID discovery tests (16 new), frontend 651 passed, ruff/mypy/eslint/prettier/build clean, no api-types drift.

    Follow-up worth considering: ISE-593 (estate query v2) is what turns these attributes into answers — the dates are stamped in a canonical aware-UTC form specifically so `attributes->>k` casts to timestamptz reliably.
assignee: steve
label: null
priority: medium
task_status: active
---
The EntraID connector already reads app-registration credential expiry for the threshold ladder (`_credential_expiry_findings`) but throws the dates away — nothing queryable remains. Arbitrary-window questions ("expiring in the next 90 days") need the dates on the entities themselves.

- `discover_entities`: stamp earliest credential expiry (secret + certificate, whichever is sooner) onto `app-registration` entity attributes.
- Users: stamp password expiry if Graph exposes it for the tenant's policy (verify — may be `lastPasswordChangeDateTime` + policy-derived); if genuinely unavailable, record that finding on the task and descope users.
- Attributes render on the existing entity page for free.

Screen: entity detail shows the expiry; Assist answers the expiry questions via estate query v2. No migration expected (JSONB attributes).