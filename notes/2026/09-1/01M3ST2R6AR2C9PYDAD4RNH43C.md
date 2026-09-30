---
id: 01M3ST2R6AR2C9PYDAD4RNH43C
created: 2026-09-30T18:43:54.698167Z
updated: 2026-09-30T23:17:13.507485Z
type: task
title: Vendor Management's lists, redesigned — quick filters with Needs attention, the register's new rows, and tabs that fold into More
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 805
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
comments:
- id: 01M3T9Q4GQFTQTGCFM1TQV41E7
  author: Steve Vine
  at: 2026-09-30T23:17:11.318872Z
  text: |-
    Done: PR #813, merged to main (817f9bf).

    What you'll see in Vendor Management:
    - **The header** is "Vendor Management", with New vendor on every tab.
    - **Tabs.** Register and Requests show counts, and tabs that don't fit fold into More.
    - **Chips on the Register:** All, **Needs attention**, Critical risk, High risk and Requested. Each count matches exactly what the chip shows, and the chosen chip is kept in the address.
    - **Needs attention** is any vendor that:
      - isn't Compliant;
      - is waiting for approval;
      - has a certificate expired or close to expiring;
      - or is overdue for review.
    - **Filters:** search, State, Compliance, Criticality and Risk tier, with Access and Flag behind "More filters". The dashboard's vendor links still land on the right filters.
    - **Rows:**
      - the vendor's initials, name and website;
      - State as a dot;
      - Compliance as a pill;
      - Risk tier with the engagement it comes from;
      - Criticality as bars;
      - Certified (name, plus "Expiring soon" / "Expired" when it applies);
      - Flags and Owner.
    - **The other tabs** are in the new layout and work as before.

    Decisions to check:
    - **"Expiring soon" now starts 6 weeks before a certificate lapses**, everywhere. The register used to say a month and the vendor page 6 weeks; they now agree. On the vendor page, red now means actually expired, and "within 2 weeks" is amber.
    - **Offboarded vendors never show under Needs attention.** Dormant vendors show only for compliance, not for dates, which matches how reminders already work.

    All checks passed, including new backend tests for each Needs attention rule.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The prototype's Vendors screen, plus Vendor Management's other tabs in the same layout.

## What people see

- **Header:** "Vendor Management" (the menu's name, as today), with **New vendor** on the right.
- **Tabs:** Register (count), Requests (count), Assessments, Assessment rules, Compliance rules, Approval rules and Portal.
  - Who sees which tab is unchanged: the rules and Portal tabs are for vendor editors.
  - Tabs that don't fit fold into **More**.
- **Quick-filter chips on the Register**, each with its count:
  - All;
  - **Needs attention**;
  - Critical risk;
  - High risk;
  - Requested.
- **Needs attention** (Steve, 2026-09-30) is any vendor where any of these is true:
  - compliance isn't Compliant (Under review, Non-compliant or Not assessed);
  - it is waiting for approval (Requested);
  - a certification has expired or is close to expiring;
  - its review is overdue.
- **Filter bar:** search vendors, then State, Compliance, Criticality and Risk tier. **Access** and **Flag** sit behind a "More filters" button, and on narrow screens more filters move there.
- **Register rows:**
  - a tile with the vendor's initials, its name and website;
  - State as a dot and label;
  - Compliance as a pill;
  - Risk tier as a pill with "from Cloud Hosting" (the engagement it comes from) under it;
  - Criticality as bars with a label;
  - Certified (a seal and the certification's name, or —);
  - Flags;
  - Owner (avatar and name).
  - Narrow screens show Vendor, State, Compliance and Risk tier.
  - "No vendors match these filters." when empty.
- **Requests, Assessments and the three rules tabs, and Portal** are in the kit's list and filter layout. What they do is unchanged.

## Notes (technical)

- **Needs attention is decided by the server.** Add `needs_attention=true` to the vendor list filter and a `needs_attention` count in the list meta, so the chip and the filter can't disagree. The expiry and overdue rules must be the ones the app already uses:
  - **Certification close to expiring:** reuse the proximity threshold the certification pill already colours by (`vendors/detail/cards.tsx` ~1548–1592). Move it to one shared constant, used by both server and client.
  - **Review overdue:** the vendor's review cadence says a review is due. Note that `under_review` already covers a cadence-expired judgement (`models/vendor.py` docstring). Include whichever due-date computation the vendor's Assessments tab uses ("next due to be assessed") so a vendor due but not yet flipped still counts.
- **Chip counts.** One counts query per chip or a single aggregate, not N list fetches.
- **Page.** `pages/VendorsPage.tsx` on the kit's tabs, chips, filter bar and grouped list. Filters stay in the URL (COM-792).
- **Ratchet.** Empty the pages' entries from the page-header ratchet.
- **Tests:**
  - integration tests for `needs_attention`, one per rule and one for a vendor that meets none;
  - vitest for the chips, the columns and More filters.

**Done when:** on staging, the Register's chips show counts that match the list they give, Needs attention finds a vendor under each of the four rules, and every Vendor Management tab is in the new layout.