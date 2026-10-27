---
id: 01M5YA9GHNHTXNSZ3JMFTWECB9
created: 2026-10-27T09:15:34.837257Z
updated: 2026-10-27T23:40:01.490782Z
type: task
title: 'ADR: how a source''s report becomes vulnerabilities — which company it''s for, which system each finding is on, when two reports are the same issue, and when a source''s silence means fixed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1374
sprint: ssp4evc
blocked_by:
- 01M5YA50427VV9TF8B3VTA44Q6
- 01M5Y9FKJYXKVFE847JCK8FEEX
comments:
- id: 01M5ZVRAHK68H4D3K2J5ZJEPF7
  author: Steve Vine
  at: 2026-10-27T23:40:00.4355Z
  text: |-
    Done — PR #1390, merged to main. The amendment is appended to ADR 0129 (decisions/0129-vulnerabilities.md, "Amendment (2026-10-27, COM-1374)").

    What it decides:
    - Each Nessus scan, and each Aikido repository, container or cloud, is given to one company on its tile. New ones are "Not assigned", aren't read, and turn the tile to Needs attention.
    - What a source reports is kept as findings on a target (a host, repository, image or URL). A target is placed once, in this order: what Compass already knows (discovery's attached resources and directory servers, and the asset's own aliases), then the company's matching rules in order, otherwise Unmatched. Once placed it stays: a later rule never moves it.
    - One CVE on one system is one vulnerability, whichever sources report it. A finding with no CVE, or several, is the source's own check: one Nessus plugin is one thing to fix.
    - A source closes only what it looked at again. A host missing from a run closes nothing. A vulnerability is Fixed, confirmed by the source, when its last scanner sighting closes.
    - Severity is the worst live sighting's, unless a person set it; then it sticks until they choose the sources' severity again.
    - Informational findings are kept, and enter the register only if Settings ask.
    - Pen tests: the report is evidence on the SAP testing entry, and nothing enters the register until a person confirms. A retest confirms fixes.

    Recorded honestly: the real Nessus Expert and Aikido check (COM-1359) still waits on your keys on staging. So Compass pulls through Nessus's documented export, and upload of a .nessus file is always offered. The ADR gets corrected if the real servers differ.

    My calls, for you to overturn:
    - a placed target stays put;
    - several CVEs = one vulnerability;
    - an Accepted vulnerability the source no longer sees becomes Fixed;
    - snoozed in Aikido = Accepted until the snooze ends;
    - asset aliases count as "already known".
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 92, Vulnerabilities - Scanner sources. Amends the Vulnerabilities ADR (COM-1362), using what COM-1359 learned about Nessus Expert's API and Aikido's.

## What the ADR decides

- **A source is set up once for the organisation** on its Integrations tile, and each part of it is mapped to a company once:
  - a Nessus **scan**;
  - an Aikido **repository, container or cloud**.
  - Unmapped parts are not read. The tile lists them as "Not assigned to a company".
- **Each finding is a sighting.** It is matched to a system in this order:
  1. what discovery already knows: a cloud resource, or a directory server, attached to a technology asset;
  2. a **matching rule** a person saved, e.g. hostname pattern, IP range, repository or image → technology asset;
  3. otherwise it waits on **Unmatched**.
- **Same issue, same system → one vulnerability.** Same means:
  - the same CVE;
  - for non-CVE findings, the same source check, e.g. a Nessus plugin or an Aikido rule.
  - A Nessus finding and an Aikido finding of the same CVE on the same system are one vulnerability with two sightings.
- **A source closes what it no longer sees, but only where it looked.**
  - A newer finished Nessus scan of a host that doesn't report the finding closes that sighting.
  - A host missing from the newer scan closes nothing.
  - Aikido says when it considers an issue fixed.
  - A vulnerability is **Fixed** when its last open sighting closes. It is marked "confirmed by <source>".
- **Severity:** the worst current sighting's severity, unless a person has changed it. A person's change sticks until they undo it.
- **Pen-test reports:**
  - Polaris reads the report and proposes findings;
  - a person confirms each before it enters the register;
  - the report is kept as evidence on the SAP testing entry;
  - nothing enters the register unconfirmed.
- **Informational findings** are kept as sightings but don't become vulnerabilities unless the company's Settings ask for them.

## Notes (technical)

- Record the actual Nessus Expert API boundaries from COM-1359. If the pull isn't possible, the ADR says upload is the route, and the pull task shrinks to upload only.

**Chain:** independent (documents only).

**Done when:** the ADR amendment is merged.