---
id: 01KJCGPHEET2EAN43MW0037GQ5
created: 2026-02-26T08:22:58.766868054Z
updated: 2026-03-08T11:27:43.000648374Z
type: memo
title: OAuth2-Proxy  Kong JWT
aliases:
- OAuth2-Proxy / Kong JWT
imported_from: Obsidian
---
26-02-2026 08:22

Tags: 


---
### To Do
- [x] How do I prevent any authenticated user in Auth0 from logging in?
- [x] Do I really need the error handling pod?
- [x] How is this JWT?
- [x] How do I specify cookie duration?
- [x] How do I log out?
- [x] Does it support MFA?
- [x] Can I view user properties in the app (Name, email, permissions groups)
- [x] Kong plugins are namespaced, consider changing to kind: KongClusterPlugin
- [x] Kong plugins are defined as part of the ingress chain.  Consider adding these into Crossplane
- [x] Need to get the publickeysync to work with standard admin image
- [x] Kong API internal Ingress needs external-DNS annotation
- [x] Test all scenarios for ingress
- [x] Deploy Kong and Traefik to Bootstrap/Sandbox/Staging/Prod 
- [x] Deploy oauth2-proxy to Bootstrap/Sandbox/Staging/Prod 
- [x] Remove Ingress Nginx from Bootstrap/Sandbox/Staging/Prod 

## Checklist

- [x] Is Datadog running on all nodegroups and nodepools
### Bootstrap
- [x] All composites ready
- [x] All pods running
- [x] All Twingate connectors running

### Mgnt Sandbox
- [x] All composites ready
- [x] All pods running
- [x] All Twingate connectors running

### Mgnt Staging
- [x] All composites ready
- [x] All pods running
- [x] All Twingate connectors running
- [x] Argo Workflows working
- [x] Argo CD Working
- [x] Argo Rollouts Working
- [x] Kong running

### Mgnt Production
- [x] All composites ready
- [x] All pods running
- [x] All Twingate connectors running
- [x] Argo Workflows working
- [x] Argo CD Working
- [x] Argo Rollouts Working
- [x] Kong running

### Env Staging
- [x] All composites ready
- [x] All pods running
- [x] All Twingate connectors running
- [x] Argo Workflows working
- [x] Argo CD Working
- [x] Argo Rollouts Working
- [x] Kong running

### Env Production
- [x] All composites ready
- [x] All pods running
- [x] All Twingate connectors running
- [x] Argo Workflows working
- [x] Argo CD Working
- [x] Argo Rollouts Working
- [x] Kong running