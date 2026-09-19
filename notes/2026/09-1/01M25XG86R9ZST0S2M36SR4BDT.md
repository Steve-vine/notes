---
id: 01M25XG86R9ZST0S2M36SR4BDT
created: 2026-09-10T15:03:12.344308Z
updated: 2026-09-19T16:42:11.798124Z
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
- id: 01M2X8QVJN9PP74T0QP5KFPFSV
  author: Steve Vine
  at: 2026-09-19T16:42:07.828978Z
  text: |-
    2026-09-19 progress. Steve confirmed the tunnel targets the Traefik Service over plain HTTP (`http://cluster-envproductionukpri-rel-traefik.traefik.svc.cluster.local`); Traefik routes on Host, the namespaced Ingress takes over.

    **App side — merged to main as 50f1078 (PR #737), unreleased.** nginx is host-aware: under the host in `config.vendorPortalBaseUrl` only `/vendor-portal…`, `/api/vendor-portal/…`, `/assets/`, `/favicon.svg` are served, the rest 404. The chart's own portal Ingress lists only those paths. `scripts/ci/check-portal-host-boundary.sh` (Docker, run by hand) — 18/18. ADR 0051 §6 amended; install guide updated. `GET /api/v1/appearance` turned out to need sign-in (suppliers already got 401), so it is NOT on the allow-list.

    **Devops side — edited in `~/code/devops.application.compass`, NOT committed.** base/ ingress template gains optional `paths`, `tls: false` (no tls section, no Certificate — a TLS router never matches the plain HTTP the tunnel delivers to Traefik's web entrypoint) and optional `dnsProvider` (omitted: the record is the tunnel's, external-dns must not touch it). New entry `compass-vendor-portal` for vendor-portal.moneypenny.uk with the four paths; app values set `vendorPortalBaseUrl`. Rendered diff = one new Ingress + one ConfigMap value; existing ingress and certificate untouched. Works with 0.3.0 — the ingress alone enforces the boundary until the next release adds the app-side rule.

    **Steve's part**: Cloudflare public hostname vendor-portal.moneypenny.uk → the tunnel (same Traefik service URL), rate-limit rule on `/api/vendor-portal/*`; commit + push the devops change. Then verify off-network: an invitation link opens; `/login` and `/api/v1/auth/login` on the portal host are 404; compass.moneypenny.uk does not answer publicly.
assignee: steve
label:
- feature
priority: high
task_status: active
---
`env-production-uk-pri` has only internal load balancers and private DNS zones. Suppliers are outside the network, so the Vendor Portal (ADR 0051) needs a public front door. Decided 2026-09-10 with Steve: **Cloudflare Tunnel** (`cloudflared` in the cluster) fronting **https://vendor-portal.moneypenny.uk** and forwarding to the existing Traefik — no public load balancer, no inbound ports, Cloudflare terminates public TLS and applies WAF/rate limiting.

**Already known**: the public `moneypenny.uk` zone is on Cloudflare (NS `nolan`/`hope.ns.cloudflare.com`, checked 2026-09-10), so the tunnel's DNS route is a native Cloudflare record — no CNAME hop. Neither `vendor-portal.moneypenny.uk` nor `compass.moneypenny.uk` resolves publicly today. Depends on COM-660 (Compass installed).

**Steps**
1. Cloudflare: a named tunnel in the Moneypenny account, its credentials in Secrets Manager → `ExternalSecret` in a `cloudflared` namespace; `cloudflared` Deployment (2 replicas) with an ingress rule `vendor-portal.moneypenny.uk → http://<traefik service>.traefik.svc.cluster.local:80` (or https to 443 with `noTLSVerify` against the cert-manager cert — Traefik needs the Host header preserved so it routes to Compass's portal Ingress). Manifests under `scripts/infra/production/cloudflared/`. Check whether a cloudflared already runs in this cluster (Steve's notes mention one in another environment) before adding a second.
2. Compass: `vendorPortal.ingress.enabled: true`, `host: vendor-portal.moneypenny.uk`, same TLS secret as the main host (the ClusterIssuer must be able to issue for a public name — DNS-01 via Cloudflare, the zone is there; otherwise TLS between cloudflared and Traefik is internal and the portal Ingress can be plain HTTP behind the tunnel). `config.vendorPortalBaseUrl` already set. Cloudflare: "Full" TLS mode, a rate-limit rule on `/api/v1/vendor-portal/*` (ADR 0051 wanted rate limiting that must not touch employees — the tunnel host is exactly that boundary).
3. Only the portal host goes through the tunnel; `compass.moneypenny.uk` stays internal. Verify from off-network: the portal answers, the employee app does not.

**Acceptance**: a supplier invitation link opens from a phone off the network; `https://compass.moneypenny.uk` does not resolve/answer publicly; the tunnel survives a cloudflared pod restart.