---
id: 01M07ST1SVN8B35J3ZAZ0Z7WPJ
created: 2026-08-17T12:05:44.379797Z
updated: 2026-08-25T09:01:12.10537Z
type: task
title: Attachments location
project: 01KY6W9951TW0904DT0GGJVGE7
number: 398
sprint: segj1dz
comments:
- id: 01M0TKTRNHGMZTP9CX2RVAMN0D
  author: Steve Vine
  at: 2026-08-24T19:26:50.545435Z
  text: |-
    Done — PR #391 (branch brief-398-attachment-month-buckets), ADR 0053.

    Decisions made on the fly:

    - No -k spill suffix. ADR 0041 caps note buckets at 500 because a bucket holds one entry per note; here a bucket holds one entry per attachment-BEARING note, which is far fewer. A guardrail with nothing to guard is complexity for its own sake — so the month path is a pure function of the id with no probing at all, which is actually simpler than the note tree it mirrors.

    - Sweep order is folders-then-bodies, deliberately. A crash in between leaves references pointing at a file that has already moved, which the resolve fallback still serves; the reverse order would leave references pointing at a file that hasn't moved yet.

    - Folder collisions during the sweep suffix rather than drop (kept.png → kept-1.png), reusing the policy store already applies, so no bytes are lost and the sweep still converges. The suffixed file is unreferenced, so the note's next save prunes it.

    - Duplicate-note now resolves each source reference instead of joining attach_dir by hand, so it copies correctly whichever layout the source is in.

    Problem found and recorded rather than fixed: sealed bodies (ADR 0028) are opaque, so the sweep cannot repoint their references. Their folders still move and the resolve legacy fallback keeps them working — permanently, not just during rollout. Repointing them would mean unsealing bodies during a startup sweep, which isn't a trade worth making. Written up in the ADR's Consequences.

    Landing note: the first open after merge rewrites every note that references an attachment, so expect one visible auto-commit of moves + body edits. And per the 0041 precedent, the MCP sidecar wants rebuilding straight after this merges — a stale build would recreate flat folders (adopted at the next open, nothing breaks meanwhile).

    Verified: cargo fmt --check, clippy -D warnings, cargo test --workspace (445), npm run check, npm test (247).
- id: 01M0TWV0JC564P0KA706MP8SJK
  author: Steve Vine
  at: 2026-08-24T22:04:15.819538Z
  text: |-
    Merged — PR #391 squashed onto main as 1a36ebb. Done.

    Post-merge: main verified as a whole (CI tested each PR against its own base, not the combination) — cargo fmt/clippy clean, cargo test --workspace 445 passed, npm check/test/build green.

    The MCP sidecar has been rebuilt (target/debug/notuvia-mcp, 23:03) as ADR 0053 requires — but the currently running notuvia-mcp process is still the old binary and holds the old inode. It needs restarting before it touches the vault again, or it will write flat attachment folders. The next app open adopts any it has already written, and the resolve fallback means nothing breaks meanwhile.

    First app start after this will sweep the vault: attachment folders move into month buckets and every note referencing one is rewritten, landing as one auto-commit of moves plus body edits.
assignee: steve
label: null
priority: medium
task_status: done
---
At the moment attachments are stored in a separate folder, this could become large over time. This either needs the same treatment as notes folders (year/month) or store them in the same folder as their notes.
Need to discuss this before completing the work.

## Discussed and agreed

Month buckets mirroring ADR 0041: `attachments/<yyyy>/<mm>/<note-id>/<file>`,
the month derived purely from the note's ULID timestamp. Co-locating beside the
note (`notes/<yyyy>/<mm>-<k>/<id>/`) was rejected — it would make the 0041 sweep
and the 500-file bucket cap reason about non-`.md` siblings, and would widen the
protocol handler's traversal guard from `attachments/` to the whole notes tree.

References in note bodies are rewritten to the full bucketed path so the text in
the note stays the path on disk (ADR 0015's greppability promise), rather than
becoming a logical reference resolved only by the app.

## Agreed work

- New layout + `reference_for()` as the single place the reference shape lives.
- Reference parsing keyed on position (note id = segment before the filename),
  so both layouts parse through one rule.
- Migration sweep at vault open, right after the 0041 note sweep: move folders,
  then repoint bodies.
- Legacy read fallback in `resolve`, under both traversal guards.
- ADR 0053 recording it; `brief/storage-architecture.md` updated.