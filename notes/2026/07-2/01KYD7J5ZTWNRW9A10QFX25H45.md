---
id: 01KYD7J5ZTWNRW9A10QFX25H45
created: 2026-07-25T18:10:55.098143Z
updated: 2026-08-07T10:55:50.412533Z
type: task
title: IAC repo access is designed on the retrieval contract from day one
project: 01KX671DATY39VW6GWK3M2T3DN
number: 299
sprint: siyfhjg
comments:
- id: 01KYF15M0B08828948K3GDDT3X
  author: Steve Vine
  at: 2026-07-26T10:57:40.875802Z
  text: 'Sprint 26 planning (2026-07-26): this constraint is now carried by the sprint''s task set. ISE-304 (ADR 0051 + UI brief) is the acceptance vehicle — the ADR records the ingest → comprehend → index → search application: comprehension at write time (ISE-307: repo/file summaries, allowlist + caps, change-driven via head-SHA poll), claims into the proposals queue (ISE-308), FTS-indexed ranked retrieval tools with bound_payload-capped read_repo_file drill-down (ISE-309). No raw list_files/read_file Evidence surface is built anywhere in the slicing — cost scales with change and question difficulty, not repo size.'
assignee: steve
priority: high
task_status: done
---
**Standing design constraint for this sprint, from Sprint 24's retrieval-layer contract (ADR 0050) — recorded now so the integration work doesn't lose sight of it.** ADR 0050 names IAC repos as a source that must plug in as **ingest → comprehend → index → search**, never as a raw pile the agent trawls: "how does an agent find the relevant thing here without reading all of it?" is a question this integration must answer at design time, not after.

Motivating ask (Sprint 24 discussion, 2026-07-25): "check the deployment repo to understand what the Crossplane deployment is doing" — unanswerable in ISE today at any price. The wrong build is a `read_file`/`list_files` Evidence surface where the model pays tokens to locate things in a repo; cost then grows with repo size, not question difficulty.

What the contract implies here:
- **Comprehend at write time**: on sync/change, compute the cheap-to-read forms — per-repo/per-path summaries (the ADR 0042 §4 document-summary pattern), extracted resource/entity references (what does this Crossplane claim deploy? which estate entities does it touch?) feeding the estate graph as proposed claims (proposals-queue pattern).
- **Find in the database**: indexed search over the comprehended forms (FTS first, per ISE-289's precedent) as ranked, bounded retrieval tools; full file content is the drill-down, `bound_payload`-capped.
- **Change-driven, not clock-driven**: re-comprehend only what a commit actually changed (the Document Register's "change is what costs" rule).

Not a build task in itself — the acceptance is that this sprint's design/ADR for repo access demonstrates the contract, and its tasks are sliced accordingly.