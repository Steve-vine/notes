---
id: 01KYF6VXGT6DDJ1834ZP9PWNWQ
created: 2026-07-26T12:37:14.39483Z
updated: 2026-08-05T11:55:31.363407Z
type: task
title: Host PyPI + npm mirrors on g5 (like zot for images)
project: 01KX671DATY39VW6GWK3M2T3DN
number: 315
sprint: sr2f21y
comments:
- id: 01KYF9ZAJV6ZBSVTYXXCRZHBZE
  author: Steve Vine
  at: 2026-07-26T13:31:31.803257Z
  text: |-
    Done (with one deliberate scope split) — PR #273 (feature/ise-315-ci-mirrors), applied live to the ci-cache namespace.

    npm → Verdaccio: DELIVERED and validated end-to-end.
    - Deployed Verdaccio (npmjs uplink, caching) in ci-cache; ci.yml points npm_config_registry at it in the frontend + api-types jobs.
    - This PR's own frontend + api-types jobs ran green through it, and Verdaccio's storage is now populated with the real deps (@babel, @redocly, change-case, …) — proof it served the installs on-LAN. npm rewrites the lockfile's registry.npmjs.org URLs to the configured registry, so installs stay reproducible. Acceptance met for npm: tarballs served from the LAN mirror, none from registry.npmjs.org.

    devpi → uv (PyPI): deployed but deliberately NOT wired — this is the important finding.
    - The task assumed "point uv at UV_INDEX." I tested it: uv.lock pins absolute files.pythonhosted.org URLs for all 611 artifacts, and uv sync --frozen fetches those exact URLs. UV_DEFAULT_INDEX only affects *resolution*, which --frozen skips. Verified in-cluster: with UV_DEFAULT_INDEX=devpi, uv sync --frozen still downloaded from files.pythonhosted.org. So an index override is a no-op for our frozen installs — the mirror would sit idle.
    - The only ways to actually route uv through the mirror are (a) rewrite every lockfile URL to devpi (couples the repo to internal infra, breaks off-cluster local dev) or (b) a TLS-terminating transparent proxy for files.pythonhosted.org (supply-chain MITM + a trusted CA on the runners). Neither is worth it.
    - The PyPI cold-start is instead addressed by ISE-316 (local Actions cache proxy keeps uv's *download cache* on-LAN, so warm runs do zero pythonhosted fetches and the slow cross-internet cache restore goes away). devpi is left running (cheap, 1/1) in case we later want the lock-regen approach; scripts/infra/ci-cache/README.md documents the full rationale and how to remove it.

    Net: npm external dependency removed; the PyPI external dependency is handled by ISE-316 rather than a devpi index-override that can't work. Flagging the devpi decision for your call — happy to tear it down if you'd rather not keep unused infra.
assignee: steve
priority: high
task_status: done
---
`uv sync` (**193s**) and `npm ci` hit public PyPI / npm.org directly — external, slow, blocking, and the same failure class as the ryuk/Docker-Hub hang ([[ise-ci-ryuk-dockerhub-throttle]]). Stand up a caching **PyPI mirror** (devpi or bandersnatch) and an **npm proxy** (Verdaccio) in-cluster alongside zot; point uv at it (`UV_INDEX` / `index-url`) and npm at it (`.npmrc` `registry=`). Removes two external blocking deps and cuts cold-start install time.

Acceptance: install steps served from the LAN mirror; no pypi.org / registry.npmjs.org in build logs.