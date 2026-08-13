---
id: 01KZX0K0T1QKY61A2NSDCJQFC8
created: 2026-08-13T07:32:35.265545Z
updated: 2026-08-13T08:21:11.155373Z
type: memo
title: External sharing in SharePoint and guest users
tech:
- SharePoint
- EntraID
---
### Rules
- Restrict invitations to authorised members, guests can’t invite guests
- Domain allow/block lists
- Require MFA always - And scope it to passkeys
- Set guest user access restrictions to the most restrictive level ("Guest user access is restricted to properties and memberships of their own directory objects”)
- Guest access review / Inactivity cleanup / remove unredeemed invitations

- Only IT can add guests, users can’t share externally
- Only authorised users can share with guests
- Require MFA every 8 hours - And scope it to passkeys only
- Set guest user access restrictions to the most restrictive level ("Guest user access is restricted to properties and memberships of their own directory objects”)
- Guest access review / Inactivity cleanup / remove unredeemed invitations
