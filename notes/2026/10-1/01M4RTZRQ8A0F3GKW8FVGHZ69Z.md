---
id: 01M4RTZRQ8A0F3GKW8FVGHZ69Z
created: 2026-10-12T19:56:12.904129Z
updated: 2026-10-12T19:57:48.297728Z
type: task
title: A discovered resource points at its connection one way, whichever cloud it came from — nothing changes on screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 925
sprint: s70gjk2
blocked_by:
- 01M4RTZ8Q9HXC84JEJ3D6XS8BG
assignee: steve
label:
- tech_debt
priority: high
task_status: todo
---
Part of sprint 69, Inventory discovery - GCP (ADR in COM-924). Housekeeping that the third source makes due. ADR 0103 accepted two connection columns on the resource record and said a third source "is the point at which the two columns are worth turning into one relation".

## What people see

- **Nothing new.** The Discovered tab, the "Found in" filter, rules that name an account or a subscription, the resources beneath a technology asset and its findings all look and behave as they do now, for AWS and for Azure.
- **Nothing is lost.** Every resource already read keeps its decision, its technology asset and its findings. Every connected AWS account and Azure subscription keeps its key, its health and its last read.

## Why now

Without it Google Cloud is a third nullable column and a third copy of every "which connection is this?" question. With it, the Google Cloud tasks that follow add a connection and its readers and touch nothing above them.

## Notes (technical)

- **A parent row per connection.** `discovery_connections`: `id`, `company_id`, `provider`, `name`, `account_ref`, `default_environment`, plus the health and read columns the provider tables hold in the same shape today. `aws_connections` and `azure_connections` keep their credentials and whatever is their own, and share the parent's primary key. The ADR may settle a different shape; build to the ADR.
- **`discovered_resources.connection_id`** (FK to the parent, SET NULL) replaces `aws_connection_id` and `azure_connection_id`. Existing ids carry over unchanged: the parent row takes the id its provider row already has.
- **`core/discovery/sources.py`** asks the parent table, not each provider's in turn. `connections`, `connection` and `company_connections` keep their signatures.
- **This migration transforms populated tables, and CI never migrates a populated database.** Rehearse it locally against a copy with AWS and Azure connections, attached and undecided resources, rules and open findings, upgrade and downgrade, before it goes to staging. Raw SQL fixtures in any migration test, not the models.
- Audit: the parent joins `_AUDITED_TABLES`; health and read writes stay actorless.
- API: no public field should change. If one must, regenerate `schema.d.ts` and say so in the PR.
- The AWS and Azure suites pass as they were, unedited except for fixtures.

**Done when:** staging has been upgraded with its AWS account still connected, and a read of that account changes nothing that was not already changing: same resources, same decisions, same findings.