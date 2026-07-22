---
id: 01KK1RK4XEKDRVE6MKFH7PKV28
created: 2026-03-06T14:24:59.310442827Z
updated: 2026-04-13T11:08:50.559130955Z
type: memo
title: New AWS Environments
imported_from: Obsidian
---
06-03-2026 14:24

Tags: 


---
## ToDo
- [x] Karpenter doesn't have maximum pod count of 110
- [x] Create an internal ingress instance of Kong
- [ ] Clean up 1Password entries
- [x] Rename Sandbox Twingate secret to sandbox-twingate-connectors
- [x] Install DD Agent on mgnt and env (staging/production) instances
- [x] Remove commented out lines from XR's

## Documentation
- [ ] Kong API
- [ ] Traefik
- [ ] What else needs documenting

## Rollout
- [x] Tear down exiting environments 
- [x] Commit repo
- [x] Standardise Repo creds
- [x] Create Staging bstr
- [x] Deploy bstr-sandbox changes (twingate secret)
- [x] Standardise Twingate connectors instance
- [x] Deploy Sandbox stack
- [x] Deploy Production stack
- [x] Deploy Staging mgnt
- [x] backup bstr-staging
- [x] backup bstr-production
- [x] Rename all contexts
- [x] Ensure Datadog is running on all clusters
- [x] Check consistency of instance types used
- [ ] Claude review