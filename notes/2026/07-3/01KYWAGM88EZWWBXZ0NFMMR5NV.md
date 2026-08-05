---
id: 01KYWAGM88EZWWBXZ0NFMMR5NV
created: 2026-07-31T14:51:06.37652Z
updated: 2026-08-05T12:02:52.867674Z
type: task
title: 'Docs: new section — Assist'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 434
order: 0.001953125
sprint: sp3en5k
blocked_by:
- 01KYWAGFZMYHV2Y0WHXM8W7N8G
comments:
- id: 01KYWBS463YJK2F0W4JRXSP6HE
  author: Steve Vine
  at: 2026-07-31T15:13:13.411109Z
  text: |-
    Done on feature/ise-434-docs-assist — PR #29 (stacked, base = feature/ise-433-docs-dashboards), left OPEN for review.

    Retitled "Assist & chat" because the honest story is three surfaces with three boundaries, so the page opens with a comparison table. Assist: estate-wide Q&A with real example questions, answers cite ISE records with links, streamed output + flow-redaction (accumulated and scrubbed whole), structurally read-only via read-only DB transaction stated as "a mechanism, not a convention or a prompt instruction" with the widest-injection-surface rationale, links into the proposal flow rather than acting, and the "read-only is not the same as harmless — it cannot make ISE act" caveat. Incident chat: the page IS a conversation (merged timeline + pre-baked action row), button-or-prompt reaching the same governed entry point ("a second doorway, not a bypass"), the ADR 0049 boundary correctly stated — reads anything incl. live evidence, writes ISE records through governed channels, but no action catalogue in the toolset so a change still crosses tier/policy/human/executor; pulled evidence untrusted. Claude/MCP: pinned session, write-back to timeline, ISE still sole write gate, per-user tokens. Plus search/command palette. 22 pages build. Facts from ADRs 0022/0023/0049/0055.
assignee: steve
label: null
priority: medium
task_status: done
---
Write `src/content/docs/using-ise/assist.md`: the assist chat surface — what it is for, the kinds of question it answers well, streamed responses, and its deliberate boundaries (read-only tools; it observes and explains, it never mutates infrastructure — changes always go through a proposal). Cover the in-app issue chat as quick Q&amp;A versus the deeper Claude/MCP investigation surface for engineers, and global search / the command palette as the neighbouring way to find things.

Ground in ADRs 0022 (SSE streaming), 0023 (read-only tools), 0049 (chat investigation boundary), 0055 (Claude investigation surface). Operator audience, released capability only.

Depends on ISE-433 (sidebar group).