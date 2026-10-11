---
id: 01M4NAQY0Q6PMR3N1F47KXXZCN
created: 2026-10-11T11:14:35.671975Z
updated: 2026-10-11T11:14:35.671975Z
type: task
title: 'Roadmap entries: core model, Roadmap Entries taxonomy and ADR 0072'
task_status: backlog
assignee: steve
priority: high
label: feature
project: 01KY6W9951TW0904DT0GGJVGE7
number: 528
tech: null
---
So that a Project or Initiative can carry a Roadmap: an ordered list of dated entries (milestones, releases, phases…) that sits above Sprints and is built the same way — frontmatter on the owning note, stable short ids, edited in place, written through one shared operation. This task is the Tauri-free core (`notuvia-core`) plus the decision record; commands, MCP, Settings and UI follow in later tasks.

## Agreed model

```yaml
roadmap:
  - id: r3f9k2            # "r" + 6 chars, same idiom as sprint ids
    title: "1.0 release"
    description: "…"       # optional
    done: false            # the tickbox; replaces the sprint % complete
    kind: release          # a value id from the roadmap_entry taxonomy
    start: 2026-11-01      # single-mode entries use start only
    end: 2026-11-14        # range-mode entries use start + end
    sprints:               # associated sprints, always (project, sprint) pairs
      - { project: 01KY6W…, sprint: s9peyxr }
```

- `kind` comes from a new built-in taxonomy `roadmap_entry` ("Roadmap Entries"): `multi: false`, `allow_user_values: false`, scope applies to **no note type** (it is never a note's value — it classifies roadmap entries), seeded with Milestone (single), Release (single), Phase (range). Values are editable in Settings like the other built-ins; the frame is code-authoritative (ADR 0023).
- `TaxonomyValue` gains `date_mode: Option<DateMode>` (`single` | `range`, lowercase serde, `default` + `skip_serializing_if`), the first enum-valued per-value field. Absent = single. `initials` (DEV-814) is the precedent for a per-value field used by one taxonomy only.
- Dates are always stored as `start` / `end`; the value's `date_mode` decides which the UI shows and the chart draws, so changing an entry's kind keeps its date.
- Sprint links are always pairs so one struct serves both note types: on a project the pair's `project` must be the note itself; on an initiative it must be one of the initiative's member projects. Either way the sprint id must exist on that project.

## Agreed work

- [ ] ADR 0072 — Roadmap entries on projects and initiatives. Context: this task, ADR 0024 (sprints) as the precedent. Decisions: the model above; initiatives gain a roadmap but still no sprints (amends ADR 0070's "no identifier, numbering, sprints or milestones"); record that sprints carry `start`/`duration_days` since DEV-969 (ADR 0040 said "sprints stay dateless" — close that gap); the `roadmap_entry` built-in with a per-value `date_mode` and an empty note-type scope; one `set_roadmap` write path shared by app, MCP and API (the ADR 0070 `set_initiative` precedent, not a wider `update_note`).
- [ ] `runtime.rs`: `RoadmapEntry` + `RoadmapSprintRef` structs next to `Sprint` (~L327), `NoteView.roadmap: Vec<RoadmapEntry>`, lenient `parse_roadmap` beside `parse_sprints` (~L5203) that skips malformed entries, loaded in the note-load path (~L2337), and a `note_roadmap(id)` read. Shed `roadmap` when a note's type changes away from Project/Initiative (as `set_initiative` sheds the link).
- [ ] `note.rs`: `roadmap` in `CANONICAL_KEY_ORDER` (before `sprints`) and `is_managed_key`.
- [ ] `taxonomy.rs`: `DateMode` enum + `date_mode` on `TaxonomyValue`; `roadmap_entry` seed in `seed_taxonomies()`, in `BUILTIN_IDS`; **not** in `requires_done()`. Check `validate_user_def` and `Scope` accept an empty `Types(vec![])` and that `applicable_taxonomies` returns it for no note type. Fix every `TaxonomyValue` struct literal (taxonomy.rs ~L200, ops.rs ~L781, runtime.rs tests).
- [ ] `ops.rs`: `RoadmapEntryInput` (every field optional, omit-keeps / empty-clears, DEV-989 style) and `set_roadmap(note, entries)` modelled on `set_project_sprints` (~L369): Project or Initiative only; ids unique; an omitted id is minted (`mint_roadmap_id`, "r" + 6 beside `mint_sprint_id`); an id not yet on the note is accepted as new if it matches the id shape (the app mints client-side so rows keep their key while typing); `kind` must be a `roadmap_entry` value id; dates ISO `YYYY-MM-DD` with `end >= start`; sprint refs validated per the rule above. Returns the saved list.
- [ ] `ops::set_project_sprints`: when a sprint is deleted, drop any roadmap sprint ref to it on that project **and** on the project's initiative. Deleting a project orphans its refs on the initiative's roadmap — skip dangling refs on read and test it.
- [ ] `ops.rs`: `date_mode` on `NewTaxonomyValue` / `TaxonomyValuePatch` so MCP/API can set it in the next task.
- [ ] `brief/data-model.md`: `roadmap` in the Project and Initiative rows; a short "Sprints and roadmap" subsection beside "Start and due dates" describing both list shapes (the sprint YAML shape is not documented today either).
- [ ] Tests mirroring the sprint ones: frontmatter round-trip, lenient parse, `set_roadmap` validation (type, kind, dates, sprint refs on project vs initiative), sprint-deletion cleanup, `date_mode` round-trip (`value_initials_round_trip` is the template), the built-in seeded and reseeded, taxonomy counts in existing tests bumped.

## Notes

No index change: `roadmap` items are objects so the generic indexer skips them (as it does `sprints`), and taxonomy definitions live in `taxonomies.yaml`, not SQLite — no `SCHEMA_VERSION` bump. Version skew: an older binary (a stale MCP sidecar) will load and then drop `date_mode` and `roadmap` on save, same as any new field; restart the sidecar after merging. `fmt` and `clippy -D warnings` must be clean before merge.