---
id: 01M20QDT4W02HPCRJV1P9K6CAN
created: 2026-09-08T14:40:48.796504Z
updated: 2026-09-08T15:42:39.299059Z
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
- id: 01M20TYYGCT77TCS6ZCH63JF63
  author: Steve Vine
  at: 2026-09-08T15:42:36.031377Z
  text: |-
    Reviewed and merged as e70bf38 (squash, #414). CI green on the head commit; branch deleted.

    Independently reproduced the mechanism on git 2.54 (macOS) before merging, and it matches the report exactly:

    - `push -u` with a SINGLE merge entry, run 5x: stays at 1. The ratchet needs a seed duplicate — consistent with "the 1 → 2 transition was never reproduced".
    - Seed one duplicate (2 entries), then 3x `push -u`: warns `branch.main.merge has multiple values` each time and the list goes 2 → 5. One appended per push, unbounded.
    - Fetch cost tracks the entry count: 16 `ref-prefix` packets at 5 entries vs 8 at 1, and `config --replace-all` drops it straight back.
    - Plain `push origin HEAD` (no `-u`) does not touch the key at all — so the fix's "`-u` on first push only" is sufficient, not just mitigating.
    - `branch.<b>.remote` does NOT duplicate alongside merge (stayed at 1 through the same runs), which is why only the merge key blew up on the box.

    Also checked in the code, not just the report:

    - `git::push` was genuinely the only production `-u` call site. The five in `gitsync.rs` are all above line 1828, inside `mod tests` (starts 1228).
    - Nothing that depends on tracking config breaks: `ahead_count`/`behind_count`/`reset_soft_upstream`/`merge_upstream` all use `@{u}`, and tracking is still established on the first push. (`@{u}` also resolves fine against a multivar merge — it takes the last — which is why the box degraded rather than errored.)
    - The self-heal makes the failure mode bounded even though the trigger is still unknown: if it recurs, the next fetch/push collapses 2 → 1, so it oscillates instead of growing. That is the part that actually closes this out.
    - The mixed case ([main, main, other]) is safe too: collapse declines (values differ) and `-u` isn't passed (upstream exists), so nothing grows.

    Ran the four new tests locally with the real toolchain (this Mac does have cargo, unlike the machine the PR was written on): all pass, and the whole `git::` set is 19/19 green, 5 runs in a row. One unrelated flake seen once on the first run — `multiplexing_shares_one_connection_per_remote_and_self_reaps` failed its `default_ssh_command()` assertion under parallel execution, then passed 5/5 after. Not caused by this change (it touches nothing in that path) but `ssh_control_dir()` looks racy against the other socket tests; worth a follow-up if it shows up in CI.

    One deliberate behaviour change worth recording: `has_upstream` doesn't check that the tracked remote is `origin`, so a branch configured to track some other remote no longer gets rewritten to origin on every push. Low risk under ADR 0013 (Notuvia owns the vault repo and only ever configures origin), and not clobbering user config is the better default anyway.

    Still outstanding on the Linux box — the merge alone changes nothing there: redeploy `~/notuvia-mcp` off 0.21.0, and kill the orphaned syncers. Once redeployed the 12 MB config collapses itself on the first fetch, so the hand-run `config --replace-all` is now optional rather than required.
assignee: steve
label:
- brief
- bug
priority: urgent
task_status: done
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
