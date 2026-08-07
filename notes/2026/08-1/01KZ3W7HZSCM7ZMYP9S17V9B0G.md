---
id: 01KZ3W7HZSCM7ZMYP9S17V9B0G
created: 2026-08-03T13:15:24.53733Z
updated: 2026-08-07T12:15:32.513476Z
type: task
title: 'Estate: surface kind-dictionary gaps — cluster serves a CRD that ISE isn''t watching'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 513
order: 4.0
sprint: skxht3g
comments:
- id: 01KZ3ZN3VNJBACXCZCP0R7GS65
  author: Steve Vine
  at: 2026-08-03T14:15:14.549765Z
  text: |-
    Done in PR #438 (feature/ise-513-kind-dictionary-gaps).

    Built as suggested: during a live check, ISE asks the cluster what CRDs it actually serves (list_custom_resource_definition) and compares that against this System's dictionary. New endpoint GET /systems/{id}/kind-dictionary/gaps, surfaced as an Alert on the Kind dictionary card of the System detail page.

    The design decision worth flagging: a gap is raised ONLY where ISE can point at something concrete — a preset it ships for exactly that kind, or another Kubernetes integration that already maps it. "Unmapped" alone would be noise, because a cluster serves dozens of CRDs it has no business mapping (cert-manager Orders, Karpenter NodeClaims). The evidence is what makes it actionable, and "env-staging-uk already maps it" is precisely the sentence that was missing for the prod Rollouts.

    Details:
    - Each gap suggests a version the cluster actually SERVES, not the preset's — the shipped ExternalSecret preset names v1, and a cluster on v1beta1 gets v1beta1 (the ISE-269 lesson).
    - Counts the invisible objects where it can ("34 objects are invisible"); where it can't list them, it reports the gap without inventing a figure.
    - Degrades to silence rather than error: no apiextensions RBAC → no gaps. It's a hint, not a check that can fail.
    - Clicking a gap pre-fills the add form exactly as a preset does — deliberately not a one-click save, since the existing add flow probes the cluster before storing anything. Admin-only, matching the per-entry status check (it reveals the read credential).

    On your prod clusters this will show "This cluster serves 2 kinds ISE is not watching" with Rollout (known_elsewhere: env-staging-uk, ~34 objects) and ExternalSecret — i.e. it would have caught ISE-512 on its own.

    Tests: 5 backend API tests + 5 frontend tests. Full frontend suite green (539), backend kind-dictionary + connector suites green (60), ruff/format/mypy strict clean, API types regenerated.
- id: 01KZ429JK66K0MN9TA87RTFBY5
  author: Steve Vine
  at: 2026-08-03T15:01:22.149963Z
  text: |-
    RELEASED to main 2026-08-03 (PR #438 merged, main 34366df, no migration). Staging smoke passed and staging reset to main.

    This is now the fastest route to closing ISE-512: open either production System's detail page and the Kind dictionary card should show "This cluster serves 2 kinds ISE is not watching", naming Rollout with "env-staging-uk already maps it" plus the count of invisible objects. Clicking it fills the add form; the Add flow then probes the cluster before saving.
assignee: steve
label: null
priority: medium
task_status: done
---
Improvement from Sprint 46 Estate testing. The prod-Rollouts gap (ISE-512) went unnoticed because kind dictionaries are configured per cluster and nothing warns when a cluster serves a CRD that ISE maps on other clusters (or that matches a shipped preset). Suggestion: during sync, check served CRDs against the presets + other Systems' dictionaries, and surface a hint on the System detail page (or Unknown assets) — e.g. "this cluster serves argoproj.io/Rollout but has no dictionary entry; 34 objects invisible".