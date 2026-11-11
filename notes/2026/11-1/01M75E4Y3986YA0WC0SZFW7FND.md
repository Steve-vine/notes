---
id: 01M75E4Y3986YA0WC0SZFW7FND
created: 2026-11-11T13:53:22.025295Z
updated: 2026-11-11T18:42:30.463622Z
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
assignee: steve
label: null
priority: medium
task_status: review
---
Where the company is defined in Admin->Companies, it should also be possible to define the scope of the company. E.g.
Physical locations
Hosting providers
Applications 
Etc.
This should then be able to feed into audits and give an auditor the scope of what is up for auditing.

This allows a business entity to be split into different 'Companies' for auditing purposes, E.g. Moneypenny UK vs Moneypenny US to limit the scope of a HIPPA audit.