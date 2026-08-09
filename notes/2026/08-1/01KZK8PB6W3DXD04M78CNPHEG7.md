---
id: 01KZK8PB6W3DXD04M78CNPHEG7
created: 2026-08-09T12:41:48.508935Z
updated: 2026-08-09T12:53:05.881126Z
type: task
title: Registered servers carry their own domain name — populated by discovery, editable per record and in bulk
project: 01KX671DATY39VW6GWK3M2T3DN
number: 628
sprint: sesjg7z
assignee: steve
label:
- bug
priority: high
task_status: todo
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