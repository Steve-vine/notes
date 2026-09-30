---
id: 01M3ST1F3ESST3M1MYYREH38Y0
created: 2026-09-30T18:43:12.622993Z
updated: 2026-09-30T22:13:50.496944Z
type: task
title: The control library, redesigned — tier counts, frameworks and linked content on every row, each domain's policy, and Export
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 802
sprint: s0zzctz
blocked_by:
- 01M3ST04QGV1F3BH3F9J4XDZXK
comments:
- id: 01M3T628VP16VVDCCMDGY1ZAMQ
  author: Steve Vine
  at: 2026-09-30T22:13:21.910003Z
  text: |-
    Done: PR #811, merged to main (6ab2657).

    What you'll see on Controls:
    - **Four cards along the top:**
      - All controls (with "n domains · m frameworks");
      - Essential ("Do these first");
      - Expected ("Most organisations");
      - Specialised ("Where it applies").

      Each has its count. Clicking a card shows only that tier; click it again, or All, to clear it. The counts always match what the card shows.
    - **A filter bar:** search, then Domain and Framework. On the right, how many are shown and, for authors, Show disabled.
    - **Grouped by domain,** with the domain's policy as a link on the right of its heading ("+n" when it has several).
    - **Two new columns:** the frameworks each control is mapped to (short names like ISO 27001, SOC 2 or CIS, up to three then "+n") and how many documents are linked. Status is now a dot, and disabled controls are faded.
    - **Export** (CSV or Excel) downloads exactly the list on screen, with its filters. The columns are ref, previous ref, title, domain, tier, status, frameworks with their requirement refs, and linked documents. Anyone who can see Controls can export.

    Two things decided while building:
    - Short framework names are worked out from the full names (ISO/IEC becomes ISO, NIST Cybersecurity Framework becomes NIST CSF, CIS versions merge), so nothing new is stored.
    - Frameworks you've disabled don't appear in the list's tags or the export.

    All checks passed, including new backend tests for the export and its filters.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Part of sprint 65, UI Upgrade (ADR in COM-794). The prototype's Controls screen, built from the screen kit.

## What people see

- **Header:** "Controls", with **Export** and, for authors, **New control** on the right.
- **Four summary cards:**
  - **All controls** (with "n domains · m frameworks");
  - **Essential** ("Do these first");
  - **Expected** ("Most organisations");
  - **Specialised** ("Where it applies").
  - Each shows its count. Clicking a card filters the list to that tier, ringed in violet.
- **Filter bar:** search by ref or text, then Domain and Framework. On the right, "n shown" and, for authors, **Show disabled**.
- **Grouped by domain.** Each domain's heading shows its policy on the right ("Policy · Information Security Policy") as a link. With more than one policy it shows the first and "+n".
- **Columns:**
  - Ref;
  - Control;
  - Tier;
  - **Frameworks**: short names such as ISO 27001, SOC 2 or PCI DSS, up to three plus "+n";
  - **Content**: how many documents are linked;
  - Status (Active or Disabled; disabled rows are faded).
  - Narrow screens drop Frameworks and Content.
- **Export** downloads the controls currently shown, respecting the tier, filters and search, as **CSV or Excel**. The columns are:
  - ref and previous ref;
  - title;
  - domain;
  - tier;
  - status;
  - each framework with its requirement refs;
  - linked document titles.
- **Who can export:** anyone who can see the Controls page.

## Notes (technical)

- **List payload.** `CoreControlOut` has no framework or content summary today (`schemas.py` ~449). Add `framework_short_names: list[str]` and `content_count: int` to the list payload, loaded in one query (`selectinload`), not per row. Add a framework short name if frameworks lack one (the prototype uses ISO 27001 / ISO 42001).
- **Tier counts.** Count from the list the page already has. No new endpoint.
- **Domain policy.** The domain list payload gains its policy documents (`content_items` of type policy with `domain_id`, as the domain page already lists them). Don't assume a domain has exactly one policy: the domain page was changed to show all of a domain's documents, and the heading must cope with none or several.
- **Export.** `GET /api/v1/controls/export?format=csv|xlsx` takes the same filter params as the list. Reuse the SoA writer (`api/v1/soa.py` ~267) for the XLSX mechanics. Gate it as the list is gated.
  - The route docstring is OpenAPI contract, so regenerate `schema.d.ts` ([[route-docstring-is-openapi-contract]]).
- **Page.** `pages/ControlsPage.tsx` on the kit. Empty its entry from the page-header ratchet.
- **Tests:**
  - integration tests for the export: filters respected, both formats, gate;
  - integration test for the list payload's new fields;
  - vitest for the tier cards as a filter, and the columns.

**Done when:** on staging, the Controls page shows the tier cards, frameworks and content per row, and each domain's policy. Export gives the filtered library as CSV and as Excel.