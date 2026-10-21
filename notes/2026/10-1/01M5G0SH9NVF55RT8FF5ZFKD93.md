---
id: 01M5G0SH9NVF55RT8FF5ZFKD93
created: 2026-10-21T20:00:12.085982Z
updated: 2026-10-21T20:00:17.57733Z
type: task
title: 'ADR: Audit ▸ Evidence — one register of every piece of evidence Compass holds, found by framework control, core control or free text; warned when out of date, archived when replaced, kept forever unless someone downloads and deletes old archive; pulled together into an audit pack'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1198
sprint: sno3i7m
assignee: steve
label:
- brief
priority: high
task_status: todo
---
Sprint 82, Evidence. The decision record for the sprint: **ADR 0122** (0121 is time zones), plus the IA brief's menu table and the permission catalogue. Every other task builds on it.

**Chain:** independent

## Why (review, 2026-10-21)

Evidence lives in each module on its own terms and nothing brings it together.

- The newer modules (plan, incidents, data privacy, attestations) lock their evidence once the work is done. A company's assessment of a control — the original home of evidence — is the weakest: anyone who can assess can remove a file at any time with no reason, files aren't tied to the version of the assessment they backed, nothing has a period covered or valid-until date, and history hides the evidence.
- Nothing is ever archived; removing only hides. Replacing a trust centre PDF overwrites its dates; replacing a policy's uploaded file loses the way back to the previous file.
- Ways evidence can be lost today: vendor certificates are deleted with one click and no record and overwritten on renewal; export downloads very likely stop after about a day though the screen says seven; the plan's evidence zip loses same-named files; archived companies still accept assessment and risk file changes; Activity shows file changes as an ID with no company.
- For an audit, only the plan's export hands over files. Nothing gathers a framework's evidence; the SoA and coverage reports carry no evidence. ADR 0024 deferred an evidence pack (DEV-506) and it was never built.

## What Steve decided (2026-10-21)

1. A new **Audit** section in the menu, below Modules, holding **Evidence**.
2. A downloadable **audit pack**, and Audit permissions like the other sections, including read-only.
3. **Warn** when evidence is out of date; **archive** it when it's replaced.
4. Keep everything **forever**, with an option to **download and then delete** archived evidence older than a chosen date.
5. A pack covers a **period**; no "as at a date" view.
6. Search: pick a framework, pick one of its controls, see all its evidence; pick a core control, see all its evidence; open a piece of evidence and see every framework control it supports; free-text search across controls and evidence.

## My calls (for Steve to confirm)

1. **What's in the register:** every file and link held anywhere — assessments, risks, the plan, incidents, data subject requests, the trust centre and vendor certificates — plus the policies, standards and procedures that cover a control (their current published version, by domain membership). Evidence of operation (signatures, reviews, handled incidents) shows on a control's evidence but isn't an item of its own.
2. **Per company**, following the company picker. Library content shows for every company.
3. **Which controls evidence supports** comes from where it was added (an assessment → its control; a plan activity → its linked controls; incidents and data subject requests → the controls those modules already feed; a policy → its domain's controls), plus any extra controls someone links it to. Framework controls always follow from the library's mappings — nobody links them by hand.
4. **Kinds** are a fixed list: Policy or procedure · Configuration or screenshot · Report or export · Log or record · Certificate or audit report · Test result · Other.
5. **Out of date:** each piece of standing evidence has a valid-until date — the one given, or else 12 months after the end of the period it covers, or after it was added. Amber 30 days before, red after, and a to-do. Evidence from finished work (a done plan activity, a closed incident or request) records something that happened, so it never goes out of date. It only warns: it never changes a control's status.
6. **Existing evidence** gets valid-until 12 months after it was added, so anything older than a year shows Out of date from day one.
7. **Archive, don't remove:** "Remove" on an assessment's or risk's file becomes "Archive" with a reason. Modules that already lock their evidence keep their rules.
8. **Permissions:** View audit (read-only, including downloading and building audit packs), Manage evidence, Delete archived evidence (marked dangerous). Built-in Admin only; starter roles stay frozen. Evidence on a restricted incident or a data subject request stays hidden unless the person can see those too.
9. **Audit pack** includes everything that was current at any time in the period, including versions since replaced, with each file's fingerprint so an auditor can check it hasn't changed. Downloadable for 30 days; the record is kept forever.
10. **Download and delete** never touches evidence on an open incident or a legal hold, or data subject requests (they have their own retention). Delete is offered only after the zip has been downloaded. A deletion log keeps what went, forever.
11. **Free-text search** covers names, numbers, descriptions, file names and link titles — not the text inside files.

## Not in this sprint

Scanning files for viruses; moving files between storage locations; searching inside files; a login for external auditors; an "as at a date" view.

**Done when:** ADR 0122 is merged, the IA brief has the Audit section, and the permission catalogue has the Audit table.