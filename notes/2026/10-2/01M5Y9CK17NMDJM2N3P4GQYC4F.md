---
id: 01M5Y9CK17NMDJM2N3P4GQYC4F
created: 2026-10-27T08:59:47.111263Z
updated: 2026-10-27T09:01:50.929177Z
type: task
title: The Microsoft tile — Entra, Exchange, SharePoint and sign-in move in from Admin, each a feature that can be switched on or off
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1350
sprint: s8fmesf
assignee: steve
label:
- feature
priority: medium
task_status: todo
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