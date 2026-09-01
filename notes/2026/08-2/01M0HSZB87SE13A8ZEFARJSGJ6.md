---
id: 01M0HSZB87SE13A8ZEFARJSGJ6
created: 2026-08-21T09:21:02.215397Z
updated: 2026-09-01T13:55:50.517529Z
type: task
title: Investigate uplink DNS failures from CI; add node-local DNS cache
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 328
sprint: sspwpgk
comments:
- id: 01M0JWPBW4WTX9Y4K28KKJEF4K
  author: Steve Vine
  at: 2026-08-21T19:27:48.10028Z
  text: |-
    Done — PR #318, squash-merged to main 2026-08-21. Applied to the cluster and verified.

    Two causes behind the resolution failures, both found while the uplink happened to be flapping mid-sprint.

    The first is the one worth remembering: zot.citops.net, compass.citops.net and g5.citops.net are PUBLIC DNS records, and all three point at 192.168.1.5 — the node itself. So pulling an image from the registry running on this machine, or smoke-checking the app running on this machine, first required a working uplink. Proven with the WAN down: `curl https://zot.citops.net/v2/` failed, and the same request with `--resolve` pinned to 192.168.1.5 returned 200. Nothing had to leave the building; only the name did. My own kubectl was failing the same way on g5.citops.net.

    Second: CoreDNS's `forward . /etc/resolv.conf` resolves to 192.168.1.1 — the consumer router — while the host itself resolves via 1.1.1.1 and 8.8.8.8. Pods and host have disagreed since the host's resolvers changed, and pods got the weaker of the two; the router's timeouts are in the CoreDNS error log.

    Fix: a `coredns-custom` ConfigMap (k3s's supported extension point, so it survives a k3s restart, unlike editing the `coredns` ConfigMap directly) with two server blocks — the three names answered locally from a hosts block with fallthrough, and CI's external dependencies given three forwarders plus `serve_stale 86400s immediate`. serve_stale is the point: when every upstream is failing, CoreDNS keeps answering from expired entries instead of returning SERVFAIL.

    Verified from inside a pod after applying: all three citops.net names, github.com, files.pythonhosted.org and a cluster-internal Service name all resolve.

    Two things deliberately NOT done, both in the README:

    1. The host-side half needs root. containerd and kubelet use the host resolver, not CoreDNS — which is why runner pods could not start at all today ("lookup ghcr.io: Try again"). COM-327 removed the worst consequence by moving the runner image into zot. The rest is a one-line /etc/hosts entry; Steve is adding it (note `!`-prefixed sudo has no TTY, so it needs a real terminal).

    2. NodeLocal DNSCache, which the task proposed, is declined with reasons. It is the right tool when pods are a network hop from CoreDNS and conntrack pressure is the problem — neither is true here. g5 is a single node, so CoreDNS already runs beside every pod that queries it, and adopting it means repointing kubelet's --cluster-dns and restarting k3s to buy resilience serve_stale gives for a ConfigMap. Revisit if g5 gains a second node.
- id: 01M0K33A5SYNFPJCJ52JKYEQ54
  author: Steve Vine
  at: 2026-08-21T21:19:43.80145Z
  text: |-
    Host-side half now applied by Steve and verified 2026-08-21:

      /etc/hosts:  192.168.1.5 zot.citops.net compass.citops.net g5.citops.net

    getent now returns 192.168.1.5 for all three, and `kubectl` against the public
    g5.citops.net name — which had been failing intermittently all day with
    "dial tcp: lookup g5.citops.net: Try again" — works again.

    That closes the gap the ConfigMap could not: containerd and kubelet use the
    host resolver, not CoreDNS, so image pulls (including the runner image itself)
    were still going out to public DNS to resolve a name pointing at this machine.
    Both halves are now in place — pods via CoreDNS, host via /etc/hosts.
assignee: steve
label:
- chore
priority: medium
task_status: done
---
Repeated `getaddrinfo EAI_AGAIN` (nodejs.org, files.pythonhosted.org) from runner pods under load — cluster DNS or NAT wobbling, same neighbourhood as the historical MTU issue. Diagnose CoreDNS/forwarder behaviour under CI load; consider NodeLocal DNSCache on g5. Largely mitigated once the runner image bakes its toolchain, but the uplink itself should be steady.