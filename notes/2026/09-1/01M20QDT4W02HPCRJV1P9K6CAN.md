---
id: 01M20QDT4W02HPCRJV1P9K6CAN
created: 2026-09-08T14:40:48.796504Z
updated: 2026-09-08T14:40:48.796504Z
type: task
title: git-sync's `push -u` ratchets branch.<b>.merge until every fetch saturates the uplink
priority: urgent
tech:
- rust
- git-sync
assignee: steve
label:
- brief
- bug
task_status: active
project: 01KY6W9951TW0904DT0GGJVGE7
number: 416
---
`git::push` runs `git push -u origin HEAD` every sync cycle
(`notuvia-core/src/git.rs:471`). Once `branch.<branch>.merge` holds two values,
`-u` **appends** a third rather than replacing — git warns
`branch.main.merge has multiple values` and grows the list on every push. It
never converges.

Found on the headless Linux box: `~/notes/.git/config` had reached 12 MB with
`merge = refs/heads/main` repeated ~495,300 times, still growing ~6 lines per
30s. Git sends one `ls-refs` ref-prefix per entry, so a single fetch of an
already-in-sync repo took 74s and uploaded ~15 MB. Sustained TX was 18-20
Mbit/s — the full upstream of a 70 Mb VDSL line — which starved the ACKs for
every download on the LAN. 819 GB uploaded in 8 days.

Reproduced locally (git 2.55): seeding one duplicate then running 5 pushes took
the list 2 → 7; a fetch at 7 entries emitted 14 `ref-prefix` packets vs 2 after
`config --replace-all`. Linear amplification, confirmed both directions.

**Not reproduced:** the 1 → 2 transition. 240 concurrent `push -u` invocations
(40 rounds × 6 parallel) never produced a second entry — git's config write is
lock-and-rename, so racing pushers converge. The original trigger is still
unknown; the box may be on an older git. That's the argument for repairing the
config rather than only declining to make it worse.

Nothing else in the codebase writes branch config — the other `-u` call sites
in `gitsync.rs` are all test fixtures.

## Agreed work

- [ ] `push` passes `-u` only when the branch has no upstream configured
- [ ] Before pushing, collapse a duplicated `branch.<b>.merge` to a single value
      (`config --replace-all`), so vaults already damaged self-heal
- [ ] Regression tests: many pushes leave exactly one merge entry; a pre-seeded
      duplicate list is collapsed on the next push

Amplifier noted but **out of scope** (follow-up if wanted): ten `notuvia-mcp`
instances with `--git-sync` were alive against the one vault, seven fetching
concurrently. Nothing stops N instances syncing the same vault.
