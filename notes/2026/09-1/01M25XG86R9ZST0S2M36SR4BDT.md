---
id: 01M25XG86R9ZST0S2M36SR4BDT
created: 2026-09-10T15:03:12.344308Z
updated: 2026-09-19T16:13:59.93677Z
type: task
title: Suppliers reach the Vendor Portal from the internet — a Cloudflare Tunnel into the production cluster
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 661
sprint: stek6vx
blocked_by:
- 01M25XFVN7K31K9ABNXZCXQB27
comments:
- id: 01M2X74B802N5HC1X1BSP6MPZJ
  author: Steve Vine
  at: 2026-09-19T16:13:59.936661Z
  text: |-
    Reviewed 2026-09-19 after go-live (production is now Argo CD from devops.application.compass; the employee app is internal-only via Twingate; the chart's own Ingresses are off there, ingress comes from the devops repo's base/ chart).

    **Finding that changes the task.** The Vendor Portal host, as built (chart `ingress-vendor-portal.yaml`, and the devops base/ ingress template alike), routes `/` to the one frontend Service. nginx there is `server_name _`, serves the whole SPA and proxies all of `/api/`. So publishing vendor-portal.moneypenny.uk through the tunnel would publish the employee sign-in page, password reset, SSO start and the entire `/api/v1` to the internet — exactly what keeping compass.moneypenny.uk internal is meant to prevent. ADR 0051 §6 said the host is "not isolation"; that was acceptable when both hosts were equally reachable, and is not now.

    **What the portal actually needs** (checked in the frontend): pages under `/vendor-portal`; API under `/api/vendor-portal/`; the static bundle (`/assets/`, favicon, index.html); and the theme read `GET /api/v1/appearance` that every page load makes. Nothing else.

    **Proposed shape**
    1. App (compass repo, needs a release): nginx becomes host-aware — when the request's Host is the portal host (`config.vendorPortalBaseUrl`), only the allow-list above is served; everything else 404. Enforced inside the app, so it holds however the operator routes traffic (tunnel, ingress, port-forward) and for every install, not only ours. ADR 0051 gets a dated amendment.
    2. Devops repo (no release needed, belt and braces): base/ ingress template accepts a `paths` list; a second ingress entry `compass-vendor-portal` for vendor-portal.moneypenny.uk with only `/vendor-portal`, `/api/vendor-portal`, `/assets` (+ the appearance read), `dnsProvider: cloudflare` per the Chinwag `-ext` precedent. App values: `config.vendorPortalBaseUrl: https://vendor-portal.moneypenny.uk`.
    3. Cloudflare side (Steve): public hostname on the tunnel → Traefik, Host header preserved; rate-limit rule on `/api/vendor-portal/*`.
    4. Verify from off-network: an invitation link opens; `/login` and `/api/v1/auth/*` on the portal host return 404; compass.moneypenny.uk does not resolve publicly.

    The original steps' `scripts/infra/production/cloudflared/` location is obsolete (COM-722) — cluster manifests belong in the devops repos.
assignee: steve
label:
- feature
priority: high
task_status: backlog
---
`env-production-uk-pri` has only internal load balancers and private DNS zones. Suppliers are outside the network, so the Vendor Portal (ADR 0051) needs a public front door. Decided 2026-09-10 with Steve: **Cloudflare Tunnel** (`cloudflared` in the cluster) fronting **https://vendor-portal.moneypenny.uk** and forwarding to the existing Traefik — no public load balancer, no inbound ports, Cloudflare terminates public TLS and applies WAF/rate limiting.

**Already known**: the public `moneypenny.uk` zone is on Cloudflare (NS `nolan`/`hope.ns.cloudflare.com`, checked 2026-09-10), so the tunnel's DNS route is a native Cloudflare record — no CNAME hop. Neither `vendor-portal.moneypenny.uk` nor `compass.moneypenny.uk` resolves publicly today. Depends on COM-660 (Compass installed).

**Steps**
1. Cloudflare: a named tunnel in the Moneypenny account, its credentials in Secrets Manager → `ExternalSecret` in a `cloudflared` namespace; `cloudflared` Deployment (2 replicas) with an ingress rule `vendor-portal.moneypenny.uk → http://<traefik service>.traefik.svc.cluster.local:80` (or https to 443 with `noTLSVerify` against the cert-manager cert — Traefik needs the Host header preserved so it routes to Compass's portal Ingress). Manifests under `scripts/infra/production/cloudflared/`. Check whether a cloudflared already runs in this cluster (Steve's notes mention one in another environment) before adding a second.
2. Compass: `vendorPortal.ingress.enabled: true`, `host: vendor-portal.moneypenny.uk`, same TLS secret as the main host (the ClusterIssuer must be able to issue for a public name — DNS-01 via Cloudflare, the zone is there; otherwise TLS between cloudflared and Traefik is internal and the portal Ingress can be plain HTTP behind the tunnel). `config.vendorPortalBaseUrl` already set. Cloudflare: "Full" TLS mode, a rate-limit rule on `/api/v1/vendor-portal/*` (ADR 0051 wanted rate limiting that must not touch employees — the tunnel host is exactly that boundary).
3. Only the portal host goes through the tunnel; `compass.moneypenny.uk` stays internal. Verify from off-network: the portal answers, the employee app does not.

**Acceptance**: a supplier invitation link opens from a phone off the network; `https://compass.moneypenny.uk` does not resolve/answer publicly; the tunnel survives a cloudflared pod restart.