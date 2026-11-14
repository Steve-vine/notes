---
id: 01M73QFKECH6GDTGKJNGM8MAHW
created: 2026-11-10T21:57:59.884593Z
updated: 2026-11-14T17:05:12.927595Z
type: task
title: Retire the coded GitHub App, Aikido and Nessus readers once their configured replacements match — history carried across so nothing reopens, duplicates or loses its source (on Steve's go)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1716
blocked_by:
- 01M73QEMA6B63G9XQCMKFA3S1R
- 01M73QEXQJ7PQ42KXMQAXYGC3X
- 01M73QF7RZH67VATW4T71Y1MTH
- 01M757J9PWWB01312TT2AD6XK6
- 01M7551VHS9DCQFY33HGRR03G7
- 01M755WSQHPBTHYCAAM4ZTW4ST
comments:
- id: 01M746NC1NEDSDG79JNQXBFMFM
  author: Steve Vine
  at: 2026-11-11T02:23:17.557396Z
  text: 'Left in ToDo on purpose. This task is "only on Steve''s go", after the staging comparisons on COM-1713, COM-1714 and COM-1715. Everything it depends on is built and going to staging: follow-on reads, App sign-in, parts, limits, choosing runs, scope and internal addresses. Once Steve has seen the comparisons and says go, each reader can be retired on its own.'
- id: 01M75EK7N6A468YNW69GGDGC17
  author: Steve Vine
  at: 2026-11-11T14:01:10.566079Z
  text: |-
    Still in ToDo on purpose (2026-11-11). This task is "only on Steve's go, after he has seen the comparisons on COM-1713, COM-1714 and COM-1715", and those comparisons haven't happened yet:
    - **GitHub:** there's no coded GitHub connection on staging to compare with.
    - **Nessus:** the Findings feed (now with CVEs and parts) waits for approval, then needs two runs.
    - **Aikido:** 213 parts need companies, and the coded reader's own key is being refused.

    Retiring a reader removes its tile and moves its history, so I haven't started it on the strength of "work through the sprint's tasks". When Steve has seen a comparison and says go, each reader can be retired on its own.
- id: 01M75YJE489MWPX5WHYQ314828
  author: Steve Vine
  at: 2026-11-11T18:40:21.640225Z
  text: |-
    Built on Steve's go (2026-11-11). PR #1731, with two migrations: carry history, then drop the old tables. It merges after the other chain tasks, with its migrations renumbered at merge.

    What you see:
    - **Tiles:** Nessus, Aikido and GitHub are gone from Admin ▸ Integrations; the empty "Security tools" category goes with them. Their old addresses open the Collection integration of the same name, or the gallery searched for it.
    - **Uploads:** .nessus file upload stays under Vulnerabilities.
    - **Keys:** Compass's own Nessus and Aikido keys retire in the Secrets register, with their history kept.
    - **Registers:** no vulnerability changes number, state, owner, dates or key. Nothing is deleted.

    History moves only where the database proves where it belongs. Nothing is guessed, and no feed definitions are created in code (ADR 0147 §9):
    - **Aikido:**
      - parts move to the matching feed (all 218 match on staging);
      - repository and image targets and their rules move, with findings re-keyed to the feed's spelling;
      - clouds and anything uncertain stay as "Aikido (no longer read)".
    - **Nessus:** pulled history stays under "Nessus", alongside uploads. The old reader named hosts differently (reverse DNS), and one old host matches up to five feed hosts on staging.
    - **GitHub:**
      - deploy keys and tokens the feed already reads become the feed's, keeping secrets and history;
      - Actions secrets stay, marked no longer read, because GitHub gives them no ID to pair on.
      - Staging has no coded GitHub rows, so none of this runs there.

    **Production:** it has no Collection integrations yet. There, the migration only retires Compass's own Nessus and Aikido keys and drops the old settings tables and part assignments; no register rows move. From this release, production stops reading Nessus, Aikido and GitHub until those Collection integrations are set up on screen.

    Removed: the coded modules, Beat entries, task labels, API routes, settings tables, frontend tiles and their tests. ADR 0128, 0141 §13 and 0148 have dated amendments.

    Checks:
    - backend: ruff, mypy, unit suite (2,169) and integration tests (193 across 61 files) pass;
    - the new populated-database migration test passes 3 of 3. It covers: with replacing feeds, nothing lost, duplicated, reopened or closed, and a real feed run afterwards changes nothing; and with no Collection integration, every row unchanged;
    - frontend: eslint, tsc and prettier pass, and the changed areas pass 79 of 79.

    Staging check after deploy: note the highest VUL per company and counts by state, then run each feed once. Expect no new VULs, nothing fixed or reopened, and Secrets `new` = 0. The full list is in the PR.
- id: 01M76B3NTEJW39J87X4NGP855Y
  author: Steve Vine
  at: 2026-11-11T22:19:29.486257Z
  text: |-
    Passed: what a person sees (Claude's pre-UAT pass, staging fcaf1d13, as E2E Admin A). The data carry-over and feed runs were checked separately by the lead. I left the two held Aikido runs (COM-1740) alone.

    Seen:
    - **Admin ▸ Integrations** (Installed 12, All 16):
      - Core holds Microsoft, Active Directory, AWS, Azure, Google Cloud, SMTP, SendGrid, Amazon SES, S3 and endoflife.date.
      - Collection holds Aikido, Cloudflare, Datadog, GitHub, MongoDB Atlas and Nessus.
      - The coded Nessus, Aikido and GitHub tiles are gone, and so is the "Security tools" category.
    - **Old addresses:** each lands on the Collection integration of the same name.
      - /admin/integrations/nessus opens Nessus;
      - /admin/integrations/aikido?tab=configure opens Aikido;
      - /admin/integrations/github opens GitHub.
    - **Uploads:** Vulnerabilities ▸ Import still offers "Nessus file".
    - **History is still visible.** I opened two VULs read-only, without switching company:
      - VUL-12 in Test Company, from the old Nessus reader, still shows its source as "Nessus", first and last seen 27 Oct 2026, its reference 57582, and its history.
      - A feed-read VUL (VUL-5631) shows "Nessus · Findings".
      - Test Company's register holds 8 VULs sourced "Nessus" (old reader) and 12 from the Nessus feed.

    Not looked at on screen: the retired Nessus and Aikido keys in the Secrets register.

    Screenshots: ~/compass-uat/sprint0-2026-11-11/COM-1716/
assignee: steve
label:
- tech_debt
priority: medium
task_status: done
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