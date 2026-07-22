---
id: 01KY2SAJV75BV7B0HGKNJF2SBH
created: 2026-07-21T16:49:41.735339Z
updated: 2026-07-22T11:45:41.540534Z
type: task
title: Validate kubeconfig credentials at store time
project: 01KX671DATY39VW6GWK3M2T3DN
number: 199
sprint: sohzsw2
assignee: steve
label: null
priority: medium
task_status: done
---
**Found testing AI resolution on g5 (2026-07-21):** an approved `edit_resource` fix failed with `mapping values are not allowed here … certificate-authority-data …` — the stored **write** credential's kubeconfig had its newlines mangled at paste time and had never been valid. Detection worked (read credential is fine), so the corrupt secret was only discovered at execution time, mid-remediation, when `build_client` ran `yaml.safe_load(secret["kubeconfig"])` (`connectors/kubernetes.py`).

`PUT /api/v1/credentials` accepts any string, so a kubeconfig that can never parse is stored silently.

**Fix:** validate at store time, not execution time. Connector-declared validation for credential fields — for `kubeconfig`: parses as YAML and looks like a kubeconfig (has `clusters`/`contexts`/`users`) — surfaced as a clear error in the credential form. Ideally also run the connector's health check against the new secret before binding (a wrong-but-parseable kubeconfig fails there). Applies to both read and write credentials via the existing RotateCredentialModal path.