---
id: 01KYWAFJNADNVFB93877168CDN
created: 2026-07-31T14:50:31.978506Z
updated: 2026-08-05T19:02:04.081809Z
type: task
title: 'Docs: Concepts — the estate'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 428
order: 0.125
sprint: sp3en5k
comments:
- id: 01KYWBB3ZKWTQXHSFHHE4Y3H7P
  author: Steve Vine
  at: 2026-07-31T15:05:34.451795Z
  text: |-
    Done on feature/ise-428-docs-estate — PR #23, left OPEN for review.

    Full estate model: the three registers (structural / contextual / tuning) framed by who owns the truth and how it's maintained, with real annotation examples; entity id as join key with the datadog:service:checkout ↔ k8s:… alias example and why it makes investigation directed (resolve → walk edges → bounded evidence plan, not open-ended exploration); entity vs system distinction with the alias as the seam; three-tier identity resolution (free harvest → AI candidate human-confirms → human-asserted sticky) with "never merges on a guess — a wrong merge corrupts every downstream investigation" and authored-wins-conflict-surfaced; relationships/blast radius; lifecycle in operator terms (last_seen_at → retired but fully intact and hidden by default → pruned as housekeeping only), per-type windows with the Karpenter-node-vs-namespace reasoning, un-retiring on return, and "nothing still in use is ever deleted — signals/tags/audit hang off entity ids"; documents + repo registers with the age-presented-never-hidden and disappeared-is-flagged postures. Cross-links to Tags rather than duplicating. Facts from ADRs 0028/0039/0042. Build/lint green.
assignee: steve
label: null
priority: medium
task_status: done
---
Replace the stub at `src/content/docs/concepts/estate.md` with real content: entities and their types; cross-source identity resolution (aliases — harvested, AI-proposed, human-asserted and sticky); typed relationship edges and blast-radius/impact; operator context annotations; the entity lifecycle (last-seen, retire/archive, never delete); knowledge sources and the document register at a high level. Cross-link to the Tags page rather than duplicating the tag model.

Ground in ADRs 0028, 0039, 0041, 0042, 0054. Operator audience, released capability only.