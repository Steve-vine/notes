---
id: 01M0MZWG4TCGRNPY67KQTWG2GP
created: 2026-08-22T15:02:03.674362Z
updated: 2026-08-22T15:02:16.224223Z
type: task
title: Vendor Portal ingress on staging — vendor-portal.citops.net, and wire the base URL
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 360
sprint: sbph5q5
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