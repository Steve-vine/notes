---
id: 01M73QFKECH6GDTGKJNGM8MAHW
created: 2026-11-10T21:57:59.884593Z
updated: 2026-11-10T21:58:32.541743Z
type: task
title: Retire the coded GitHub App, Aikido and Nessus readers once their configured replacements match — history carried across so nothing reopens, duplicates or loses its source (on Steve's go)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1716
sprint: sj4f1kj
assignee: steve
label:
- tech_debt
priority: medium
task_status: todo
---
The end state ADR 0146 aims for (COM-1705): only integrations that do more than read, or need something the configuration deliberately can't do, stay coded. **Only on Steve's go**, after he has seen the comparisons on COM-1713, COM-1714 and COM-1715. Each reader can be retired on its own.

**Chain:** on the chain — migration + API

## What the person sees

- For each retired reader, the **coded tile goes**:
  - the GitHub App tile's Secrets features;
  - the Aikido tile;
  - the Nessus tile's API read. Uploading .nessus files stays where it is, under Vulnerabilities.
- Its Collection integration takes its place in the gallery. Old links land on the Collection integration.
- **Nothing in the registers changes:**
  - vulnerabilities keep their VUL numbers, sightings, dates, owners and history, with the sighting's source now the Collection integration;
  - Secrets' keys at their source and stored copies keep their links, rotation history and proof;
  - Unmatched targets, matching rules limited to the old source, and part assignments move to the new source.
- Nothing reopens or closes because of the switch, and nothing appears twice.

## Done when

- Per reader, a migration moves sightings, targets, rules, parts, source keys and store entries to the Collection source, and is tested against a populated database (memory: migrations' fresh-DB blind spot; run a populated-DB check before merging).
- After the switch on staging, one run of each feed changes nothing it shouldn't: no new VULs, no closures, no new Discovered rows for things already there.
- The coded modules, their Beat entries, task labels, settings tables (after the migration copies what's needed) and tests are removed. COM-1696's test keeps passing.
- ADR 0128's tile table and ADR 0141 §13 get amendments saying where these moved.

## Notes

- Coded modules: `core/github.py`, `core/secrets/github_source.py`, `github_store.py`, `core/aikido.py`, `core/vulnerabilities/aikido_read.py`, `core/nessus.py` (the API read; keep the .nessus import), `tasks/vulnerability_sources.py`, `tasks/scanner_health.py`, `core/integrations/tiles/*`, and the frontend tiles.
- Production has its own data. Run the same populated-DB check against a copy of production's shape before the release.