---
id: 01KY6ZD1RDMVF80GP3MPSWNY7E
created: 2026-07-23T07:52:51.725485Z
updated: 2026-07-23T09:08:57.566036Z
type: task
title: ADR 0015 — Attachment storage & reference model
comments:
- id: 01KY6ZDD1FZ4SATP041MP0NW4H
  author: Steve Vine
  at: 2026-07-23T07:53:03.279101Z
  text: |-
    Steve Vine · 2026-06-25:

    Written and Accepted as `decisions/0015-attachment-storage-and-reference-model.md`. PR: https://github.com/Steve-vine/notula/pull/85

    **What it settles** (the shared contract for the rest of M12):
    - **Storage** — per-note id folder `attachments/<note-id>/<original-filename>`, collision-suffixed; no global content dedup (rejected for opaque names + reference-counting cost).
    - **Reference form** — a **vault-relative path** in the body (`attachments/<id>/file.png`), rewritten to the protocol URL by the renderer. No absolute paths → relocation-safe.
    - **Serving** — a **custom Rust protocol handler** resolving against the *current* vault with a path-traversal guard. Static asset-protocol scope rejected because the vault relocates (ADR 0013).
    - **Embed vs link** — `![]()` images render inline; everything else (and any non-image `![]()`) renders as a link opened via `tauri-plugin-opener`.
    - **Sync** — rides ADR 0013 unchanged (binaries committed as-is, git-lfs still deferred); the index references no attachments.
    - **Lifecycle** — on-save reconciliation + delete cascade, no swept GC.
    - **Import/export** — referenced attachments travel with notes; closes the gap ADR 0014 left open.

    **Decisions made on the fly (worth a look in review):**
    1. **Reference is vault-root-relative, not note-relative.** Because notes are hash-sharded, a note-relative link can't resolve anyway, so the canonical form is vault-root-relative and Notula's renderer is the resolver. Honest consequence recorded: a naive external markdown viewer won't resolve it.
    2. **Lifecycle is immediate on-save reconciliation**, not a swept GC — the per-note folder makes "diff folder vs. body references" cheap enough to do inline. Recorded as the policy DEV-652 implements.
    3. **Updated CLAUDE.md's Locked list** with a one-line attachment clause, treating the storage layout/protocol as load-bearing.

    Docs-only change; code-gated CI runs trivially. Moving to In Review for your merge call — DEV-648 and the rest branch off `main` once this lands (sequence-don't-stack).
task_status: done
assignee: steve
label: chore
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 95
---
Record the rules that govern how files are attached to / embedded in notes, before the M12 briefs are built (knowledge before work — same pattern as ADR 0014 led M11). ADR 0014 explicitly deferred attachment/image-link handling to this milestone.

Write `decisions/0015-attachment-storage-and-reference-model.md` in the standard Date / Status / Context / Decision / Consequences format.

## Decisions to record

* **On-disk layout — per-note id folder.** Attachments live at `attachments/<note-id>/<original-filename>` (the `attachments/` dir already exists, created by vault bootstrap but unused). Co-locates a note's binaries, preserves real filenames, and makes per-note deletion / orphan cleanup tractable. Name collisions within a note's folder get a numeric suffix. No global content dedup (rejected: opaque names + reference-counting cost).
* **Reference syntax in the note body.** Standard markdown — `![alt](ref)` for image embeds, `[name](ref)` for non-image file links — using a stable, vault-relative reference (notes are sharded deep, so raw relative paths are unworkable). Define the exact reference form and the rewrite rule the renderer applies.
* **Serving bytes to the WebView — custom Rust protocol handler.** The vault is relocatable (ADR 0012/settings), which rules out a static Tauri asset-protocol scope. A custom protocol resolves a reference against the *current* vault path at request time. Record why, and the scheme name.
* **Embed vs link rendering.** Images render inline; all other types render as a clickable link that opens with the OS default app (`tauri-plugin-opener`). State the image/non-image discrimination rule.
* **Sync.** Attachments are plain binary files inside the vault, so git-sync (ADR 0013) carries them with no new machinery; note the binary-diff consequence and that the index never references them.
* **Orphan / lifecycle policy.** Define what happens when a note is deleted and when a reference is removed from the body — the contract Brief 5 (orphan cleanup) implements.
* **Import/export.** State that referenced attachments travel with notes (the gap ADR 0014 left open) — the contract Brief 4 implements.

## Done when

- [ ] `decisions/0015-...md` is written, Accepted, and covers all decisions above
- [ ] CLAUDE.md "Locked" / decisions references updated if the ADR introduces a load-bearing invariant
- [ ] Merged to `main`

---

Linear DEV-647 · M12 - Attachments · created 2026-06-25 · done 2026-06-25