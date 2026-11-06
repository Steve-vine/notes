---
id: 01M6RR9KN7XZW92ERQ2T3NF4VF
created: 2026-11-06T15:40:35.717084Z
updated: 2026-11-06T15:42:24.299379Z
type: task
title: 'Field alignment: a field with a hint pushes its row-mate''s box down — fix every row in the app, and add a test so a new form can''t do it again'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1623
sprint: s5khbev
assignee: steve
priority: medium
task_status: backlog
---
![CleanShot 2026-11-06 at 15.36.34.png](attachments/2026/11/01M6RR9KN7XZW92ERQ2T3NF4VF/CleanShot-2026-11-06-at-15.36.34.png)

Raised by Steve while testing on staging (2026-11-06). The Collection integration form puts "Paging" and "Where the items are" on one row. "Where the items are" has a hint under its label, so its box sits lower than the Paging box. Steve sees this often.

## Why it keeps coming back

The rule is already written down: "A described field never pushes its row-mates out of line", in `brief/information-architecture.md` → Screen conventions (COM-679, COM-682, 2026-09-11). It has a shared fix, `components/FieldRow.tsx`, which puts each part of the fields (label, hint, box, error) on a shared track so the boxes line up. But nothing enforces it, so new forms reach for a plain `SimpleGrid` or `Group` instead.

A scan on 2026-11-06 found 18 rows that mix a hinted field with a plain one outside FieldRow. Some may be a field beside a button, which is a false positive, so check each:

- incidents/IncidentAiCard.tsx:443, IncidentReviewCard.tsx:739, IncidentServiceImpactCard.tsx:188
- incidents/settings/RuleListSection.tsx:513, CompanyStandardRules.tsx:311
- vulnerabilities/RuleWindow.tsx:145
- access/ReportSchedule.tsx:218
- inventory/DiscoveryRules.tsx:364
- pages/ControlDetailPage.tsx:866
- secrets/SecretModal.tsx:336
- riskAssessments/bia/duration.tsx:45
- securityFeed/watchLists/WatchListsTab.tsx:259
- integrations/collection/Accounts.tsx:226, DefinitionForm.tsx:127 (this screenshot), DefinitionForm.tsx:145
- dsr/settings/DeadlineRulesSection.tsx:534, dsr/disclosures/AboutWhomFields.tsx:136
- trustCentre/settings/TrustCentreSettingsTab.tsx:190

## Done when

- Every row of input fields that has a hint on at least one field is a FieldRow, so labels sit level and boxes sit level. This includes the Paging row in the screenshot.
- `screen-conventions.test.ts` fails when a `SimpleGrid` or `Group` holds two or more input fields and at least one has a `description`. It is the same kind of check as the existing SortableTh and Switch-width rules. A row that is meant to be different carries a comment saying why, as those rules allow.
- CLAUDE.md → Frontend gets one line: "Fields on one row line up: use FieldRow (Screen conventions)", so it is read before a form is built.
- On staging: the Collection integration form, and a sample of the screens above, show the boxes in each row level.