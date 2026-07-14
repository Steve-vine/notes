---
id: 01KWVDQDJSAS0CCGYZN9TCJYRT
created: 2026-07-06T09:56:36.569968Z
updated: 2026-07-14T09:50:36.656154Z
type: task
title: 'Solution: Run certain apps as Admin'
priority: medium
task_status: active
order: 4.0
assignee: neil
---
Find a way to run certain apps as an administrator on workstations.
Issues flagged:
- Diskpart
- Docker
- Visual Studio Installer

Needs to work on Windows.
Needs to ensure that the user can’t run other tools (Outlook, browser) as Admin
Must not allow the user to install software

Suggested solutions:
Scripts - 
- Use SCEPman to sign scripts
- Unsigned scripts - Authorised users / Sandbox only
- Signed scripts - Authorised users
- Signed scripts as Admin - Authorised users
Apps - 
- Use Intune - Endpoint Privilege Management.
- Use filename and publisher certificate