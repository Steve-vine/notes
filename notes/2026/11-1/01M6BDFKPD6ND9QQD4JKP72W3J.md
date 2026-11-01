---
id: 01M6BDFKPD6ND9QQD4JKP72W3J
created: 2026-11-01T11:21:28.013272Z
updated: 2026-11-01T11:21:32.355086Z
type: task
title: A vendor request no approval area picks up waits for a fallback approver instead of being approved on submission
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1507
sprint: s53765q
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Sprint 101, Roles and Permissions. Raised by Steve on 1 Nov 2026 (option b).

## What happens today

Steve gave a test account only Vendor Contact, asked for a new vendor (AWS, Test Company) from the user portal, and the vendor and its engagement went straight to **Active**. That's by design (ADR 0040 §5):
- Approval comes from a company's approval areas. Each area's rules say which requests it must approve.
- A request that **no area's rules pick up** needs nobody's approval, and is recorded as "Approved on submission".
- For a new vendor there's no owner sign-off either, because the requester becomes the owner.

Staging has no approval areas in any company, so every request there is approved on submission. In production, the same happens to any request the rules miss. Nothing on screen says so.

## Behaviour

- **Fallback approver, per company.** On Vendors ▸ Approval areas, a company sets who decides a request that no area picks up:
  - **The vendor register's managers** (the default);
  - **a named person**;
  - **a Compass role**.
- **Or approve automatically.** A company can choose "Approve automatically when no approval area applies", which is today's behaviour. It's off unless a company switches it on, and the setting says plainly what it does.
- **Existing companies** start with the default fallback (the register's managers), so after release nothing is approved on submission unless a company chooses it (assumption, stated for Steve). Requests already decided or pending are unchanged.
- The fallback applies to everything that goes through approval areas today: a new vendor, a new engagement, an amendment.
- A request waiting on the fallback appears in Actions as "Decide a vendor request" for the fallback approvers, emailed as area approvals are. It shows on the request as "Waiting on: fallback approver (who)".
- **Nobody decides their own request.** If the requester is the only fallback approver, it goes to the register's managers instead, and an admin can always decide.
- The record says which way it went: "Approved by [name] as fallback approver", or "Approved automatically: no approval area applies (company setting)". The vendor's history and the activity log show the same.
- Polaris deciding requests works the same way for fallback approvals.
- The Approval areas tab warns when a company has no areas and automatic approval is on.

**Chain:** on the chain (a migration for the per-company setting and the fallback approval, plus API changes).

**Done when:**
- With no area matching, a request waits for the fallback approver and doesn't go Active until decided.
- Each fallback choice (register managers, a person, a role) routes the request to the right people, and the requester can't decide it.
- With "approve automatically" on, a request no area picks up is approved on submission and recorded as such.
- Existing companies default to the fallback, and nothing already decided changes.
- Pre-UAT in E2E Test Company, with the mail catcher on: as a Vendor Contact test account, ask for a new vendor. Check it waits, appears in a fallback approver's Actions, and the requester can't decide it. Then reject it as E2E Admin A, so no new active vendor is left behind.