---
id: 01M1YCEEYS3X6B3KFD6C29KB8W
created: 2026-09-07T16:50:26.905211Z
updated: 2026-09-07T16:50:26.905211Z
type: task
title: 'SSD1: Security is integrated into every phase of the Software Development Life Cycle (SDLC) to ensure systems are secure, resilient, and compliant with regulatory and business requirements'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 74
---
## Control Objective

Security is integrated into every phase of the Software Development Life Cycle (SDLC) for Callitech Limited's internally developed applications — including the telephone answering and live chat platforms, CRM integrations, and AI-based answering systems — to ensure these systems remain secure, resilient, and compliant with regulatory and business requirements (including GDPR and, where applicable to specific clients, HIPAA and PCI DSS).

## Implementation Guidance

Security activities are embedded into each SDLC phase, overseen by the Head of Infrastructure and Cybersecurity in coordination with the DevOps and development teams:

Planning: Feature and project requirements identify data sensitivity (PII, call recordings, CRM data, customer content) and applicable regulatory obligations before work is scheduled.Design: Architecture and integration changes to the front-end (Vue, React, CakePHP, Tailwind CSS) and supporting databases (MySQL, MongoDB, PostgreSQL, SQL Server) are reviewed for secure design principles such as least privilege and defense in depth, with particular attention to how AI-based answering system components handle customer and call data.Implementation: Developers follow established secure coding practices; source code is maintained in access-controlled repositories with change history retained.Testing: Code changes are validated in the development, staging, and UAT environments prior to production release, including functional testing and security-focused checks (e.g., input validation, review of authentication and authorization logic).Validation: Application inputs and outputs are validated server-side to ensure data integrity and to prevent bypass of client-side controls, particularly for forms and integrations that capture or display PII or call-related data.Deployment and maintenance: Releases follow the organization's change management process (see change management control), with monitoring and follow-up patching of identified issues.

Secure development practices are reviewed periodically and updated as the organization's technology stack, client requirements, or threat landscape evolve, particularly given the rapid growth of the AI-based answering product line.

## Evidence Request

Secure development procedure documentation covering planning through maintenance.Examples of design or architecture review notes for recent feature releases.Evidence of code review and/or testing performed prior to promotion from development/staging/UAT to production.Examples of input/output validation logic or test cases for customer-facing forms and integrations.Records showing repository access controls (e.g., restricted commit/merge permissions).