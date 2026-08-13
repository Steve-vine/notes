---
id: 01KZXJBCH3AHBX6G1E330H088E
created: 2026-08-13T12:42:59.491513Z
updated: 2026-08-13T16:38:04.693726Z
type: task
title: A denied metrics read says "no permission", not "install metrics-server"
project: 01KX671DATY39VW6GWK3M2T3DN
number: 685
sprint: sevhjex
comments:
- id: 01KZXZSV3B066D7N1TPEXBRWTP
  author: Steve Vine
  at: 2026-08-13T16:38:04.651667Z
  text: |-
    2026-08-13 — DONE, PR #636 merged to main.

    **The fix.** `_api_reason` classifies by status once, and every Kubernetes read that used to guess now calls it:

    - 403 → "the cluster credential is not permitted to read {what} (403 denied). Re-run the ISE cluster role against this cluster, or check the credential bound to this System — the cluster itself is fine."
    - 401 → the credential "has expired or been revoked" (a case the task did not name, but it is a third distinct fix and was also being reported as "install metrics-server")
    - 404 → the original install wording, kept: metrics.k8s.io is served by an APIService metrics-server registers, so 404 is the one status that really does mean absent
    - anything else → the status and reason quoted, never interpreted. Deliberately never "unknown error" — an operator can act on a status and cannot act on a shrug.

    `ok=False` in every branch, unchanged (ADR 0031). This was only ever about which fact.

    **The sweep found two more, both the same shape.**

    1. `count_objects` collapsed every failure into −1, and the gaps card drew that as the bare "objects are invisible" — one word from the "34 objects are invisible" beside it, with nothing to say the read had been DENIED. A fixable RBAC problem read as an empty kind. It returns an `ObjectCount(count, unavailable)` now, and `KindGapItem` gained `count_unavailable`. **Optional with a default** — a mandatory backend field is exactly how two of three callers broke under a green suite three days ago (ISE-686/687).
    2. `check_kind` reported `str(exc)`, so a denial reached the operator as the kubernetes client's own `"(403)\nReason: Forbidden"`. It names no credential, no kind and no fix.

    **The finding that matters most for next time: the test fake was hiding all of this.** `make_apis(custom_forbidden=…)` raised a `RuntimeError`, not an `ApiException`. Every "RBAC degradation" test in the suite — and there are several, going back to ISE-257 — was exercising a path that a real denial never takes. Swapping it to `ApiException(status=403)` is what surfaced `check_kind` at all; two integration assertions changed as a direct result. A fake that is wrong about the *shape* of a failure buys nothing, and here it bought three years of confidence in an untested branch.

    Verified: full backend suite 3420 passed locally; ruff, mypy strict, prettier, eslint, tsc build, api-types regen all green; PR CI green including the 9m43s integration job.

    Still true after this: on any cluster whose credential predates the ISE-684 re-run, the metrics read still 403s — it just now says so correctly.
assignee: steve
label:
- bug
priority: medium
task_status: review
---
`_ev_pod_resource_usage` (`app/backend/src/ISE_api/connectors/kubernetes.py:2913`) catches every `ApiException` from the `metrics.k8s.io` call and renders one verdict:

```
metrics-server unavailable (403): install it to answer live-usage questions
```

A 403 is RBAC. Only a 404 (or a missing APIService) means metrics-server is genuinely absent. Today the connector confidently sends the operator to install a component that is already running — verified on g5, where `v1beta1.metrics.k8s.io` reports `Available=True` while the ISE credential is denied `list pods.metrics.k8s.io`. The message is not a near-miss; it names the wrong system and the wrong fix, and this is the third time a confidently-wrong error has cost real diagnosis time (the gitleaks-license/DNS case, the timeout-cluster case).

**Scope**
- Branch on `exc.status`: 403 → name the permission the credential lacks and point at the cluster credential, not at metrics-server; 404 → the existing "install it" wording; anything else → the status and reason as themselves.
- The evidence result stays `ok=False` in every branch — a fact about the cluster, per ADR 0031. This is about which fact.
- Sweep the connector's other broad `except` blocks for the same conflation before closing: `count_objects` swallows a 403 into `-1`, so "34 objects are invisible" and "you cannot see whether any objects exist" read identically to the operator.

This is user-facing text — it lands in evidence results during an investigation and, via the Platform Log, on a screen. It carries this sprint's UI deliverable.

Independent of ISE-684: the wildcard grant makes a metrics 403 unlikely, but the message would still be wrong on any cluster whose credential predates the re-run, and the status-code conflation is the actual defect.