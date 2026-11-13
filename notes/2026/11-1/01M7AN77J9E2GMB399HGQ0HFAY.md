---
id: 01M7AN77J9E2GMB399HGQ0HFAY
created: 2026-11-13T14:33:09.449007Z
updated: 2026-11-13T14:33:11.13317Z
type: task
title: Activity log details show no raw JSON, timestamps or "(not named)" lists
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1796
sprint: spsp226
assignee: steve
label:
- bug
priority: medium
task_status: active
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