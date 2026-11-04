---
id: 01M6EKPS3T8QZA757H4PAA9P8H
created: 2026-11-02T17:07:57.690776Z
updated: 2026-11-04T07:45:33.831938Z
type: task
title: Feeds an admin adds — any RSS or Atom feed they trust, added on the Sources tab with a test read first; switched off or removed later, with everything it brought kept
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1516
sprint: s6xh9g1
blocked_by:
- 01M6EKMBGM4NTB8WA0GV76AXKA
comments:
- id: 01M6EX57J8KXAE6ZN6FEJ9KVA5
  author: Steve Vine
  at: 2026-11-02T19:53:08.424174Z
  text: |-
    Done. Merged to main (PR #1533). It isn't on staging yet: the whole sprint goes there together once every task is in Review.

    What a manager can do now:
    - **Sources ▸ Add a feed** asks for the address, a name, how often to read it (hourly, every 6 hours or daily) and an optional note on why it's trusted.
    - **Test** reads the feed once without saving it. You see the feed's own title and its last five entries, or the problem in plain words. Only public HTTPS addresses are accepted, so `http://10.0.0.1/feed` is refused at Test.
    - On **Add**, it brings in whatever the feed still carries, up to 12 months back. After that it's read on the schedule you chose.
    - An entry that names a CVE joins that CVE's item. Any other entry becomes its own advisory, and Polaris reads it for products (COM-1517).
    - **Switch off** stops reading. **Remove** takes the feed off the list but keeps every item it brought in. On the item page (COM-1522) those items show as "From *name* (added by an admin)", plus "from a removed source" once the feed is removed.

    Worth knowing: most feeds carry only their latest 20–50 entries, so "12 months" really means "whatever is still in the feed".
- id: 01M6G9YWJ6MPXAAKV432DR0FJM
  author: Steve Vine
  at: 2026-11-03T08:56:06.470121Z
  text: |-
    Pre-UAT (staging, 2026-11-03): **Passed** for Test. **Couldn't check** Add, switch off and Remove.

    As E2E Admin A on Sources ▸ Add a feed:
    - The form has the feed address, Test, name, how often to read it, and why it's trusted.
    - Test with Sophos X-Ops' threat-research feed showed the feed's title and "15 entries. The latest:" with five entries and dates, without saving anything.
    - Test with https://www.example.com/ said "Compass can't read this feed. That address returned a web page, not a feed."

    For you to check: Add, then switch off and Remove. I didn't add one because a feed is shared by every company, so on staging it would put items into every company's feed, including real ones.

    Screenshots: ~/compass-uat/sprint-102/COM-1516/
assignee: steve
label:
- feature
priority: medium
---
Sprint 102, Security Feed (ADR 0139, COM-1510).

## What people see

- **Sources ▸ Add a feed** (managers):
  - the feed's address;
  - a name ("Sophos X-Ops");
  - how often to read it (hourly, every 6 hours, daily);
  - an optional note on why it's trusted.
- **Test** reads the feed once without saving. It shows the feed's own title and the last five entries as they'd appear, or the problem in plain words ("That address returned a web page, not a feed", "The feed's certificate isn't valid").
- On **Add**, it reads up to the feed's last 12 months, or whatever the feed carries.
- Each entry becomes an item, unless it names CVEs; then it's linked to those items, as NCSC advisories are. An entry the feed later edits shows Updated.
- **Switch off** stops reading. **Remove** takes the feed off the Sources list but keeps its items, marked "from a removed source".
- The item page shows an admin-added feed's entries as "From *Sophos X-Ops* (added by an admin)", so nobody mistakes them for a government or vendor source.

## Notes (technical)

- Fetch with the shared outbound HTTP client: HTTPS only, no redirects to private or internal addresses (block RFC 1918, link-local and the cluster's ranges), a size cap and a timeout.
- Parse with feedparser or an equivalent. Strip HTML to plain text; never render feed HTML. Ignore images and enclosures.
- An entry's identity is its GUID or link. Re-reads update the entry rather than duplicating it.
- Pull CVE ids from the title and body with a CVE pattern. Leave product extraction to Polaris (COM-1517).
- The address is validated server-side. Semgrep: no interpolated URLs or regexes built from input.

**Chain:** on the chain (migration + API).

**Done when:** on staging, a manager tests and adds a public security blog's feed and its entries appear. An entry naming a CVE is linked to that CVE's item. A private address (`http://10.0.0.1/feed`) is refused at Test.