---
id: 01M0MZWG4TCGRNPY67KQTWG2GP
created: 2026-08-22T15:02:03.674362Z
updated: 2026-08-22T15:15:31.007684Z
type: task
title: Vendor Portal ingress on staging — vendor-portal.citops.net, and wire the base URL
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 360
sprint: sbph5q5
comments:
- id: 01M0N0N4HZJA0KJXSKB82K411H
  author: Steve Vine
  at: 2026-08-22T15:15:31.007497Z
  text: |-
    Done — PR #362, merged to main.

    `vendor-portal.citops.net` renders identically to `compass.citops.net`: same `ingressClassName`, same TLS secret, same backend Service, same single `/` path rule. Steve created the A record (→ 192.168.1.5, same as compass).

    **The gap this closed.** COM-358 added `vendor_portal_base_url` to `core/config.py` and the guard that refuses to start an assessment without it, but never wired it into the chart — no values key, no configmap line. Confirmed against the running pod: `APP_BASE_URL` present, nothing else. The setting was unsettable through a deploy, so an enabled ingress alone would have served a portal that Start Assessment still refuses to invite anyone to. `VENDOR_PORTAL_BASE_URL` now sits beside `APP_BASE_URL`, deliberately its own value rather than derived.

    **A correction worth recording.** The first version of this said a missing A record would stall cert-manager's HTTP-01 challenge, and that the DNS record therefore had to exist before deploying. Wrong on both counts — the ClusterIssuer solves **DNS-01 through Cloudflare**, so the certificate is issued from a `_acme-challenge` TXT record in the zone and never needs the host to resolve. Deploying first is actually the better order: TLS comes up ready and the portal works the moment DNS propagates, with no redeploy.

    That also strengthened the one-certificate-two-SANs call rather than weakening it. The worry was that coupling the names could block renewal of `compass.citops.net` if the vendor host failed validation. With DNS-01 both names are in the same zone behind the same API token, so they genuinely do succeed or fail together — a second Certificate would add a renewal clock and buy no isolation, because the one thing that could break issuance breaks both anyway.

    Prod carries the keys, disabled: no hostname yet, and a resolving supplier surface nobody has been invited to is a surface for no benefit.

    Deploying will trigger a fresh Let's Encrypt order for the 2-name certificate, replacing one that was healthy with ~6 weeks left (expiry was 2026-10-03). Routine, but it is a real issuance and it touches the employee app's live TLS.
assignee: steve
label:
- chore
priority: medium
task_status: active
---
COM-357 shipped `chart/templates/ingress-vendor-portal.yaml` but left it off by default, so staging has one ingress (`compass.citops.net`) and the Vendor Portal is unreachable. Turn it on at **vendor-portal.citops.net**. Steve creates the DNS A record.

## The gap this also closes

COM-358 added `vendor_portal_base_url` to `core/config.py` and the guard that refuses to start an assessment without it — but **never wired it into the chart**. There is no `values.yaml` key and no `configmap.yaml` line, so the pod env has `APP_BASE_URL` and nothing else, and the setting is currently *unsettable* through a deploy. Without this the new ingress would serve a portal that Start Assessment still refuses to send anyone to.

- [ ] `values.yaml`: `config.vendorPortalBaseUrl` (empty default) + `VENDOR_PORTAL_BASE_URL` in `configmap.yaml`, mirroring how `appBaseUrl` / `APP_BASE_URL` are done.
- [ ] `values-staging.yaml`: `vendorPortal.ingress` enabled, host `vendor-portal.citops.net`, TLS on; `config.vendorPortalBaseUrl: https://vendor-portal.citops.net`.
- [ ] TLS: add the host to `tls.certificate.additionalDnsNames` and point the vendor ingress at the existing `compass-tls` secret — the template already supports it, so one cert with two SANs rather than a second Certificate and a second renewal to watch.
- [ ] `values-prod.yaml`: carry the keys, left disabled — prod has no host yet and a resolving supplier surface nobody asked for is a surface for no benefit.
- [ ] Verify with `helm template` that staging renders **two** Ingresses and the ConfigMap carries the new key.

Deploy is blocked on the DNS record existing, or cert-manager's HTTP-01 challenge fails and the Certificate goes into retry.