---
id: 01M1YCH5EVYY56P9JYPZRXW2EA
created: 2026-09-07T16:51:55.48392Z
updated: 2026-09-07T16:51:55.48392Z
type: task
title: 'VM3: Patch management processes are implemented to identify, acquire, deploy, and verify updates for software, operating systems, and firmware, ensuring systems remain secure and up to date against vulnerabilities'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 84
---
## Control Objective

Patch management processes are implemented to identify, acquire, deploy, and verify updates for software, operating systems, and firmware across Callitech Limited's environment, ensuring systems remain secure and up to date against known vulnerabilities.

## Implementation Guidance

An inventory of software, operating systems, and firmware is maintained to track patch requirements, covering server and endpoint operating systems, application components (including the CakePHP/React/Vue application stack and Tailwind CSS front end), database platforms (MySQL, MongoDB, PostgreSQL, and SQL Server), and firmware for network and telecom-facing equipment relevant to telephone answering services (e.g., handsets, VOIP/network gear, and other communications infrastructure).

Vendor and threat intelligence notifications are monitored to stay informed of newly released patches and disclosed vulnerabilities. Patches are scheduled for deployment based on asset criticality (with priority given to systems supporting TAS, cloud, identity, and communications services), patch severity, and operational impact. Where feasible, patches are tested in a non-production or controlled environment prior to deployment to reduce the risk of disruption to live telephone answering, live chat, or AI-based answering operations, given the organization's rapid growth in these areas.

Patch deployment is automated where supported by the tooling in use, and manually applied and tracked where automation is not available. Successful application is verified and reflected in the asset inventory, and patch management activities are periodically reviewed to identify gaps (e.g., systems missed by automated tooling) and opportunities for improvement.

## Evidence Request

Submit one of the following as evidence:

Patch management program documentation, including policies, processes, and procedures covering software, operating system, and firmware updates.Dashboard or report showing patch status, deployment timelines, or compliance metrics across the environment (including database and application platforms in use).