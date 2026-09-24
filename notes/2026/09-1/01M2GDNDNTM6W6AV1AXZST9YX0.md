---
id: 01M2GDNDNTM6W6AV1AXZST9YX0
created: 2026-09-14T16:58:03.322395Z
updated: 2026-09-24T20:29:38.997035Z
type: task
title: The chart renders one Service and takes no view on how it is surfaced
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 710
sprint: stek6vx
comments:
- id: 01M2GS7FR0VRM36DM226V9132Y
  author: Steve Vine
  at: 2026-09-14T20:20:09.600295Z
  text: 'Merged to main 2026-09-14 20:15 as 05b7dc6 (PR #718). Ingress off by default, `ingress.className` empty by default (staging/production set traefik), `frontend.service.type`/`.annotations` values, the three Valkey URLs derived into the ConfigMap when Valkey is bundled (asked for in the Secret only when external; a supplied value still wins because the Secret is later in envFrom). The secret contract is now the two ADR 0073 §3 values: staging overlay dropped the URLs, production''s external-secret.yaml carries two keys, setup.sh stops creating the other three. Redis Cluster mode constraint documented. NOTES print the port-forward route when no Ingress renders and warn, naming `config.auth.cookieSecure`, when it is on and nothing suggests HTTPS (verified in four shapes with a client dry-run).'
assignee: steve
label:
- improvement
priority: high
task_status: done
tech: null
---
ADR 0073 §2 and §4. Everything reaches Compass through one ClusterIP Service, `<release>-frontend:80` — nginx in the frontend pod proxies `/api/*` internally, so nothing outside the namespace needs to know the API exists. How that Service becomes reachable is the operator's choice: a port-forward, a Cloudflare Tunnel, an Ingress, a LoadBalancer, a Gateway API route.

**Steps**

1. **Ingress off by default.** It currently defaults on with host `compass.local`, so every evaluation install creates a dead Ingress for a hostname nobody resolves. Production and staging set it on explicitly.
2. **`ingress.className` defaults to empty**, not `traefik` — an empty class uses the cluster's default controller, and naming one controller in the chart's defaults is exactly the coupling ADR 0073 removes.
3. **`frontend.service.type`** becomes a value (ClusterIP default, LoadBalancer or NodePort available) for anyone who wants the Service itself to be the surface.
4. **Derive the three Valkey URLs** when `valkey.enabled` (§4). The chart generates the Service name and then makes the installer type it back in three times with the correct database number on each, failing the install when they get it wrong — a question only the chart knows the answer to. They stay overridable, and remain required when Valkey is external.
5. **Document the Redis Cluster mode constraint** (§6): Compass uses three numbered databases (0 broker, 1 results, 2 sessions), and cluster mode has none — so ElastiCache and Memorystore work in single-node or replication-group mode only.
6. **Warn in `NOTES.txt` when `auth.cookieSecure` is on and nothing suggests the browser will see HTTPS** (§8). The chart cannot refuse the combination, because TLS legitimately terminates upstream — but the silent failure it prevents is nasty: the login form accepts the password, the API returns success, the browser discards the cookie, and the user lands back at the login screen with no error and nothing in the logs. Note too that SSO needs HTTPS except on `http://localhost`.

**Acceptance**: `helm install compass --set ingress.enabled=false` then `kubectl port-forward svc/compass-frontend 8080:80` reaches a working Compass with no other values set; installing over HTTP with `cookieSecure` left on prints a warning that names the setting.