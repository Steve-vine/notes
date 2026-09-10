---
id: 01M25XG86R9ZST0S2M36SR4BDT
created: 2026-09-10T15:03:12.344308Z
updated: 2026-09-10T15:03:51.640914Z
type: task
title: Suppliers reach the Vendor Portal from the internet — a Cloudflare Tunnel into the production cluster
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 661
sprint: stek6vx
assignee: steve
label:
- feature
priority: high
task_status: todo
---
`env-production-uk-pri` has only internal load balancers and private DNS zones. Suppliers are outside the network, so the Vendor Portal (ADR 0051) needs a public front door. Decided 2026-09-10 with Steve: **Cloudflare Tunnel** (`cloudflared` in the cluster) fronting **https://vendor-portal.moneypenny.uk** and forwarding to the existing Traefik — no public load balancer, no inbound ports, Cloudflare terminates public TLS and applies WAF/rate limiting.

**Already known**: the public `moneypenny.uk` zone is on Cloudflare (NS `nolan`/`hope.ns.cloudflare.com`, checked 2026-09-10), so the tunnel's DNS route is a native Cloudflare record — no CNAME hop. Neither `vendor-portal.moneypenny.uk` nor `compass.moneypenny.uk` resolves publicly today. Depends on COM-660 (Compass installed).

**Steps**
1. Cloudflare: a named tunnel in the Moneypenny account, its credentials in Secrets Manager → `ExternalSecret` in a `cloudflared` namespace; `cloudflared` Deployment (2 replicas) with an ingress rule `vendor-portal.moneypenny.uk → http://<traefik service>.traefik.svc.cluster.local:80` (or https to 443 with `noTLSVerify` against the cert-manager cert — Traefik needs the Host header preserved so it routes to Compass's portal Ingress). Manifests under `scripts/infra/production/cloudflared/`. Check whether a cloudflared already runs in this cluster (Steve's notes mention one in another environment) before adding a second.
2. Compass: `vendorPortal.ingress.enabled: true`, `host: vendor-portal.moneypenny.uk`, same TLS secret as the main host (the ClusterIssuer must be able to issue for a public name — DNS-01 via Cloudflare, the zone is there; otherwise TLS between cloudflared and Traefik is internal and the portal Ingress can be plain HTTP behind the tunnel). `config.vendorPortalBaseUrl` already set. Cloudflare: "Full" TLS mode, a rate-limit rule on `/api/v1/vendor-portal/*` (ADR 0051 wanted rate limiting that must not touch employees — the tunnel host is exactly that boundary).
3. Only the portal host goes through the tunnel; `compass.moneypenny.uk` stays internal. Verify from off-network: the portal answers, the employee app does not.

**Acceptance**: a supplier invitation link opens from a phone off the network; `https://compass.moneypenny.uk` does not resolve/answer publicly; the tunnel survives a cloudflared pod restart.