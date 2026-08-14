---
id: 01M00434SQ0PZ1T00AZANHRD0G
created: 2026-08-14T12:31:32.663149Z
updated: 2026-08-14T13:15:50.016307Z
type: task
title: Playbook example
project: 01KX671DATY39VW6GWK3M2T3DN
number: 709
sprint: sevhjex
assignee: steve
label: null
priority: medium
task_status: done
tech: null
---
Name
Karpenter node recycling.

Signal Type
Node is not ready.

Likely Cause
The node is a Karpenter node that has been recycled and is no longer present in the cluster.

Investigation Plan
Check the tags for signed that the node is managed by Karpenter.
Check if the node has been completely removed from the cluster.

Remediation options
Update the incident with analysis and resolve it

Validation
Check to see that the same node is no longer visible in the cluster within 30 minutes of it becoming not ready.