---
id: 01M7AN77J9E2GMB399HGQ0HFAY
created: 2026-11-13T14:33:09.449007Z
updated: 2026-11-13T17:51:49.348749Z
type: task
title: Activity log details show no raw JSON, timestamps or "(not named)" lists
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1796
sprint: spsp226
comments:
- id: 01M7APHQZ40FEQ3BDNHE99AJBH
  author: Steve Vine
  at: 2026-11-13T14:56:22.500392Z
  text: |-
    Built: PR #1782 (feature/com-1796-activity-details-words, c1ab9ffa), auto-merge set. It is on the chain, with migration 0837_activity_details_words after 0836.

    **What a person now sees,** in Admin ▸ Activity and on every History card:
    - **Coverage proposals:** "People: 235 people → 236 people".
      - People Compass can name are listed by name, cut after five with "and N more".
      - No label says "ids", e.g. "Watch lists: 1 watch list → 2 watch lists", "CVEs: CVE-…, … and 1 more".
    - **Structured values:** no raw JSON anywhere.
      - A content section reads "Text changed", and a collected check "Rule changed".
      - A Security Feed match no longer shows its decided snapshot, and "versions_not_stated" reads "Versions not stated".
    - **Times:** "On until: — → 13 Nov 2026, 14:37 GMT", in the reader's own time zone like the rest of Compass. Plain dates read as dates.
    - **Minor items:**
      - "(source: a CSV import)".
      - "Reading status: Reading → Read" and "Health: OK → Error".
      - The Entity filter says "SAP entry", as the rows do.

    **How:** the Activity screen reads every detail value by general rules, never per table:
    - a structured value reads "changed";
    - a list is named, cut short or counted;
    - a time is formatted;
    - a stored key reads as words.

    So old rows read correctly with no rewrite. The migration only rewrites old "(source: csv_import)" summaries. New rows store structured values as "changed". The restricted privacy-request guard is unchanged.

    **Tests:**
    - A general test renders 16 value shapes under 16 column names. It fails on JSON, ISO time text, ids, stored keys, "(not named)" inside a list, or a line of 200 characters or more.
    - Logger unit tests, and a migration test (seed old rows at 0836, then upgrade).

    **Checks:**
    - ruff, mypy, and the unit suite (2207) pass.
    - 104 integration tests pass, across activity, migrations, privacy-request close, inventory import, coverage proposals, mail catcher, Security Feed, collected checks and others.
    - eslint, tsc and prettier pass, and the full vitest suite passed 4030 of 4030.
    - One Alembic head; no OpenAPI drift.

    **Not done:**
    - Coverage-proposal people are counted, not named: they are directory people, not Compass users.
    - Snapshots and rules read "changed" rather than a summary.
    - A single reference that can't be named still reads "(not named)".
- id: 01M7ARVRVV99RF6T939SA0WGQV
  author: Steve Vine
  at: 2026-11-13T15:36:48.250947Z
  text: |-
    Pre-UAT on staging 08593437, as E2E Admin A in Admin ▸ Activity: **Passed**. I read the latest 1,500 rows for E2E Test Company and 1,500 across all companies, plus every row of the entity types listed below.

    1. **Coverage proposals:** all 171 rows read like "People: 233 people → 235 people". None has "(not named)" or a label with "ids", and the longest detail line is 56 characters.
    2. **Raw JSON:**
       - Content section: "Text changed" in all 616 rows, back to 29 Aug.
       - Collected check: "Rule changed", plus a readable "Rule text".
       - Security Feed match: no snapshot is shown; "Status: Versions not stated → Confirmed"; "History changed".
    3. **Mail catcher:** "On until: — → 13 Nov 2026, 15:49 UTC". It reads UTC because the test browser's clock is UTC. All 75 rows are formatted this way.
    4. **Minor items:**
       - "(source: a CSV import)".
       - "Reading status: Reading → Read" and "Health: OK → Error".
       - "CVEs: — → CVE-2021-41773".
       - The Entity filter says "SAP entry" and "SAP entry control" (265 options, none lower case or snake_case).
    5. **Sweep:** no ISO timestamps, no "+00:00", no "(not named)", and no UUIDs with the company filter on.

    Smaller wording leftovers outside this task's "Done when" are logged separately as a todo for Steve to decide.

    Screenshots and the captured rows are in ~/compass-uat/spsp226/COM-1796/.
assignee: steve
label:
- bug
priority: medium
task_status: done
---
Fix-forward from the COM-1785 pre-UAT pass on staging (ee0d160c, 2026-11-13). Seen as Admin A in Admin ▸ Activity, E2E Test Company.

**What happens:**
1. **Coverage proposal rows** ("updated coverage proposal a role to write for 235 people") show "Directory user ids: (not named), (not named), …" hundreds of times in one row, about 6,000 characters, on both sides of the arrow. COM-1785 turned unnamed ids into "(not named)" item by item, which made this worse.
2. **Raw JSON in details:**
   - Content section: "Doc: {"type":"doc","content":[…]}".
   - Security Feed match: "Decided snapshot: {"found":"affected",…}" and "versions_not_stated".
   - Collected check: "Rule: {"mode":"at_most",…,"label":"roleDefinitionId"…}".
3. **Mail catcher switch detail:** "On until: — → 2026-11-13 14:37:33.545187+00:00".
4. **Minor:**
   - "(source: csv_import)" on assets created by CSV import.
   - Lower-case states: "Reading status: reading → read", "Health: ok → error".
   - The label "Cve ids:" should read "CVEs".
   - The Entity filter says "Plan entry" / "Plan entry control" where the rows say "SAP entry".

**What it should do:**
- A list of people reads as names. A long list is cut short with "and N more". Where the people can't be named, the line reads as a count ("235 people → 236 people"). The label never says "ids".
- A structured value (a document body, a snapshot, a rule) is never dumped. Either it reads "changed" (e.g. "Text: changed"), or it gets a short summary in words where one exists.
- Times read like the summary ("13 Nov 2026 14:37 UTC").
- Stored states and keys read as screen words.
- The filter and the rows use the same name.

**Done when:**
- On staging, the rows above read in words with no JSON, no raw timestamps and no repeated "(not named)", old rows included where the migration can reach them.
- A general test fails if any detail value renders as JSON or ISO text.
- Independent unless a migration is needed. If one is, it goes on the chain after 0836.