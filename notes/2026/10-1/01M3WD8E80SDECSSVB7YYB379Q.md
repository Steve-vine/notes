---
id: 01M3WD8E80SDECSSVB7YYB379Q
created: 2026-10-01T18:57:32.928816Z
updated: 2026-10-01T20:40:06.655929Z
type: task
title: Rename SOC2 version
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 826
sprint: s0zzctz
comments:
- id: 01M3WK447C5H17S4JP71DE1A5G
  author: Steve Vine
  at: 2026-10-01T20:40:03.052658Z
  text: |-
    Merged: PR #829 (6393479).

    SOC 2's version now reads "2017 (Revised 2022)" everywhere it is shown — the Frameworks tiles and list, the framework's page, coverage.

    To check on staging: Playbook ▸ Frameworks — the SOC 2 tile and row.

    Technical: the seed carries the new label for a fresh install; migration 0219_soc2_version_label renames the row already in the database (the importer never touches an existing framework, ADR 0028). It only renames a row still carrying the old label, so a hand-edited version would be left alone. Tested against a populated database, including the downgrade.
assignee: steve
label: null
priority: medium
task_status: review
---
SOC2 version is currently '2017 TSC (revised points of focus, 2022)' 
Rename this to just '2017 (Revised 2022)' 