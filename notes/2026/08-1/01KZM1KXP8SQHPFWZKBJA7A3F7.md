---
id: 01KZM1KXP8SQHPFWZKBJA7A3F7
created: 2026-08-09T19:57:23.528918Z
updated: 2026-08-09T19:58:02.070662Z
type: task
title: A server registered by its FQDN is unreachable by its short name across the whole estate
project: 01KX671DATY39VW6GWK3M2T3DN
number: 633
sprint: s1rgnyx
assignee: steve
label:
- bug
priority: high
task_status: backlog
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