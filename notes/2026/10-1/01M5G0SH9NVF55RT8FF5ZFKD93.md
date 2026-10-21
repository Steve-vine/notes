---
id: 01M5G0SH9NVF55RT8FF5ZFKD93
created: 2026-10-21T20:00:12.085982Z
updated: 2026-10-21T20:36:46.320454Z
type: task
title: 'ADR: Audit ▸ Evidence — one register of every piece of evidence Compass holds, found by framework control, core control or free text; warned when out of date, archived when replaced, kept forever unless someone downloads and deletes old archive; pulled together into an audit pack'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1198
sprint: sno3i7m
comments:
- id: 01M5G1399TB1YCRZCS9YFHBVBH
  author: Steve Vine
  at: 2026-10-21T20:05:31.57795Z
  text: |-
    Sprint plan, in build order (each blocked by the one before):

    1. COM-1198 — this ADR (independent)
    2. COM-1199 — Audit in the menu, permissions (chain: API)
    3. COM-1200 — every piece of evidence carries the same facts and a fingerprint; existing evidence filled in (chain: migration + API)
    4. COM-1204 — nothing gets lost: exports last 7 days, zip names, plan export check, archived companies, Activity names (chain: migration + API)
    5. COM-1205 — the Evidence register, and what each piece supports (chain: API)
    6. COM-1206 — evidence for a core control (chain: API)
    7. COM-1207 — evidence for a framework control (chain: API)
    8. COM-1208 — free-text search (chain: migration + API)
    9. COM-1209 — add evidence in the register; link one piece to several controls (chain: migration + API)
    10. COM-1210 — out-of-date warnings (chain: API)
    11. COM-1211 — replace archives the old version; remove becomes archive; Archived tab (chain: migration + API)
    12. COM-1212 — assessment history shows its evidence; Evidence of operation in the queue (chain: migration + API)
    13. COM-1213 — vendor certificates keep their history (chain: migration + API)
    14. COM-1214 — the audit pack (chain: migration + API)
    15. COM-1215 — download and delete old archived evidence (chain: migration + API)
    16. COM-1216 — the assistant (independent, built last)

    COM-1201–1203 belong to another session's work, not this sprint.
- id: 01M5G22WRJJGZEHY1FVHSSS93V
  author: Steve Vine
  at: 2026-10-21T20:22:47.313991Z
  text: |-
    Plan updated 2026-10-21: Steve asked for evidence types as a rubric. New task COM-1217 (Evidence types rubric, chain: migration + API) sits between COM-1199 and COM-1200 — COM-1200 is now blocked by COM-1217, and COM-1217 by COM-1199. "Kind" is now "evidence type" in every task, and out-of-date warnings (COM-1210) use each type's Valid for.

    Build order: 1198 → 1199 → 1217 → 1200 → 1204 → 1205 → 1206 → 1207 → 1208 → 1209 → 1210 → 1211 → 1212 → 1213 → 1214 → 1215 → 1216.
- id: 01M5G2WF4WS3RC7R19VMEVTD6X
  author: Steve Vine
  at: 2026-10-21T20:36:45.340384Z
  text: |-
    Done — merged in PR #1213.

    - ADR 0122 (decisions/0122-audit-evidence.md) records your seven decisions, how each part works, my calls (marked "not yet confirmed by Steve"), what's out of scope, and the task list.
    - The screens brief has the new Audit section below Modules: Audit ▸ Evidence and its five tabs.
    - The permissions reference has an Audit table: View audit, Manage evidence and Delete archived evidence. The last joins the dangerous list, which now has six.
    - The rubrics reference has Evidence types: the seven defaults, each valid for 12 months, and the rules for retiring, deleting and Other.

    My calls (beyond the task):
    - I added one call to the list: when a control replaced a retired one, the retired control's evidence is shown with it (as COM-1206 says).
    - Under out of scope: per-company evidence types, and hash-chaining the activity log.
    - "Manage rubrics" now covers evidence types too.
assignee: steve
label:
- brief
priority: high
task_status: review
---
Sprint 82, Evidence. The decision record for the sprint: **ADR 0122** (0121 is time zones), plus the IA brief's menu table, the permission catalogue and the rubrics brief. Every other task builds on it.

**Chain:** independent

## Why (review, 2026-10-21)

Evidence lives in each module on its own terms and nothing brings it together.

- The newer modules (plan, incidents, data privacy, attestations) lock their evidence once the work is done. A company's assessment of a control — the original home of evidence — is the weakest: anyone who can assess can remove a file at any time with no reason, files aren't tied to the version of the assessment they backed, nothing has a type, a period covered or a valid-until date, and history hides the evidence.
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
7. **Evidence types are a rubric** (Admin ▸ Rubrics ▸ Evidence types, COM-1217), seeded with: Policy or procedure · Configuration or screenshot · Report or export · Log or record · Certificate or audit report · Test result · Other.

## My calls (for Steve to confirm)

1. **What's in the register:** every file and link held anywhere — assessments, risks, the plan, incidents, data subject requests, the trust centre and vendor certificates — plus the policies, standards and procedures that cover a control (their current published version, by domain membership). Evidence of operation (signatures, reviews, handled incidents) shows on a control's evidence but isn't an item of its own.
2. **Per company**, following the company picker. Library content shows for every company. The evidence types rubric is organisation-wide, like the other rubrics.
3. **Which controls evidence supports** comes from where it was added (an assessment → its control; a plan activity → its linked controls; incidents and data subject requests → the controls those modules already feed; a policy → its domain's controls), plus any extra controls someone links it to. Framework controls always follow from the library's mappings — nobody links them by hand.
4. **The evidence types rubric:**
   - Each type has a name, a description and a **Valid for** in months (12 for every default).
   - A type in use can be retired but not deleted.
   - **Other** can never be retired or deleted.
5. **Out of date:**
   - Each piece of standing evidence has a valid-until date: the one given, or else its type's Valid for counted from the end of the period it covers, or from when it was added.
   - Amber 30 days before, red after, and a to-do.
   - Evidence from finished work (a done plan activity, a closed incident or request) records something that happened, so it never goes out of date.
   - It only warns: it never changes a control's status.
6. **Existing evidence** follows its type's validity from the day it was added, so with the defaults anything older than a year shows Out of date from day one.
7. **Archive, don't remove:** "Remove" on an assessment's or risk's file becomes "Archive" with a reason. Modules that already lock their evidence keep their rules.
8. **Permissions:**
   - View audit (read-only, including downloading and building audit packs), Manage evidence, and Delete archived evidence (marked dangerous).
   - Built-in Admin only; starter roles stay frozen. The evidence types rubric uses the existing Manage rubrics.
   - Evidence on a restricted incident or a data subject request stays hidden unless the person can see those too.
9. **Audit pack** includes everything that was current at any time in the period, including versions since replaced, with each file's fingerprint so an auditor can check it hasn't changed. It can be narrowed to some evidence types. Downloadable for 30 days; the record is kept forever.
10. **Download and delete** never touches evidence on an open incident or a legal hold, or data subject requests (they have their own retention). Delete is offered only after the zip has been downloaded. A deletion log keeps what went, forever.
11. **Free-text search** covers names, numbers, descriptions, evidence types, file names and link titles — not the text inside files.

## Not in this sprint

Scanning files for viruses; moving files between storage locations; searching inside files; a login for external auditors; an "as at a date" view.

**Done when:** ADR 0122 is merged, the IA brief has the Audit section, the permission catalogue has the Audit table, and the rubrics brief has Evidence types.