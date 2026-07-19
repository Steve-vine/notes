---
id: 01JYY5SXW49JERGRPXKMEAB9ND
created: 2025-06-29T15:44:58.756Z
updated: 2025-06-29T17:02:11.555Z
type: memo
title: vCluster Config - vcluster.yaml
---
29-06-2025 16:44

Tags: #vcluster 


---
- [x] ingress-nginx
- [x] External-DNS
- [x] External-Secrets
- [x] Cert-Manager
- [ ] Datadog-Agent
- [ ] Argo-CD
- [ ] Argo-Rollouts
- [ ] Twingate

- [ ] AWS Assume Access
- [ ] 

Base config
```
controlPlane:
  coredns:
    embedded: true

sync:
  fromHost:
    ingressClasses:
      enabled: true

    
  toHost:
    ingresses:
      enabled: true

integrations:
  certManager:
    enabled: true
  externalSecrets:
    enabled: true
    sync:
      externalSecrets:
        enabled: true
      stores:
        enabled: true
      clusterStores:
        enabled: true
```

#### External-Secrets
v0.17.0 Stops serving `v1beta1` apis. You need to update your manifests from `v1beta1` to `v1` prior to updating from `v0.16` to `v0.17`

The external-secrets extension is specifically looking for the v1beta1 API and fails on versions greater than v0.16.2

---
## References