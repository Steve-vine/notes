---
id: 01M75E4Y3986YA0WC0SZFW7FND
created: 2026-11-11T13:53:22.025295Z
updated: 2026-11-14T17:05:12.956152Z
type: task
title: Company scope
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1730
comments:
- id: 01M75YP9PYNMVKMJ5KA8TN3XRJ
  author: Steve Vine
  at: 2026-11-11T18:42:28.190105Z
  text: |-
    Done. PR #1733 (one migration, additions only; ADR 0151).

    What you see:
    - **Admin ▸ Companies:** a company's name opens its own page. Alongside the existing details form, it has the company's **scope**:
      - **Scope statement:** what's in scope, what's out of scope, and notes.
      - **Locations:** typed in, with name, kind (office, data centre, server room, other), address and notes.
      - **Hosting and service providers:** picked from the company's Vendor register, each with what it provides.
      - **Systems and applications:** picked from the company's Inventory, showing their hosting detail, e.g. "WRX Server Room 1".
      - **Audited against:** frameworks.
      Whoever can manage companies edits it. An offboarded vendor or decommissioned asset stays in the scope with a warning.
    - **Audit ▸ Overview:** a "Company scope" card. While the audit is open it shows the live scope, with a link to edit it. When the audit closes or is cancelled, the scope at that moment is kept and shown, dated.
    - **Audit packs:** a "System boundary" section and a `system-boundary.md` file, as at the day the pack was made. A company with no scope says "has not declared its scope", never an empty boundary.
    - **Closing summary and auditor portal:** both show the system boundary. Internal warnings never reach auditors or packs.
    - **Polaris:** a read-only `audit_get_scope` tool, for a company's scope now or on a named audit.

    Calls I made (all in ADR 0151):
    1. **One scope per company**, not per audit. The company is the audit boundary, which is how Moneypenny UK and Moneypenny US are split.
    2. **When the copy is kept:** at audit close or cancel, not at the start, because the boundary is often agreed during fieldwork.
    3. **Who can read it:** people who manage companies or can view audits, because it names suppliers and systems.
    4. **Locations are typed in:** Compass has no register of sites.

    Suggested next, not built:
    - data assets and people in scope;
    - suggesting systems from a location's Inventory hosting detail;
    - narrowing scope for one audit;
    - showing scope on the Trust Centre;
    - editing scope through Polaris.

    Checks:
    - backend: ruff and mypy clean; unit suite 2,186; scope, company, audit, pack and portal integration tests pass (66);
    - frontend: eslint, tsc and prettier clean; new tests pass; 3 unrelated files flaked under load and passed alone.
- id: 01M76B35Z1SS0F2F19AXF24XSK
  author: Steve Vine
  at: 2026-11-11T22:19:13.249181Z
  text: |-
    Failed: one small defect; everything else I checked works (Claude's pre-UAT pass, staging fcaf1d13, as E2E Admin A in E2E Test Company).

    **Defect: cancelling an audit doesn't refresh its scope card.**
    - Steps: create an audit, then Cancel audit and give a reason.
    - Seen: the header changes to "Cancelled", but the Company scope card still reads "The company's scope as it stands — kept with the audit when it closes", with the "Edit on Admin ▸ Companies" link.
    - After a page reload it correctly reads "As it stood when the audit ended, 11 Nov 2026", with no edit link.
    - Expected: the kept, dated scope straight after cancelling, as after a reload.
    - Reproduced twice (AUD-2, AUD-3). It's the same kind of fault as COM-1731. Closing an audit probably behaves the same; I didn't try it.
    - Screenshot: ~/compass-uat/sprint0-2026-11-11/COM-1730/DEFECT-cancelled-audit-scope-card-not-refreshed.png

    **Passed:**
    - **Admin ▸ Companies:** each company's name links to its page. On E2E Test Company's page I filled in:
      - the scope statement: in scope, out of scope and notes;
      - a location (E2E Test Server Room, Server room, with an address);
      - a provider picked from the company's Vendor register (E2E Test Vendor, "Hosting, E2E test region");
      - a system picked from Inventory (AST-37);
      - Audited against: SOC 2.
    - **Audit ▸ Overview:** an open audit (AUD-1) shows a "Company scope" card with all of the above and an edit link.
    - **Audit pack:** I made a pack (CIS v8.1, PDF and zip).
      - The zip holds system-boundary.md, "The scope of E2E Test Company as at 11 November 2026", with every part of the scope.
      - The PDF has a "System boundary" section with the same content.
    - **The kept copy stays put:** after AUD-2 was cancelled, I changed the company's notes. AUD-2 still shows the old note.

    Couldn't check:
    - **The auditor portal and closing summary:** there's no auditor test account, and I didn't close an audit.
    - **Polaris's audit_get_scope:** needs the AI provider.
    - **The offboarded-vendor and decommissioned-asset warnings:** not tried.

    Screenshots and the pack: ~/compass-uat/sprint0-2026-11-11/COM-1730/
assignee: steve
label: null
priority: medium
task_status: done
---
Where the company is defined in Admin->Companies, it should also be possible to define the scope of the company. E.g.
Physical locations
Hosting providers
Applications 
Etc.
This should then be able to feed into audits and give an auditor the scope of what is up for auditing.

This allows a business entity to be split into different 'Companies' for auditing purposes, E.g. Moneypenny UK vs Moneypenny US to limit the scope of a HIPPA audit.