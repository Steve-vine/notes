---
id: 01M20QDT4W02HPCRJV1P9K6CAN
created: 2026-09-08T14:40:48.796504Z
updated: 2026-09-08T14:52:29.552986Z
type: task
title: git-sync's `push -u` ratchets branch.<b>.merge until every fetch saturates the uplink
project: 01KY6W9951TW0904DT0GGJVGE7
number: 416
comments:
- id: 01M20R2QG52ZE68XXXG3HSE1AV
  author: Steve Vine
  at: 2026-09-08T14:52:14.211936Z
  text: |-
    Built on `brief-416-push-upstream-ratchet`, PR #414. CI green (lint, test, typecheck).

    What landed in `notuvia-core/src/git.rs`:

    - `push` passes `-u` only when the branch has no upstream configured — stops the ratchet.
    - New `collapse_duplicate_upstream`, called from `push` *and* `fetch`, collapses a `branch.<b>.merge` that has become one value repeated back to a single entry. From `fetch` it runs before the fetch, since fetch is what pays for a bloated list — a damaged vault gets a cheap fetch on this cycle, not the next.
    - Distinct merge values are left alone and not appended to: a branch tracking several upstreams is the user's config.
    - Four regression tests: first push sets upstream and five more don't grow it; a pre-seeded duplicate list collapses on push; and on fetch; distinct values survive untouched.

    Decisions made on the fly:

    - **Self-heal as well as the `-u` change.** Chose repair over just declining to append because the 1 → 2 transition never reproduced — 240 concurrent `push -u` runs (40 rounds x 6 parallel, git 2.55) left exactly one entry every time, git's config write being lock-and-rename. The original trigger is still unidentified, so "don't make it worse" isn't sufficient on its own.
    - **Only collapse identical values.** Git supports a branch tracking several upstreams; rewriting that would be destroying user config to fix our bug.
    - **Repair in `fetch` too, not just `push`.** Costs one extra `git config --get-all` per cycle, buys the first fetch after an app start being cheap rather than the second.

    Problems hit: no Rust toolchain on this Mac (no cargo/rustup), so nothing was compiled locally — CI was the first gate. It caught four rustfmt violations (`fn_call_width`) and nothing else; fixed in 0d9b4e3. The git-level logic was verified by hand against real repos before pushing.

    Not addressed, deliberately out of scope: ten `notuvia-mcp --git-sync` instances were alive against the one vault with seven fetching concurrently. Nothing stops N instances syncing a vault. Worth a follow-up.

    Still needs doing on the Linux box, and not helped by this PR until redeployed: collapse the existing 12 MB config by hand, kill the orphaned syncers, and redeploy `~/notuvia-mcp` (on 0.21.0).
assignee: steve
label:
- brief
- bug
priority: urgent
task_status: review
tech:
- rust
- git-sync
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

- [x] `push` passes `-u` only when the branch has no upstream configured
- [x] Before pushing, collapse a duplicated `branch.<b>.merge` to a single value
      (`config --replace-all`), so vaults already damaged self-heal — done in
      `fetch` as well, since fetch is what pays for the bloated list
- [x] Regression tests: many pushes leave exactly one merge entry; a pre-seeded
      duplicate list is collapsed on the next push (and on the next fetch);
      genuinely distinct values are left alone

Delivered on `brief-416-push-upstream-ratchet`, PR #414, CI green.

Amplifier noted but **out of scope** (follow-up if wanted): ten `notuvia-mcp`
instances with `--git-sync` were alive against the one vault, seven fetching
concurrently. Nothing stops N instances syncing the same vault.
