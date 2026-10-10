---
id: 01M4GQDYQFN508Q9QZ5KVFEZX2
created: 2026-10-09T16:20:08.047729Z
updated: 2026-10-10T16:07:41.046985Z
type: task
title: Database engines found in AWS appear in the Software register — where they run comes from discovery, and support dates from AWS where it publishes them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 889
sprint: svsqcj9
blocked_by:
- 01M4GQBSJMKTPGQGYTCVW22ENQ
comments:
- id: 01M4K93SN8M18ZW7S5YG8PARBV
  author: Steve Vine
  at: 2026-10-10T16:07:38.408382Z
  text: |-
    Merged to main (PR #897, 2026-10-10). On staging once all ten tasks are in Review.

    What to look at:
    - On the Software assets tab, a blue "Found in AWS, not in this register" strip lists each database engine running beneath a technology asset that the register does not have, for example "PostgreSQL 15, on 1 technology asset (Billing)".
    - Add it opens the usual software form with the name, version and type filled in. Licence, cost and owner are left for you.
    - It is already here lets you pick the existing software entry it is.
    - Dismiss removes the suggestion for good.
    - A software entry added or matched this way lists the technology assets it runs on under Deployed on, each marked "Discovered" with the resource it came from. Those lines cannot be removed by hand.
    - Where AWS publishes support end dates for the engine version, the entry shows them with "From AWS" beneath. If you have typed a date and AWS's is different, it says "AWS says" and the date.

    Behaviour worth knowing:
    - Nothing is copied. Where an engine runs is worked out each time from what sits beneath each technology asset, so when a database is upgraded to a new major version the line moves to that version's entry on the next read. A minor upgrade (15.4 to 15.7) moves nothing.
    - A date you typed is never overwritten. AWS's date is used to say "in support" or "out of support" only where nothing was typed.
    - A discovered install counts as one licence in use per technology asset, the same as one entered by hand. Where the same asset is both typed and discovered it is one line, with the typed count.
    - An entry with a discovered install counts as in use and cannot be deleted.
    - A suggestion only appears once the database sits beneath a technology asset. One still awaiting a decision suggests nothing.
    - Only managed database engines are covered (RDS, Aurora, and DocumentDB and Neptune where AWS lists them the same way). Operating systems on servers are not.

    One thing differs from the task text: AWS's dates are not written into the entry's own date fields when it is added. They are shown beside them. That keeps "typed by a person" and "published by AWS" apart, so a later change at AWS is picked up and a typed date can never be mistaken for one.

    Checked rather than assumed: the AWS call for support dates and the names of its fields were read from the AWS library Compass ships with, not from memory. For an engine version AWS does not list, no date is shown.

    Technical: migration 0238 (software_assets.discovery_key, software_discovery_dismissals). The role template gains one permission (rds:DescribeDBMajorEngineVersions); without it databases are still read and the dates are simply unknown.
assignee: steve
label:
- feature
priority: low
task_status: review
---
Part of sprint 67, Inventory expansion (ADR in COM-881). Today someone types each piece of software and each place it is installed. For managed databases in AWS, the place and the version are already known.

## What people see

- **A software entry such as "PostgreSQL 15" lists the technology assets it runs on without anyone adding them**, wherever a resource beneath the asset runs that engine and version. Those lines are marked "Discovered" and cannot be edited or removed by hand.
- **When a database is upgraded, the line moves** to the new version's entry on the next read.
- **An engine that is running but is not in the Software register is suggested** on the Software tab: "Found in AWS: MySQL 8.0, on 3 technology assets — add it". Adding opens the usual form with name and version filled in. Licence and cost are left blank for the person.
- **A suggestion can be dismissed**, and stays dismissed.
- **Support end dates are filled in from AWS where AWS publishes them for that engine version.** Where it does not, the date is left blank. A date a person has typed is never overwritten; if AWS's date differs, the entry says so.
- **Hand-entered installs are untouched** and sit beside discovered ones.
- **Scope:** managed database engines only (RDS and Aurora in this task). Operating systems on servers are not covered; AWS does not report them without a further service.

## Notes (technical)

- **Derive, do not sync.** A discovered install is computed at read time from `technology_asset_resources` joined to resource `facts` (engine, major version) and matched to a software asset. No `ContainerSoftware` rows are written for it, so there is nothing to reconcile when a version changes.
- **Match key.** `software_assets` gains a nullable `discovery_key`, for example `aws.rds:postgres:15`, set when an entry is added from a suggestion and settable on an existing entry ("this is the same thing as…"). Unique per company.
- **Major version only.** Minor versions (15.4, 15.7) are a fact on the resource, not separate software entries.
- **Licences used.** COM-692 derives "used" from where the software is installed. Decide here, and say in the PR, whether a discovered install counts as one use like a hand-entered one (recommended: yes, one per technology asset, so the figure does not change meaning by source).
- **Support dates.** RDS exposes engine lifecycle dates through `DescribeDBMajorEngineVersions`. Confirm the exact operation and field names against the current boto3 documentation before building; if a date is not returned for an engine, store nothing. No date is ever written from memory.
- **Suggestions** are the distinct match keys among attached resources that no software asset claims, with a small `dismissed_discovery_keys` list per company.
- **Reads.** Extend `core/software_reads.py` so the installed-on list and the in-use derivation (COM-695: whether software is in use is derived from where it is installed) include discovered installs. The guarded delete must treat a discovered install as "in use".
- **API.** Suggestions list, dismiss, and the `discovery_key` field. `inventory.manage_register`. Regenerate `schema.d.ts` and run the drift script.
- **Screen.** `SoftwareAssetDetailPage.tsx` for the marked lines; the Software panel in `InventoryPage.tsx` for suggestions.
- **Tests.** Integration: a discovered install appears and moves on a version change, a hand-entered install is unaffected, the guarded delete refuses, a typed support date survives, dismissal sticks. Vitest for the suggestion row and the marked lines.

**Done when:** on staging, the engine of a database beneath a technology asset shows that asset on its Software entry without anyone adding it, and an engine not yet in the register is offered as a suggestion.