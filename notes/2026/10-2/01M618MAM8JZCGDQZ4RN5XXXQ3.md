---
id: 01M618MAM8JZCGDQZ4RN5XXXQ3
created: 2026-10-28T12:44:15.368099Z
updated: 2026-10-28T14:56:15.345118Z
type: task
title: 'Nessus and Aikido: set many scans to "Don''t read" at once, and the tile says that''s how to clear Needs attention'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1394
sprint: ssp4evc
comments:
- id: 01M61G5AS7VQXS7FEFXCB91XP3
  author: Steve Vine
  at: 2026-10-28T14:55:52.615734Z
  text: |-
    Done. PR #1411, merged to main at aa5706ae. Going to staging with the other six.

    The scans list on the Nessus tile now says: "Give each scan to a company, or choose Don't read for one Compass should leave alone. The tile needs attention while any scan is still Not assigned."
    - Filter: Not assigned / Assigned / Don't read / All, each with its count.
    - A tick box on each row, plus one at the top for everything shown.
    - "Select all Not assigned" ticks every waiting scan and narrows the list to them.
    - With rows ticked, pick Don't read (the default), a company or Not assigned, then press "Set N". It's all or none.
    A scan Nessus adds later still arrives as Not assigned and flags the tile. Aikido's repositories, containers and clouds list works the same way.

    My calls (yours to overturn):
    - The filter opens on All.
    - "Select all Not assigned" also switches the filter to Not assigned.
    - No Polaris change: no Polaris tool sets a scan's company today.

    To check on staging: on the Nessus tile, press "Select all Not assigned" (about 67 scans), then set them to Don't read. The tile should turn Connected unless a read error is also showing.

    Technical: new POST /api/v1/integrations/{source}/parts/assign taking {part_ids (1–1000), company_id, dont_read}. It follows the same rules as the single change and returns the parts it changed. No migration.
assignee: steve
label:
- improvement
priority: medium
task_status: review
---
Sprint 92, Vulnerabilities - Scanner sources. Builds on the Nessus task (COM-1376) and the Aikido task. Found by Steve on staging, 2026-10-28, while testing sprints 90–93.

## What's wrong

The Nessus tile says **Needs attention** because scans aren't assigned to a company. On staging, 67 of 69 scans are unassigned; only MSG and VoiceNation are assigned. Many of these scans never need assigning: copies, old scans, tests and compliance-only scans.

Compass can already set a scan aside. Each scan's Company menu has **Don't read**, and a scan set to it no longer counts against the tile. But:

- the explanation above the list mentions only "Not assigned", so nobody is told Don't read exists or that it clears the flag;
- setting 60-odd scans one at a time, each through its own menu, is slow.

## What people should see

- **The explanation names both choices:** "Give each scan to a company, or choose Don't read for one Compass should leave alone. The tile needs attention while any scan is still Not assigned."
- **Many at once:** a tick box on each row, a "Select all Not assigned" shortcut, and an action to set what's ticked to Don't read or give it all to one company.
- **A filter** for the list: Not assigned, Assigned, Don't read, All. With 69 scans, what still needs a choice is otherwise hard to find.
- **Unchanged rule:** a scan Nessus adds later arrives as Not assigned and turns the tile to Needs attention again, so a new scan is never silently left unread. That's my call: the flag is how a new scan gets noticed, and Don't read settles each one for good.
- The same applies to Aikido's repositories, containers and clouds, which use the same list.

## Notes

- Don't read already exists end to end (`dont_read` on the scanner part); this is screen work plus a bulk assign route.
- Polaris's scanner tools may want the same bulk choice. Check whether the Unmatched/sources tools from COM-1381 should take a list.