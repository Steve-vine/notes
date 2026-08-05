---
id: 01KYHBND7TJZEQADJZR7C6PSEJ
created: 2026-07-27T08:39:32.858034Z
updated: 2026-08-05T13:25:17.715844Z
type: task
title: Tag rules miss cross-key alias spellings — rule written against the canonical tag matches nothing
project: 01KX671DATY39VW6GWK3M2T3DN
number: 327
sprint: sak4nk6
comments:
- id: 01KYHXR71W6EMSR6ZCCKGB0478
  author: Steve Vine
  at: 2026-07-27T13:55:39.19672Z
  text: |-
    Done — PR #303 (feature/ise-327-cross-key-alias), branched from main.

    Fix exactly as scoped: _satisfying_tag_ids now gathers alias rows BY canonical_id. It fetches the canonical rows by key, then a second query select(Tag).where(Tag.canonical_id.in_(canonical_ids)) picks up every spelling under ANY key — so cross-key aliases (app:openanswer → service:openanswer) are included, not just same-key value spellings. Returns [canonical, *spellings] per predicate; the ISE-211 per-predicate count guard is untouched; display path unchanged.

    Tests (real Postgres): cross-key alias matches a service:openanswer rule; unmapped predicate still empty; canonical + cross-key alias on one entity satisfies one predicate not two. Full tag_rules/tag_dictionary/tag_pool suites (62) green; ruff + mypy clean.

    Verification case (OpenAnswer rule picking up the openanswer-app workloads) should resolve on the next sync with no rule edit. Moving to Review.
assignee: steve
label: null
priority: high
task_status: done
---
Found live 2026-07-27: a TagRule with predicate `service:openanswer` shows 0 members, while the Estate detail page for `openanswer-app` / `openanswer-api-app` shows those workloads carrying `service:openanswer`. The display path and the rule path answer "does this entity carry service:openanswer?" differently — the ADR 0041 invariant (rules written in canonical terms match any spelling) is broken for cross-key aliases.

**Cause:** `_satisfying_tag_ids` (`tag_rules.py:117`) gathers candidate pool rows with `Tag.key.in_([canonical keys])`, then collects alias rows from that result. Same-key spellings (`Service:Kora` → `service:kora`) are in the fetch, so they work — cross-key alias rows are not: `app:openanswer` (key `app`, `canonical_id` → `service:openanswer`; the dictionary's `service` key lists `app` as an alias) is never fetched, `aliases` stays empty, and matching sees only the canonical row, which no entity carries directly (K8s harvests the raw `app` label). Result: 0 matches.

No rule spelling works around it: a predicate written `app:openanswer` resolves through `dictionary.resolve()` back to `service:openanswer` before matching — the identical dead end. Only human-asserted edges bypass it.

**Fix:** gather alias rows by `canonical_id` instead of relying on the key-filtered fetch — e.g. after resolving `canonical_by_pair`, a second query `select(Tag).where(Tag.canonical_id.in_(canonical ids))` (or widen the first fetch to include the keys' alias spellings). `_satisfying_tag_ids` then returns `[canonical, *all spellings]` per predicate, same-key and cross-key alike. Display (`tags_for_entities`) needs no change — it already collapses via `canonical_id`.

**Tests** (real Postgres, per ADR 0016): entity carrying only a cross-key alias spelling (`app:openanswer` mapped to `service:openanswer`) matches a `service:openanswer` rule; same-key value-spelling case still passes; unmapped predicate still returns no matches; `matching_entity_ids` counting stays per-predicate (the ISE-211 over-count guard) when one predicate is satisfied by both a canonical and a cross-key alias on the same entity.

**Verification case:** after the fix, the live `OpenAnswer` rule (`["service:openanswer"]`, group 8255…46ff) should pick up the two `openanswer-app` workload copies (env-staging-uk + env-staging-us) on the next sync, with no rule edit. The `openanswer-api-app` pair carries `service:openanswer-api` — a distinct value, correctly outside this rule; grouping those needs a second rule (`service:openanswer-api`) with both groups attached to the one dashboard Service.