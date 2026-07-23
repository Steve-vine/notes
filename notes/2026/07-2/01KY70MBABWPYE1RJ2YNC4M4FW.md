---
id: 01KY70MBABWPYE1RJ2YNC4M4FW
created: 2026-07-23T08:14:19.467234Z
updated: 2026-07-23T11:00:28.454052Z
type: task
title: Search behaviour
task_status: done
assignee: steve
imported_from: null
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 158
comments:
- id: 01KY70MJGNKZWJRR2G5VTZY9JR
  author: Steve Vine
  at: 2026-07-23T08:14:26.837081Z
  text: |-
    Steve Vine · 2026-07-03:

    **Done building** — PR: https://github.com/Steve-vine/notuvia/pull/140

    **What was done:** Each fuzzy query word now needs a contiguous core — at least half its characters matching in a row — implemented as `gated_indices()` in `index.rs`, a per-atom wrapper over nucleo's `Pattern::indices`. "disruptor" keeps notes containing "disrupt…" and drops scattered-letter noise like the "dis" hits in the screenshot; typo tolerance ("jzz" → "Jazz") survives.

    **Decisions on the fly:** I first tried a minimum score-ratio threshold (hit score vs the pattern's self-match score) but measured that nucleo's word-boundary bonuses make scattered word-initial matches score 0.84–0.89 of ideal — barely distinguishable from real near-word hits (0.86) and above legit typo hits (0.78). Contiguity of the matched run is the signal that actually separates them, so the gate is `longest contiguous run ≥ ceil(word_len / 2)`. Negative atoms and explicit substring/prefix/postfix syntax keep nucleo's semantics.

    **Problems:** None. `cargo test` (150, incl. new `search_rejects_scattered_matches`), clippy and fmt all green.
sprint: sg5stzf
---
Reduce the amount of results returned in search, i.e. the amount of 'fuzziness'. E.g. The below search was for "disruptor"

Returning "disrupt" makes sense but "dis" is too 'fuzzy'

## Agreed work

* Keep nucleo's typo-tolerant fuzzy matching, but require each query word's match to contain a **contiguous core** — at least half the word's characters matching in a row. "disrupt…" still matches "disruptor"; letters merely scattered through a note (the "dis" case) no longer do; dropped-letter typos ("jzz" → "Jazz") keep working.
* Implemented in `src-tauri/src/index.rs` as a per-atom gate over nucleo's `Pattern::indices`; negative and substring/prefix/postfix atoms keep nucleo's own semantics.
* Regression test covering both the kept near-word match and the dropped scattered match.
* Checks: `cargo test`, `cargo clippy -D warnings`, `cargo fmt --check`.

---

Linear DEV-796 · Left Panel Improvements · created 2026-07-03 · done 2026-07-04