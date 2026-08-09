---
id: 01KZK8PB6W3DXD04M78CNPHEG7
created: 2026-08-09T12:41:48.508935Z
updated: 2026-08-09T17:59:15.234599Z
type: task
title: Registered servers carry their own domain name — populated by discovery, editable per record and in bulk
project: 01KX671DATY39VW6GWK3M2T3DN
number: 628
sprint: sesjg7z
comments:
- id: 01KZKEZEG3ZGTC2N97JSYF7QRK
  author: Steve Vine
  at: 2026-08-09T14:31:38.243109Z
  text: |-
    BUILT 2026-08-09 — PR #572, `feature/ise-628-server-domain-name`. Migration 0120.

    **Built as designed**: `domain_name` on the server and on the candidate; address resolution `address` > `hostname.domain_name` > `hostname` in one `connection_address` helper that every dial site now goes through; Arc reads `domainName`, falling back to `dnsFqdn` minus the short name; `cross_keys_for` publishes `hostname.domain` before first contact, as you suggested.

    **One thing in the plan could not work, and finding out why was the useful part.** "Arc-sourced servers already registered can take their domain from the candidate row they came from" — in the migration, that is a statement that runs and silently does nothing. `server_coverage_candidate.domain_name` is created EMPTY by the very migration that would read it; Arc does not fill it until the next reconcile.

    So it lives in the reconciler as `adopt_domains`, and it is better there: it is not a one-off. A machine registered before its source knew, one that moved domain, and one whose source only later learns it all land in the same path. It only ever FILLS an empty domain — a domain a human typed outranks what a source says, the way a pinned entity name does.

    **What the migration can do, it does**: an address override of the form `<hostname>.<something>` becomes a domain and the override is cleared. Only that shape — an IP or any unrelated name is a decision somebody made. That covers `mpwxdc02` exactly, so no manual step is needed on staging. The downgrade composes the override back so a downgraded deployment reaches what it did before. The test seeds all four shapes (the workaround, an IP, an unrelated name, nothing) at 0119 and upgrades.

    **Fleet row selection was indeed most of the work**, as you priced it. `POST /servers/bulk/domain` with one refinement worth naming: it re-preflights **only the servers whose connection address actually changed**. A machine whose override still wins has not been altered by the edit, and dialling the fleet to prove nothing moved is a cost with no answer. Everything else IS re-checked immediately — a row still reading `unresolvable_name` after a successful fix would make the fix look like a failure.

    **Two UI decisions** taken while building:
    - The domain field is offered **before** the address override, in both the Add and Edit forms. An operator who meets the override first pastes an FQDN into it — which is the exact workaround this whole task removes.
    - The Edit form shows the address the three fields resolve to, live. Three fields combining into one string is where a screen should show its work, and the old design let somebody paste into the override without ever seeing what it did.

    Fleet rows show `via <connection_address>` only when it differs from the hostname, resolved server-side so a row cannot disagree with the connection it describes.

    **Not yet proven live**: an Arc candidate registering and connecting first time. That needs the deploy.
- id: 01KZKHPPW8457T5H58CNK422NM
  author: Steve Vine
  at: 2026-08-09T15:19:17.640297Z
  text: |-
    DEPLOYED to staging 2026-08-09 — `44ce63d`, images `staging-20260809-1512`, alembic head `0120`.

    **The acceptance criterion is met live, with no manual step.** `mpwxdc02` before the deploy:

    ```
    addr = mpwxdc02.moneypenny.local   dom = (none)   state = unreachable / unresolvable_name
    ```

    after:

    ```
    addr = (empty)   dom = moneypenny.local   state = reachable
    ```

    Migration 0120 recovered the domain from the hand-typed override, cleared the override, and the very next preflight connected. The workaround you flagged in the sprint note is gone from the data, not just from the code.

    **One thing to expect on the smoke test:** every candidate row still shows an empty `domain_name` (arc 0/39, entra 0/1114). That is correct rather than broken — the column is created empty by the migration and Arc fills it on its next coverage pass. It is the same fact that made the planned migration back-fill impossible, so it is worth seeing once: the queue's domains appear after a reconcile, not at deploy.

    Registering a fresh Arc candidate and watching it connect first time is the one part still to prove by hand.
assignee: steve
label:
- bug
priority: high
task_status: done
---
Agreed with Steve 2026-08-09, after the first real registration from Discovery failed and the address override was confirmed as a workaround.

**What happened.** `mpwxdc02` was managed with the right profile and failed:

```
unresolvable_name — ntlm: HTTPConnectionPool(host='mpwxdc02', port=5985)
registered: mpwxdc02  addr=''  state=unreachable/unresolvable_name
```

The categorisation and its advice were right; the registration should never have been made that way. The candidate came from **Arc**, and the Arc payload carries what was needed:

```
MPWXDC02 -> displayName: "MPWXDC02"
            dnsFqdn:     "MPWXDC02.moneypenny.local"
            domainName:  "moneypenny.local"
arc machines with dnsFqdn / domainName: 39/39
```

`collect_arc_candidates` reads `displayName` and drops both, so all 39 Arc candidates register under a name the worker cannot resolve — the same shape as [ISE-622], a payload parsed and the useful field thrown away.

**The design: a domain of its own.**

A `domain_name` on the registered server (and on the candidate, so it survives registration), kept SEPARATE from the hostname. Hostname stays the identity — short, what the estate joins on, and what makes Arc and Entra dedupe against each other. The FQDN becomes derived rather than stored twice.

Connection address resolves in this order:

1. `address` when set — the explicit override, for a host reached by IP or by a name unrelated to its own
2. `hostname` + `.` + `domain_name` when a domain is known
3. `hostname` alone

That keeps the override doing what it was built for and stops it being pressed into service as a place to paste an FQDN.

**Why this beats the alternatives considered.** A per-profile DNS suffix (my earlier proposal) puts a machine's property on the connection method: a profile can span domains, a machine has one. A cluster DNS search domain in Helm fixes it invisibly, but buries an environment specific in the deployment and only works where the pod's resolver can reach the AD DNS. A domain on the record is the thing that is actually true, visible where an operator can see and correct it.

**Populated by whoever knows it.** Arc supplies `domainName` for all 39. Azure VMs, Entra devices and Hyper-V guests carry none today — the field simply stays empty and is filled by hand. It should be filled automatically by any source that gains it later, which makes this the same principle as [ISE-622]: if the integration knows it, record it.

**Editable on the Fleet page, per record and in bulk.** Per record via the existing Edit modal. In bulk because the common case is "these forty machines are all in one domain" — and Entra-sourced servers will never arrive with one.

**Scope note worth pricing in**: the Fleet tab has no row selection today — checkboxes and a bulk bar exist only on Discovered. Bulk domain-setting means Fleet gains the same selection mechanics. That is most of the work in this task.

**Also worth doing here**: once a domain is known, `cross_keys_for` can publish `hostname.domain` as a join key before first contact rather than waiting for the facts gather to report an FQDN.

**Backfill**: Arc-sourced servers already registered can take their domain from the candidate row they came from. `mpwxdc02` currently holds a hand-typed address override that should become an empty address and a `moneypenny.local` domain.

**Acceptance**: an Arc candidate registers and connects first time with no manual step; a server's domain is visible and editable on Fleet; a multi-select on Fleet can set one domain across many servers; the address override still wins when set; candidate dedupe between Arc and Entra still matches on the short name.