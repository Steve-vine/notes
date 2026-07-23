---
id: 01KY4K4AGHNWMQMWQFP6H6G94C
created: 2026-07-22T09:39:54.001287Z
updated: 2026-07-23T14:15:10.302125Z
type: memo
title: SOC2 Project Overview
project: 01KY4JNC6MPPNNFXN416S398SG
---
# SOC2 Project Overview

Living overview of the SOC2 accreditation project. Reviewed at the start of chats to re-establish context; updated as goals, status, and blockers change.

## Purpose
Put the controls and processes in place for Moneypenny to achieve SOC 2 accreditation.

## Trust Services Criteria in scope
- Security (Common Criteria — mandatory)
- Availability
- Confidentiality
- Privacy

Out of scope: Processing Integrity.

## High-level goals
- Year 1 objective: SOC 2 Type 2, while maintaining Cyber Essentials Plus (annual, March) and GDPR-aligned practices.
- Consolidate multi-compliance needs into one programme, managed in Carbide Secure (GRC tool, replacing the SharePoint paper-based approach).

## Tooling
- **Carbide Secure** — GRC platform of record for controls, evidence, and the 19 readiness tasks (6 workstreams: Incident & BC, Privacy & Data, IAM, Secure Dev, Governance & Risk, Third Party).
- **This Notuvia project (SOC)** — working task tracking and memos. See also the *SOC2 Q&A* memo for answers on RBAC/key-management evidence, test data & API security evidence, and consent recording.

## Sprint plan
- **Sprint 1 — Formalise Processes:** SOC-8–14 + SOC-24. Gates the Type 2 observation window; processes must operate over the audit period.
- **Sprint 2 — Evidence Production:** SOC-1–7, SOC-15–23, SOC-25.
- **Sprint 3 — System Description:** SOC-26 (long-running; starts alongside sprint 2, completes before auditor engagement).

## Current status (2026-07-23)
- First evidence pass complete: ~60 artefacts uploaded to Carbide (10 July) across all 19 readiness tasks, with honest gap comments per task.
- All 19 Carbide tasks remain open (0% complete); most due dates (15–31 July) are now due or imminent.
- Gap analysis done in two passes, 26 gap tasks total (SOC-1 to SOC-26), each noting its source/related Carbide task:
  - **Pass 1 (from evidence comments & Q&A), SOC-1–15:** evidence gaps (RBAC matrix, key management, test data standard, API security config, lawful basis mapping), documentation gaps (Twingate, data asset owners, backup schedule), and process formalisation (governance, risk, internal audit, threat modelling, breach notification, DSR handling, third-party due diligence).
  - **Pass 2 (TSC coverage review), SOC-16–26:** awareness training evidence, vulnerability/patch management process, security monitoring & detection, physical security (Wrexham/Atlanta), asset inventory, background checks, capacity monitoring (A1.1), data classification, privacy complaints, subservice org/CUEC review, and the SOC 2 System Description.
- Highest audit risk from pass 2: training evidence, vuln/patch process, physical security, capacity monitoring — near-certain sample requests with zero current artefacts.
- All 26 tasks assigned to the three sprints above.

## Blockers
- Backup schedule evidence pending migration to new backup system (SOC-15).
- Governance structure needs official definition before governance evidence can be produced (SOC-8).

## Key decisions
- Trust Criteria scope agreed: Security, Availability, Confidentiality, Privacy.
- Carbide Secure adopted as the GRC platform of record; Notuvia used for working project tracking.
- Work sequenced as three sprints: formalisation → evidence production → system description.