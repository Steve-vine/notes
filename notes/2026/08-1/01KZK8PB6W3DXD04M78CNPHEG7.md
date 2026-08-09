---
id: 01KZK8PB6W3DXD04M78CNPHEG7
created: 2026-08-09T12:41:48.508935Z
updated: 2026-08-09T12:42:12.131141Z
type: task
title: Registrations from Discovery use short names and fail DNS — Arc's FQDN is parsed and thrown away
project: 01KX671DATY39VW6GWK3M2T3DN
number: 628
sprint: sesjg7z
assignee: steve
label:
- bug
priority: high
task_status: todo
---
Found by Steve 2026-08-09 on the first real registration from Discovery. `mpwxdc02` was managed with the right profile and failed:

```
unresolvable_name — ntlm: HTTPConnectionPool(host='mpwxdc02', port=5985)
registered: mpwxdc02  addr=''  state=unreachable/unresolvable_name
```

The categorisation and the advice were right. The registration should never have been made that way.

**ISE had the answer and discarded it.** That candidate came from **Arc**, and the Arc payload carries it:

```
MPWXDC02 -> displayName: "MPWXDC02"
            dnsFqdn:     "MPWXDC02.moneypenny.local"
            domainName:  "moneypenny.local"
arc machines with dnsFqdn: 39/39
```

`servers_coverage.collect_arc_candidates` reads `displayName` and drops `dnsFqdn`, so **all 39 Arc candidates register under a name the worker cannot resolve**. Same shape as [ISE-622]: a connector parsing a payload and throwing away the field that mattered.

**Fix 1 — use what Arc gives (free, covers 39 machines).** Put `dnsFqdn` in the candidate's `address`, not its `hostname`. That distinction is deliberate and worth preserving: hostname is IDENTITY — what the estate joins on, what Entra and Arc dedupe against each other with, what `mpwxveeambr` matched on — while `address` is "where to actually connect", which is exactly what the field was added for. Making the FQDN the hostname would silently break candidate dedupe between Arc and Entra, which report short names.

**Fix 2 — a declared DNS suffix for sources that cannot supply one.** Entra devices carry no domain at all (`onPremisesSyncEnabled` is null across all 2,005, so nothing is AD-sourced), so an Entra-only machine has no FQDN to read. Proposal: a `dns_suffix` on the **connection profile**. A profile already groups machines that share a way in, and those machines almost always share a domain. When a registered hostname has no dot and the profile has a suffix, connect to `<hostname>.<suffix>`. Declared configuration, not a guess, and no code change when a second domain appears.

Alternative worth weighing: a cluster-level DNS search domain in the Helm chart. Fixes everything at once and needs no per-profile setting, but only works if the pod's resolver can reach the AD DNS servers, and it puts environment specifics in the deployment rather than in something an operator can see. Decide between them before building.

**Fix 3 — the bulk Manage modal cannot set an address at all.** `BulkRegisterBody` has no address field and the modal offers none, so there is currently no way to produce a working registration from Discovery in one pass: you register, watch it fail, then edit the server. Whatever fix 2 lands as should be reachable from that modal.

**Immediate workaround for the stuck row**: edit `mpwxdc02` on the Fleet tab and set the address override to `mpwxdc02.moneypenny.local`, then retry. Server editing works; it is profile editing that is broken ([ISE-627]).

**Acceptance**: registering an Arc candidate connects first time with no manual step; an Entra-only candidate connects once its profile carries a suffix; candidate dedupe between Arc and Entra still matches on the short name.