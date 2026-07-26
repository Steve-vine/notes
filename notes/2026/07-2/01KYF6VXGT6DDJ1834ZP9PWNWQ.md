---
id: 01KYF6VXGT6DDJ1834ZP9PWNWQ
created: 2026-07-26T12:37:14.39483Z
updated: 2026-07-26T12:38:12.610053Z
type: task
title: Host PyPI + npm mirrors on g5 (like zot for images)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 315
sprint: sr2f21y
assignee: steve
label:
- improvement
priority: high
task_status: backlog
---
`uv sync` (**193s**) and `npm ci` hit public PyPI / npm.org directly — external, slow, blocking, and the same failure class as the ryuk/Docker-Hub hang ([[ise-ci-ryuk-dockerhub-throttle]]). Stand up a caching **PyPI mirror** (devpi or bandersnatch) and an **npm proxy** (Verdaccio) in-cluster alongside zot; point uv at it (`UV_INDEX` / `index-url`) and npm at it (`.npmrc` `registry=`). Removes two external blocking deps and cuts cold-start install time.

Acceptance: install steps served from the LAN mirror; no pypi.org / registry.npmjs.org in build logs.