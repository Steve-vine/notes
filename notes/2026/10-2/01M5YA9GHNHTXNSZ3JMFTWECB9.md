---
id: 01M5YA9GHNHTXNSZ3JMFTWECB9
created: 2026-10-27T09:15:34.837257Z
updated: 2026-10-27T09:15:34.837257Z
type: task
title: 'ADR: how a source''s report becomes vulnerabilities — which company it''s for, which system each finding is on, when two reports are the same issue, and when a source''s silence means fixed'
task_status: todo
priority: high
label: brief
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1374
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