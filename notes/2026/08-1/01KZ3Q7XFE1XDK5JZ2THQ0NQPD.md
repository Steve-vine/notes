---
id: 01KZ3Q7XFE1XDK5JZ2THQ0NQPD
created: 2026-08-03T11:48:13.422473Z
updated: 2026-08-07T10:38:12.00863Z
type: task
title: Migrate all connectors to the generic summary; delete bespoke endpoints and cards
project: 01KX671DATY39VW6GWK3M2T3DN
number: 496
sprint: shk7zaj
comments:
- id: 01KZ9PD5AFHWSBXV1YKHX3G5KS
  author: Steve Vine
  at: 2026-08-05T19:29:03.31157Z
  text: |-
    Built — PR #484 (feature/ise-496-migrate-summaries → main), stacked on ISE-495/#482.

    DELETED
    - 6 `*-summary` endpoints, 4 `_require_<type>` guards, 8 response schemas, 5 React components.
    - Net −1,500 lines, and the OpenAPI snapshot SHRINKS by ~1,100 lines — a rare direction for it to move.

    TWO ADDITIONS TO THE VOCABULARY
    The old cards said things ISE-495's vocabulary couldn't carry, and both turned out to be generic rather than connector-specific:
    - `SummarySection.note` — the caveat a number needs to be read correctly ("tickets ISE raised are excluded from its own detectors, so they can never count toward a burst"). Conditional prose, so the connector fills it or leaves it empty rather than the component carrying fixed copy about a source it knows nothing about.
    - `SystemSummary.updated_at` — a count is only as good as its freshness; "no tickets in 24h" means something very different if the last delivery was a week ago. A datetime, rendered as relative time by the card, because formatting a date is the frontend's job.

    TWO THINGS THE MIGRATION MADE EXPLICIT
    1. Kubernetes gains a card it NEVER HAD. Its two bespoke components were both config editors (cluster link, kind dictionary), so it had a detail page with no at-a-glance panel at all. Two details it forced into the open:
       - its identity is the declared external cluster name, not a key prefix — node keys are deliberately unscoped so they join with DataDog's (ADR 0045), so an empty prefix has to mean "no identity" rather than "split on the first colon", which would have printed `namespace` as an account id;
       - it counts OBSERVATIONS, not alerts. Kubernetes has no alerting layer to forward, so the default would have rendered a permanent, meaningless "0 active alerts".
       Entra makes the same point from the other side: its keys are `entra:` while its type is `entraid` (ADR 0063 §1). That is exactly why the prefix is DECLARED rather than derived from connector_type.
    2. Config editors are not summaries. The AWS card mixed a region editor into its rollup; the editor is split out as `AwsRegionsCard`. The regions still SHOW on the generic card (an alarm count is only as wide as the regions behind it) and that card is where they are read, this is where they change.

    TESTS
    Ported the six existing rollup tests onto the generic endpoint rather than deleting them — they assert real per-connector discovery counts and are worth keeping. Two new:
    - every migrated connector renders a titled, explained, sectioned card FROM AN EMPTY DATABASE — the state a freshly-added integration is actually in, and when an operator is most likely to be looking at the page;
    - Kubernetes counts observations and takes its identity from the cluster link.

    Full backend suite green locally: 2359 passed. Frontend: 623 passed. ruff/mypy strict/eslint/prettier/build clean.

    ADR 0083's consequences updated with the real numbers; `docs/briefs/ui-brief.md` gained the generic-card entry (semantic tones, closed icon set with a safe fallback, editors stay separate).

    For the staging smoke: worth eyeballing all seven integration pages, especially Kubernetes (a card that has never existed before) and Freshservice (the stats + note + "last updated" shapes).
- id: 01KZ9VTZB5RCBBM3S2KHV41M7M
  author: Steve Vine
  at: 2026-08-05T21:03:58.821803Z
  text: |-
    STAGING SMOKE FOUND A COPY DEFECT — fixed and redeployed (commit 1ec19c4 on the branch).

    The Entra card read "45 policys". `policy` is a live entity type and the rollup's naive `+ "s"` had no rule for it — visible to an operator on the first card that has policies in it.

    Fixed with one `-y → -ies` rule and a vowel guard (so `keys` and `days` do not become `kies`), plus a test. Deliberately no further English: the estate vocabulary is a closed, known set, and an irregular-plural table would be more machinery than the problem has.

    Now live on staging: "1782 app-registrations, 1021 identity-groups, 45 policies, 1553 users".

    STAGING VERIFICATION (all seven cards rendered against real estate data)
    - Entra tenant — 1782 app-registrations / 1021 identity-groups / 45 policies / 1553 users, 11 at-risk users, 11 active alerts
    - Microsoft 365 tenant — 6 active alerts, 6 licence observations, real licence meters (POWER_BI_PRO, Microsoft_365_Copilot…)
    - Freshservice desk — burst detectors + arrival stats, identity resolved to `moneypenny.freshservice.com` off a stored ticket URL (no credential reveal)
    - AWS × 2 — regions section (eu-west-2, us-east-1) + "write enabled" badge
    - Kubernetes × 7 — the card that never existed before. Each takes its identity from the cluster link (one cluster has none configured and correctly shows EMPTY rather than a guess), and each counts OPEN OBSERVATIONS, not alerts: 75, 47, 7, 5, 4, 2 and 0 across the fleet. Under the old default those would all have read "0 active alerts" — permanently, and meaninglessly.

    Staging deploy: run 31046494293, success. All pods rolled clean.
assignee: steve
label: null
priority: medium
task_status: done
---
Move aws/azure/cloudflare/entraid/m365/freshservice/kubernetes summaries onto the generic summary capability; delete the per-connector `*-summary` endpoints + `_require_<type>` guards in `api/v1/systems.py`, the matching schemas in `api/v1/schemas.py`, and the connector-type switch + bespoke card components at `SystemDetailPage.tsx:1894`. Config editors (kind dictionary, cluster link, aws-config, freshservice-config) stay — this task is summaries only. Regenerate the OpenAPI snapshot (surface shrinks).