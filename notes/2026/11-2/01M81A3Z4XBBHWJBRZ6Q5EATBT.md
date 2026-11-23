---
id: 01M81A3Z4XBBHWJBRZ6Q5EATBT
created: 2026-11-22T09:41:40.125933Z
updated: 2026-11-23T19:41:14.202653Z
type: task
title: The auditor reads a provided register — a read-only table in the auditor portal as it stood on the date provided, with the period's changes and a watermarked PDF
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 2095
sprint: ssj8zkq
blocked_by:
- 01M81A3P9ZNH9RGYR8CHYF4TJK
comments:
- id: 01M849JWX7DH1GQRWZ6BYSB3N9
  author: Steve Vine
  at: 2026-11-23T13:30:04.071836Z
  text: |-
    Built and merged to main: PR #2097 (7a210b51a). No migration. The portal's writes list is unchanged, with one new read-only route.

    What the auditor sees:
    - On a request, the provided register sits beside the evidence, with its name, prefix and "as at 31 Mar 2026".
    - Open shows its description, controls and last review date by then; a read-only table of the entries as they stood, sortable and searchable, with removed fields kept and archived entries marked; and Changes during the audit period, up to the provided moment, including import updates.
    - Download gives a watermarked PDF, and Download all includes it under its request.
    - A withdrawn one shows with its reason and can't be opened or downloaded.
    - The daily email adds a count ("1 register provided"), with no names.

    For Steve to decide: free text reaches the auditor exactly as typed, so a name typed here will be seen:
    - the register's name and description
    - field names and choice labels
    - text, long text and web address values, including entry titles and their earlier values in the changes list
    - the reason given when a register is withdrawn
    Deliberately left out: archive reasons, review comments and the reviewer, import file names, and notes on changes.

    Main remaining exposure: a shared register shows the auditor every entry, as ADR 0167 §6 says. Company fields are redacted, but an entry about another company can still identify it through its title or text. Shared registers are worth checking before providing one.

    Other decisions made while building:
    1. Listing doesn't lock a register; opening, downloading or Download all does. Ordinary evidence locks as soon as it's listed. The ADR says "opened" for registers.
    2. A Download all made before a register was withdrawn can no longer be fetched; the auditor asks for a new one.
    3. Controls shown are those linked by the provided date.
    4. A change to a Person field reads "the company → the company": the auditor can see that it changed, not who to.
    5. The audit period's day boundaries use UK time, because an auditor has no clock of their own in Compass.

    Existing gap, not changed: ordinary evidence withdrawn after a Download all was built stays in that older zip for up to 7 days. Closed for registers only.

    Tested against real Postgres: as at the date with the period's changes and a watermarked PDF; planted names, links, evidence, reasons and comments confirmed present inside Compass, then searched for in the full JSON, PDF text and metadata, file names, and the zip with its index; per-company registers; guessed, removed and other-audit IDs read as not found; first open locks it; open and download in Activity; withdrawn; a revoked auditor; the daily email count. CI and main build green.

    Not checked: the portal screen and the PDF's layout in a browser (pre-UAT pass); the daily email actually being sent; an expired auditor separately (same sign-in check as revoked); two auditors opening at the same instant.
- id: 01M84EPH8TSS80HWZAWZ5R6K4R
  author: Steve Vine
  at: 2026-11-23T14:59:26.105924Z
  text: |-
    Pre-UAT on staging e2248892e: COULDN'T CHECK. Nothing on this task was seen in a browser.

    Why: Admin ▸ Auditor portal, "Let invited auditors into the portal", is OFF on staging. While it's off, every link is refused and no auditor can be invited. The pass was told not to change Admin settings, so I left it off. The README provides no test auditor either. https://trust.citops.net/audit shows only "Sign in with the link from your invitation email."

    - Auditor sees the register as at the date, the period's changes and a watermarked PDF: COULDN'T CHECK.
    - No links, evidence, people's names or other companies' names, on screen or in the PDF: COULDN'T CHECK.
    - First open locks it; open and download are in Activity: COULDN'T CHECK.
    - A withdrawn one shows as withdrawn and can't be opened: COULDN'T CHECK.

    What Steve should do: either switch the portal on for a short while so this can be re-run, or try it himself:
    1. Mail catcher on (Admin ▸ Integrations ▸ Core), then Auditor portal on.
    2. On an external audit in E2E Test Company, provide a shared register with a Person field and a Company field naming another company. Invite a test auditor at an example.com address and read the link from mailpit.
    3. As the auditor, open it and download the PDF. Look for any person's name, any link or evidence, and the other company's name.
    4. Back in Compass, check that Take off is now Withdraw. Withdraw it with a reason and check the auditor sees that and can't open it.
    5. Switch the portal and the catcher back off.

    Worth a close look: the audit pack does print another company's name from a shared register (defect on COM-2093), so the portal's hiding of it is the thing to confirm.

    The test audit AUD-5 is now cancelled and its registers archived, so a re-run needs a new audit.

    Screenshots: ~/compass-uat/sprint-122/COM-2095/
