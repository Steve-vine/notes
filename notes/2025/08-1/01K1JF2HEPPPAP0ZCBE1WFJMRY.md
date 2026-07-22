---
id: 01K1JF2HEPPPAP0ZCBE1WFJMRY
created: 2025-08-01T09:23:10.422326326Z
updated: 2025-08-01T09:47:19.290769696Z
type: memo
title: DevOps Standup - Kora issue during deployment
imported_from: Obsidian
---
01-08-2025 10:23

Tags: 


---
### List of Changes

- Operator Service
    - Ingress
    - Certs
    - Service
    - Beta path
    - Rollouts configured
    - Secrets
- File storage system for images
- NGINX Version upgrade
- Route53 VPC Association
- Argo Rollouts for OpenRita API
- Beta paths for OpenRita API
- Datadog Patch

### What Went Wrong

During the deployment an unexpected change in the Crossplane composition case the RDS database to be removed.  This was restored from the last snapshot at 16:37 (BST)
### Impact
The following call data was lost from the Database

The times are in UTC

| Time                | Client                             |
|---------------------|-------------------------------------|
| 31/07/2025 15:37:31 | NoiseAir Limited                    |
| 31/07/2025 15:40:03 | Higgs Newton Kenyon Solicitors      |
| 31/07/2025 15:40:34 | L A Simpson Chartered Surveyors     |
| 31/07/2025 15:41:44 | L A Simpson Chartered Surveyors     |
| 31/07/2025 15:44:16 | Qualia Law CIC                      |
| 31/07/2025 15:46:23 | Higgs Newton Kenyon Solicitors      |
| 31/07/2025 15:49:39 | Qualia Law CIC                      |
| 31/07/2025 15:53:12 | Unique Property Company             |



---
## References