---
id: 01M3ST3AH883Z3NE221TYQ7FSA
created: 2026-09-30T18:44:13.48083Z
updated: 2026-09-30T18:44:13.48083Z
type: task
title: A vendor's page, redesigned — the facts at a glance, the rule it breaks with a button to fix it, and the side cards
priority: medium
assignee: steve
label: feature
task_status: backlog
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 806
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The prototype's vendor page, built on the kit's detail layout.

## What people see

- **Header:**
  - an icon tile, the vendor's name;
  - under it, the website link, "Owned by …" with the owner's avatar, and what the vendor provides;
  - **Edit**, **Start review** and **⋯** for the rest of today's actions. Who sees each action is as today.
- **Six fact cards:**
  - **State** (and since when);
  - **Compliance** ("1 rule not met" when that's so);
  - **Risk tier** ("From Cloud Hosting");
  - **Criticality** ("Derived from engagements");
  - **Annual spend** (and how many engagements);
  - **Certification** ("Valid to 28 Jan 2027").
- **A banner for each compliance rule the vendor doesn't meet**, in red.
  - It gives the rule in plain words: "A data processing agreement should be in place — none is recorded."
  - A button fixes it: **Record DPA** opens the assurance profile for editing with that field ready.
  - Everyone who can see the vendor sees the banner. Only vendor editors get the button.
- **Tabs:** **Overview** (today's "Details"; old links still work), **Assessments**, **Reviews** and **History**.
- **Overview, main column:**
  - **Engagements.** Each is a panel: its name, state and risk pill, what it's for, annual cost, data residency, access requirements, sub-processors, the data it holds with each type's classification, and the contracting entities. It has **Edit**, and there's **Add engagement**.
  - **Assurance profile**, with "**4 of 15 recorded**" and a small bar.
    - Fields are grouped under *Contractual position*, *Resilience & compliance* and *Exit & commercial standing*.
    - A field a rule requires but that's missing is outlined in red with "Not recorded — required".
    - **Edit** turns the fields into inputs in place, with **Save profile** and **Cancel**.
  - **Certifications**, each with issuer and validity, and **Add**.
- **Overview, side column:**
  - **Lifecycle:** Requested → Active → Dormant → Offboarded, with the current state lit. **Mark dormant** and **Offboard…** work as today, with one line explaining what dormant does.
  - **Contacts:** each with role and email, and a "Compliance" mark on the one who receives questionnaires. **Add**.
  - **Ownership:** owner, other owners, review cadence.
  - **Flags:** with Manage.
  - **Linked risks:** with Link and Raise.
- **Assessments, Reviews and History tabs** are in the kit's layout. What they show is unchanged.

## Notes (technical)

- **Where.** `pages/VendorDetailPage.tsx` and `vendors/detail/cards.tsx` on the kit. The cards keep their data and permissions: `LifecycleCard`, `FlagsCard`, risks, certifications, contacts.
- **Tab rename.** Details becomes Overview. `useTabParam` maps the old `details` value to `overview`, so bookmarks and trails keep working.
- **Banner.** `vendors/ComplianceViolations.tsx` today lists the rules for editors only (Assurance card and beside the review form).
  - Show it to every reader.
  - Give each rule a fix target: the assurance field it concerns, or engagement data for engagement rules. Rules with no single field get **Review** instead of a fix button.
- **x of y.** Count the non-Unknown, non-empty assurance fields (`models/vendor.py` ~177–193) over the total. Computing it in the client is fine.
- **In-place edit.** `vendors/AssuranceCard.tsx` keeps its validation. Focus the field when opened from a banner.
- **Ratchet.** Empty the page's entry from the page-header ratchet.
- **Tests:**
  - the banner shown to a reader without the button, and to an editor with it;
  - the fix button opening edit on the field;
  - x of y;
  - the `details` → `overview` redirect.

**Done when:** on staging, the AWS vendor reads as the prototype. Its DPA banner's **Record DPA** takes an editor straight to the field, and a reader sees the banner without the button.