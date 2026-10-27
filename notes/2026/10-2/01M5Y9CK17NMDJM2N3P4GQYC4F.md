---
id: 01M5Y9CK17NMDJM2N3P4GQYC4F
created: 2026-10-27T08:59:47.111263Z
updated: 2026-10-27T12:13:12.917433Z
type: task
title: The Microsoft tile — Entra, Exchange, SharePoint and sign-in move in from Admin, each a feature that can be switched on or off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1350
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
comments:
- id: 01M5YMEP16Y41KE2FY4CSXWT7W
  author: Steve Vine
  at: 2026-10-27T12:13:10.054629Z
  text: |-
    Done — PR #1367, merged to main.

    What's there:
    - Microsoft ▸ Configure holds the cards from Admin ▸ Integrations, unchanged: directory setup, Entra ID, Exchange Online, SharePoint and sign-in, with the "Not used in AD only" notes. Each company's servers list also shows here, for Inventory admins (moved in COM-1351).
    - Overview: what Compass reads and changes, and the grants it needs: the Entra app, Exchange Administrator (ADR 0107), the SharePoint app and the optional Entra permissions (ADR 0096).
    - Features:
      - Directory for Access Control: off stops the mirror and the sign-in and auth-method sweeps. Every directory change waits rather than failing. Approved requests, access-review removals and due deletions show "Waiting: Directory for Access Control is switched off on the Microsoft integration. This runs once it is switched back on." The five-minute sweep runs them once it's back on, and nothing is lost.
      - Exchange: off stops the shared-mailbox and list-sender syncs.
      - SharePoint documents: publishing and reading are refused with a sentence. The SharePoint card's Test still works.
      - Sign in with Microsoft: this is sign-in's own "enabled", with no second store. Switching off asks first and names how many people sign in only with Microsoft.
      - Servers and devices for Inventory: each company's servers read is skipped, and Read now answers with the sentence. Nothing already found is marked gone.
    - Status: Entra and Exchange health with last-checked time, and when the Exchange certificate expires. The certificate also turns the tile to Needs attention 30 days out.

    My calls (overturn any):
    - While Exchange is switched off and Exchange is set up, every directory change waits, not just the Exchange part. Nearly any request can touch a mailbox or a list, and half-applying one is worse than waiting.
    - Either half of the servers list (Entra or AD) switched off stops the whole company read. Reading one half alone would mark the other half's servers as gone.
    - Send email through Microsoft 365 isn't on this tile yet; it arrives with the other ways of sending in COM-1355.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349.

## What people see

- **Category:** Identity & directory.
- **Overview:**
  - the app registrations Compass uses and what each is for;
  - the Graph permissions and Exchange role each needs. The Exchange role is **Exchange Administrator** (ADR 0107, which superseded 0078's Recipient Administrator);
  - the optional Entra permissions (ADR 0096).
- **Configure**, the cards from today's Admin ▸ Integrations, unchanged in what they hold:
  - Directory setup (cloud only / hybrid / AD only). The same setting shows on the Active Directory tile and can be changed from either;
  - Entra ID: tenant, app, secret, Test;
  - Exchange Online: app, certificate and its expiry, Test;
  - SharePoint: app, secret, site access grant;
  - Sign-in: the sign-in app and the group-to-role mappings.
- **Features:**
  - **Directory for Access Control**: read people, groups, devices, directory roles and Conditional Access, and make the changes access requests approve;
  - **Exchange**: lists, list senders and shared mailboxes;
  - **SharePoint documents**: publish and read content versions on SharePoint;
  - **Sign in with Microsoft**;
  - **Servers and devices for Inventory**: read from Entra ID. This is the same per-company directory-servers list as on the Active Directory tile (COM-1351), shown on both;
  - **Send email through Microsoft 365**: shown here, chosen with the other ways of sending in COM-1355.
- **Status:**
  - health for Entra and Exchange, from the existing checks;
  - the Exchange certificate's expiry, which turns the tile to Needs attention 30 days before.

## Rules

- Switching off **Sign in with Microsoft** asks first and says who would no longer be able to sign in. It does what turning sign-in off does today.
- Switching off **Directory for Access Control** stops the sync and every directory change. Requests waiting to run say "Microsoft integration is switched off" instead of failing.

## Notes (technical)

- Move the cards out of `admin/IntegrationsSection.tsx` and `admin/DirectoryIntegrations.tsx` into the tile. Endpoints and permissions are unchanged (`require_manage_integrations`).
- Gate the Entra, Exchange, SharePoint and SSO Beat jobs on their feature switches.

**Chain:** on the chain (API: feature gating).

**Done when:**
- everything on today's Admin ▸ Integrations for Microsoft is set up from the tile;
- each feature switch stops its own work and nothing else.