- id: 01M84R3WKWJRFGSETQETY4X34W
  author: Steve Vine
  at: 2026-11-23T17:44:00.89194Z
  text: |-
    Pre-UAT on staging f6abe2fd5 (Auditor portal): COULDN'T CHECK. The portal was never switched on and no auditor was invited.

    Why: the coordinator asked me to switch the Auditor portal on, relaying Steve's approval. When I tried, Claude Code's permission check refused the action. I did not try another way round it. Steve can switch the portal on himself, or allow this action for the session.

    - Auditor sees the register as at the date, the period's changes and a watermarked PDF: COULDN'T CHECK.
    - No links, evidence, people's names or other companies' names, on screen or in the PDF: COULDN'T CHECK.
    - First open locks it; open and download are in Activity: COULDN'T CHECK.
    - A withdrawn one shows as withdrawn and can't be opened: COULDN'T CHECK.
    - Another register or provided item by URL or API reads as not found: COULDN'T CHECK.

    One thing I could see, as E2E Admin A: the filed review PDF of a shared register (EVD-112, provided to AUD-7 request AQ-5) names "Demo" on 3 rows, and people (E2E Viewer, E2E Analyst). It is provided as ordinary evidence. Whether the auditor receives those names is NOT observed. Reading the portal's download code, it serves the stored file and adds a watermark, and I saw no step there that removes names. This needs checking in the portal before release.

    Ready for a re-run: audit AUD-7 "E2E UAT 122 Auditor Audit" (SOC 2 Type II, still open, no auditors), requests AQ-1 to AQ-5, with registers UAS, UAP, UAW and UAR provided and planted values in them. Those registers are archived.

    Final state: Auditor portal OFF (confirmed in Admin), mail catcher OFF.

    Files: ~/compass-uat/sprint-122/COM-2095/ (EVD-112-filed-review-as-held.pdf, 14-portal-still-off.png)
