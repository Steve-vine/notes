---
id: 01KYT8SA3Z223PKQYASJ41AEPZ
created: 2026-07-30T19:42:24.895625Z
updated: 2026-08-05T14:25:38.52971Z
type: task
title: Cloudflare surface — account card, entity display, brief update, live smoke
project: 01KX671DATY39VW6GWK3M2T3DN
number: 385
sprint: s39ax46
blocked_by:
- 01KYT8RMC8S3K8E5BPVEZEFE43
comments:
- id: 01KYTGYMX8NDH9G93TVXZH1KV1
  author: Steve Vine
  at: 2026-07-30T22:05:08.392638Z
  text: |-
    Built and in review — PR #360 (feature/ise-385-cloudflare-surface, stacked on #359, targeting main), merged to staging (ef8a6e8).

    Delivered: the pane-of-glass slice. Cloudflare account card on System detail via GET /systems/{id}/cloudflare-summary (AWS/Azure card pattern — account id off the scoped aliases, discovered resource counts, firing alert count, all read from ISE's own record with no Cloudflare round-trip). The card copy makes the alert semantics honest per the plan: "no notification policies configured means no signals, not all-clear". zone/tunnel added to the estate type filter, the tag-dictionary expected-types list, and the graph icon map (IconWorld for zones, IconBuildingTunnel for tunnels). Brief table row moved to Built recording the actual transport and DNS-evidence-only scope; the "adding a new integration" DoD checklist §1-5 is met (interface+credential spec+health+empty tiered catalogue; redaction covered; contract tests over stubbed client for entities/detect/evidence; no T2+ actions exist to gate; brief row + working system card).

    OpenAPI + schema.d.ts regenerated for the new endpoint (committed on the branch). Gates: summary rollup test on real Postgres, affected frontend suites, npm run build, eslint (0 errors), prettier, ruff + mypy — all green locally.

    OUTSTANDING before the sprint is Done: the live smoke on staging needs the real account — add the Cloudflare integration with a read-only scoped token, trigger a sync, check the card/estate/graph, and exercise the evidence queries; the two GraphQL ones (security_events, zone_analytics) are the least fixture-verifiable. That's the Steve-side smoke per the release process; both live-found Azure bugs came from this step.
- id: 01KYVNVXP312QB43E86KZPDJZC
  author: Steve Vine
  at: 2026-07-31T08:50:16.387198Z
  text: Live smoke on the real Cloudflare account completed by Steve 2026-07-31 — sprint read-only scope fully verified, including the GraphQL evidence queries flagged as least fixture-verified. No live-found defects. Write-path work is being planned next in the same sprint.
assignee: steve
label: null
priority: medium
task_status: done
---
The pane-of-glass slice (DoD: usable in the app, not just JSON) — AWS/Azure surface precedent (ISE-363/ISE-369).

- Cloudflare account card on System detail: status, last sync, entity counts by type, findings — mostly free via the generic card; verify.
- Estate/Explorer/graph display for the new `zone` and `tunnel` entity types (icons, detail rendering, filters).
- Update the integration-connectors brief table row (Cloudflare → Built, actual transport/scope) + run the "adding a new integration" DoD checklist (§1-5).
- Live smoke against the real Cloudflare account (the Azure smoke caught two real bugs — do it before calling the sprint done).