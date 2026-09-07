---
id: 01M1YCGW61K9J39RYAE30WGCK6
created: 2026-09-07T16:51:45.985067Z
updated: 2026-09-07T16:51:45.985067Z
type: task
title: 'VM1: Regular vulnerability scans are conducted and integrated with a structured remediation program, exception management process, and transparent reporting to senior leadership to ensure security risks are identified, managed, and communicated effectively'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 83
---
## Control Objective

Regular vulnerability scans are conducted across Callitech Limited's infrastructure and applications and integrated with a structured remediation program, exception management process, and transparent reporting to senior leadership (and, where warranted, the Board of Directors) to ensure security risks are identified, managed, and communicated effectively.

## Implementation Guidance

Automated vulnerability scanning tools are run on a regular schedule (and ad hoc following significant infrastructure or application changes) against Callitech's environment, which spans UK and US-hosted infrastructure supporting telephone answering services (TAS), live chat, and AI-based answering systems. Scope includes web applications built on React, Vue, CakePHP, and Tailwind CSS, and databases including MySQL, MongoDB, PostgreSQL, and SQL Server, as well as cloud, identity, and communications platforms.

Identified vulnerabilities are prioritized using risk-based criteria (severity, exploitability, and potential business impact), with particular attention to systems designated mission-critical — TAS, cloud infrastructure, identity systems, communications platforms, and AI-based answering systems — because a failure to remediate on these systems could contribute to a business disruption. Remediation owners, timelines, and status are tracked to closure by the Head of Infrastructure and Cybersecurity's team.

Where a vulnerability cannot be remediated on the standard timeline (e.g., due to vendor dependency or operational constraint), a formal exception is raised requiring a documented justification, risk evaluation, compensating controls where applicable, an accountable approver, and a defined review/expiration date. Exceptions are reviewed periodically to confirm they remain necessary.

Pending adoption of a dedicated GRC tool, vulnerability findings, remediation plans, and exceptions are logged and tracked centrally (currently via a controlled spreadsheet/SharePoint-based register with restricted access) so that status is auditable and consistent across the UK and US operations.

Summary reporting — covering open vulnerabilities, severity distribution, remediation progress, exception status, and residual risk to mission-critical services — is provided to senior leadership on a periodic basis, with ad hoc escalation for critical findings or emerging threats. Reports are used to inform resourcing and prioritization decisions, and to keep leadership (and the Board, where appropriate) informed of the organization's exposure and its relationship to business continuity risk.

## Evidence Request

List of vulnerabilities with associated remediation plans, including descriptions, prioritization, remediation steps, assigned owners, timelines, and status.Vulnerability reporting and evaluation report(s) shared with senior leadership, including prioritized vulnerabilities, mitigation plans, progress updates, and any escalation to the Board.List of exceptions, including descriptions, approval dates, responsible parties, review/expiration dates, and planned resolutions.Vulnerability scan documentation, including scope, identified vulnerabilities, remediation actions, and follow-up verification.