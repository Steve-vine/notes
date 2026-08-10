---
id: 01KZM1KXP8SQHPFWZKBJA7A3F7
created: 2026-08-09T19:57:23.528918Z
updated: 2026-08-10T19:35:04.339011Z
type: task
title: A server registered by its FQDN is unreachable by its short name across the whole estate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 633
sprint: s1rgnyx
comments:
- id: 01KZPJQF7TR3FA115SP370JZCS
  author: Steve Vine
  at: 2026-08-10T19:34:54.458491Z
  text: |-
    Built and merged to main 2026-08-10 — `dccdfc6` (PR #581).

    Two fixes, both in the register:

    1. `cross_keys_for` (`servers.py`) now publishes the short form of the REGISTERED hostname, not only of a reported identity that may be absent. `mpwxscript.moneypenny.local` gains `dns:mpwxscript`, `datadog:host:mpwxscript` and `k8s:node:mpwxscript` without losing the qualified forms anything already joined on.

    2. `adopt_domains` (`servers_coverage.py`) matches on the short form too, so an FQDN-registered row can finally adopt the domain Arc reports for it. Where the reported pair rebuilds the stored hostname exactly, the row also converges on the ISE-628 shape — short hostname, domain in its own field.

    **The rename turned out to be safe, which was the open question in the write-up.** `reconcile_discovered` matches on cross keys as well as the native key (`discovery.py:402`, `_entities_for_keys`), so the renamed row re-binds onto its existing entity through the cross keys instead of minting a second one. And `fqdn()` rebuilds the identical string, so what ISE dials never changes. Both are asserted in tests rather than left to reasoning.

    Guarded against the obvious misfire: a source reporting some other machine that merely shares a short name in a different domain is neither adopted nor renamed — there is a test for exactly that.

    Tests: 4 new (short-name keys published; no duplicate keys for an already-short hostname; FQDN row converges and still dials the same address; same-short-name-different-domain ignored). 90 pass across the three servers integration modules. Full CI green.

    Not verified on staging yet — `mpwxscript` will resolve once this deploys and the next servers sync republishes its aliases. Worth checking on the smoke test that the row also converged to `mpwxscript` + `moneypenny.local`, since that needs an Arc pass reporting it.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found 2026-08-09. An incident titled "Server **mpwxscript** has stopped responding" was analysed, and both agent runs concluded the host "resolves to no known entity" and "isn't registered anywhere in the estate".

**It is registered, and it is reachable.** From staging:

```
entity : host | mpwxscript.moneypenny.local
aliases: server:mpwxscript.moneypenny.local     (servers)
         k8s:node:mpwxscript.moneypenny.local   (servers)
         datadog:host:mpwxscript.moneypenny.local
         dns:mpwxscript.moneypenny.local
register: mpwxscript.moneypenny.local | domain=[] | reachable
```

**Every alias is the FQDN. There is no short-name alias, so `mpwxscript` resolves to nothing.**

**Why.** This server was registered with the FQDN *as its hostname*, before ISE-628 made the hostname short and the domain a separate field. `cross_keys_for` derives the short form only from the **reported identity hostname** (`identity['hostname']`), and this row's identity has no hostname key at all — so the short form was never published.

Two consequences, both live:

1. **The estate cannot resolve the short name.** Anything naming the machine the way a human does — an incident title, a DataDog host, a webhook payload, an operator asking Assist — misses. The agent then reports "not registered anywhere", which is worse than silence: it is confidently wrong, and it sent the operator to verify a host that was fine.
2. **It can never self-correct.** `adopt_domains` matches `RegisteredServer.hostname` exactly against what Arc reports (`mpwxscript`, short), so `mpwxscript.moneypenny.local` never matches and never adopts `moneypenny.local`. `_managed_hostnames` *does* add the short form, so Arc also stops proposing it — the machine is invisible to the very path that would fix it. It is stuck in the legacy shape permanently.

**Fix direction**
- `cross_keys_for` should publish the short form of the **registered hostname itself**, not only of a reported identity that may be absent. A machine named `a.b.c` is also known as `a`, whether or not it has ever answered a facts gather.
- `adopt_domains` (and the managed-hostname matching generally) should compare on the short form, so an FQDN-registered server converges on the ISE-628 shape — short hostname, domain in its own field — rather than being frozen out of it.
- Consider normalising at registration: if a hostname contains dots and no domain is set, split it. That is the ISE-628 model applied to the rows that predate it. Needs care — the hostname is the identity the estate joins on, so a rename has to carry its aliases.

**Acceptance**: an entity registered as `host.domain.tld` resolves from `host`; `mpwxscript` finds `mpwxscript.moneypenny.local`; and a server registered with an FQDN eventually carries a short hostname plus a domain without anyone re-registering it.