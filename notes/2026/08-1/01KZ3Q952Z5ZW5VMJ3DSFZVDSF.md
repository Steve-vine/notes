---
id: 01KZ3Q952Z5ZW5VMJ3DSFZVDSF
created: 2026-08-03T11:48:53.983679Z
updated: 2026-08-08T09:07:15.772743Z
type: task
title: Pack dry-run preview
project: 01KX671DATY39VW6GWK3M2T3DN
number: 506
sprint: syte7bx
comments:
- id: 01KZG75QAQTNM5HA4KSKS0ERM4
  author: Steve Vine
  at: 2026-08-08T08:17:31.991199Z
  text: |-
    Done — PR #542 (branch feature/ise-506-pack-preview, stacked on #541).

    Read the source, map it with the **same functions sync uses**, report counts / samples / skip reasons, persist nothing. Same functions on purpose: a preview computed by a second, parallel implementation would eventually diverge from what sync does, and would then be reassuring about the wrong thing.

    **⚠️ One decision needs your eye — it runs on a DISABLED integration, which ADR 0072 §1 forbids in terms** ("`enabled` gates every path... without exception"; "it is only a read is not an argument"). I've taken the exemption and written it into ADR 0072 as an **amendment** rather than letting it become a quiet precedent. Overturn it if you disagree.

    The argument: requiring `enabled` defeats the feature outright. The operator would have to switch the integration on — and let it sync, writing entities — before they could see what it was about to write. A trust step that runs *after* the thing it gates isn't gating anything. And ADR 0072 was written against ISE acting on a system's behalf *on its own schedule*: its three worked examples are a sweep that kept sweeping, an owed notification, and an approved change firing later — all autonomous or deferred. The distinction that actually matters isn't read-vs-write (§1 is right that the status-page bug settles that), it's **autonomous background work vs a synchronous inspection that persists nothing**. The amendment states the boundary in full: persists nothing, synchronous, admin-only, audited, cannot be in flight when the toggle flips. A *scheduled* preview would explicitly not be covered.

    Design details that earned their place:

    - **The fetch is reported separately from the mapping.** Zero items with no error is the commonest authoring mistake — an `items` path at the wrong level — and it's invisible if you only report what got mapped.
    - **One broken endpoint doesn't abandon the run.** An operator debugging a half-working pack needs to see which half works; a single exception would tell them only that something, somewhere, went wrong.
    - **Evidence queries needing arguments are listed but not run.** Inventing a widget id either 404s (telling you nothing) or, on a source with guessable ids, fetches a record nobody asked for.
    - **Warnings are plain-words and come first**, including the `source_of_record` call-out — the most consequential field in a pack and the one whose effect is least visible until it's wrong.

    The UI is a card on the System page for pack-backed integrations, gated on the *connector type* rather than a capability: it's about where the mapping came from, not what it can do.

    Tests: 8 unit, 2 integration proving the exemption end to end (preview runs on a disabled system → estate untouched, system still unsynced, `pack_previewed` audited), 5 vitest.

    Trap worth recording: my first no-write guard did a substring search over the module source and tripped on **its own docstring** describing what it doesn't do — a guard that fails on its documentation and passes on nothing useful. It now walks the AST, asserting the module imports no `sqlalchemy`/`ISE_api.db`/`ISE_api.models`/`ISE_api.discovery` and calls no `commit`/`flush`/`delete`.
assignee: steve
label: null
priority: medium
task_status: done
---
Before enabling a pack instance, run it against the live source without writing: show what it would mint — entity counts by type, sample entities with keys/tags, alert counts by severity, evidence query results. Precedent: `ignore_rules.preview()` and the kind-dictionary probe. This is the trust step that makes third-party packs safe to adopt.