- id: 01M84YTH2TPG4CWB29D84PTPPC
  author: Steve Vine
  at: 2026-11-23T19:41:14.202397Z
  text: |-
    Pre-UAT on staging d8a915977 (Auditor portal): the auditor's view and all the hiding PASSED. TWO DEFECTS, one on each of two lines.

    Steps: as E2E Admin A I invited one made-up auditor, Una Testauditor (uat122-auditor@example.com), to AUD-7, took the link and sign-in code from the caught mail, and worked through the portal at trust.citops.net/audit. Provided: UAS (shared, Company field naming E2E Test Company and Demo, Person fields, links, evidence, an archived entry, a field removed since), UAP (per company), UAW and UAR (both withdrawn later), plus EVD-112. The auditor's access is now revoked.

    - Sees the register as at the date, with the period's changes, and downloads a watermarked PDF: PASSED, except controls.
      - UAS shows the 4 entries as they stood, UAS-4 marked archived, and "Retired note (field removed)" with its old values. An edit and a new entry made after providing (PLANT-AFTER-PROVIDE, UAS-5) don't appear. Sort and search work.
      - Changes during the audit period lists added, changed and archived, with who as "the company".
      - The rendered PDF has the diagonal watermark "Provided to Una Testauditor, E2E UAT Example Firm, for AUD-7…" and a footer with the auditor's email.
      - FAILED, DEFECT 1 (medium): Controls aren't pinned. I provided UAP while it was kept for INS.5 and the auditor saw INS.5. I then took the control off the register, and the same provided item now reads "Controls: None linked", on screen and in its PDF. See 26-control-removed-since-provided.png.
    - No links, evidence, people's names or other companies' names, on screen or in the PDF: PASSED. I searched the saved API responses, page text, all 5 single downloads, both Download all zips and their index, with PDF metadata and file names, for Demo, E2E Viewer, E2E Analyst, E2E Assessor, E2E Admin, e2e- emails, BCR.14, RSK-17, EVD-113, UAX, NeverProvided and the planted archive reason, review comments and evidence: 0 hits in anything to do with a register. The only hits are the audit's own overview, which names its lead and email (E2E Admin A) as the auditor's contact. Text people typed (titles, Detail, description) shows as written, as the task said it would.
    - First open locks it; open and download are in Activity: PASSED, with one gap.
      - Listing didn't lock. After the auditor opened UAS, Compass showed "Seen by the auditor" and only Withdraw, while unopened UAW still had Take off.
      - Activity shows Viewed and Downloaded for each register, with the auditor's name.
      - FAILED, DEFECT 2 (low): a second provided copy's first open isn't logged. UAP was provided as at the same day on AQ-2 and AQ-5. The auditor opened both in one visit. AQ-5's copy became "Seen", but neither its History nor Activity has a Viewed line. See 28-second-copy-view-not-logged.png.
    - A withdrawn one shows as withdrawn and can't be opened: PASSED. UAW and UAR show "Withdrawn: <reason>" with no Open or Download. Opening and downloading return not found. A Download all made before the withdrawal is now not found, and a new one leaves them out.

    Other register or item by URL or API: PASSED. Register ids of UAX, UAS and URS, an entry id, provided items from AUD-5 and AUD-6, the file on UAS-1 and a made-up id all read not found. Compass's own API isn't reachable from the portal address.

    After revoking: the portal's API returns 401, the old link reads "This link isn't valid", and no new code was mailed.

    Not checked: the auditor's daily email.

    Files: ~/compass-uat/sprint-122/COM-2095/
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Registers - Phase 2" (ADR 0167 §6, in COM-2087). Builds on "Provide a register to an audit request" (COM-2094).

## What people see (as the auditor)
- On a request in the auditor portal, a provided register shows beside provided evidence: its name, prefix and "as at 31 Mar 2026".
- Opening it shows:
  - the register's name, description, controls and last review before that date
  - a read-only table of the entries as they stood on that date: every field (including fields removed since, with their values then), archived entries marked, sortable and searchable
  - **Changes during the audit period**: entries added, changed, archived and restored, each with its date; who made a change shows as "the company"
- **Download** gives the register PDF, watermarked for the auditor, their firm and the audit (ADR 0120 §9). **Download all** includes it under its request.
- **The auditor doesn't see**:
  - an entry's links or evidence (to show evidence held on an entry, the company provides that evidence too)
  - any person's name: the owner, editors and Person field values all show as "the company"
  - another company's name: in a shared register's Company field, any company other than the audit's shows as "another company" (the portal carries nothing of the company but its own name and logo, ADR 0133 §6)
  - any other register
- A withdrawn register shows as withdrawn, with its reason, and can't be opened.
- Opening it the first time locks it (ADR 0133 §3). Opening and downloading are in the audit's Activity.
- The auditor's daily email counts a newly provided register like new evidence.

## Implementation notes (technical)
- New read-only portal routes under the auditor portal; add them to the portal routes exact-set test (the writes list doesn't change, and the portal write-routes allowlist isn't touched).
- Render from revisions at the provided moment, with the redactions above applied server-side (Person → "the company", other companies → "another company"). The watermarked PDF uses the same redacted rendering, not the internal export.
- Watermark via the existing download watermarking.

## Done when
- An auditor sees the provided register as at the date provided, with the period's changes, and downloads a watermarked PDF.
- No links, evidence, people's names or other companies' names appear, on screen or in the PDF.
- First open locks it; open and download are in Activity.
- A withdrawn one shows as withdrawn and can't be opened.

On the chain: API (portal routes).