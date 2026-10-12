---
id: 01M4RTZRQ8A0F3GKW8FVGHZ69Z
created: 2026-10-12T19:56:12.904129Z
updated: 2026-10-12T22:25:22.010477Z
type: task
title: A discovered resource points at its connection one way, whichever cloud it came from — nothing changes on screen
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 925
sprint: s70gjk2
blocked_by:
- 01M4RTZ8Q9HXC84JEJ3D6XS8BG
comments:
- id: 01M4S3GSHM0MZ04FXP67SEHS6Z
  author: Steve Vine
  at: 2026-10-12T22:25:19.412567Z
  text: |-
    Merged to main (PR #928, 2026-10-12). Not on staging until the whole sprint is in review.

    Nothing to look at: the screens and the API are unchanged. What to check after the deploy is that nothing moved. The AWS account on staging should still be connected and healthy, its resources should still be on the Discovered tab with the decisions they had, and technology assets should still show the resources and findings beneath them. Read now on the account should change nothing that was not already changing.

    What changed underneath: every connection now has one small shared row, and a discovered resource points at that instead of at an AWS column or an Azure column. Google Cloud then needs no column of its own.

    Different from the task text:
    - The shared row is much thinner than I described. It says only that a connection exists and which provider it belongs to. Names, health and read state stay on the AWS and Azure tables. Moving them would have rewritten connection code that is working and in use.
    - The shared row is not in the activity log. It holds nothing a person decides; the AWS and Azure connections still are.

    The migration moves rows that already exist, which CI never does. So there is a test that takes the real path: a database at the previous version with an AWS account, an Azure subscription and resources beneath both (and one resource whose connection was removed long ago), upgraded, downgraded and upgraded again, with every link checked each time.

    Technical: migration 0247 (discovery_connections). models/discovery_connection.py makes and removes the shared row with the provider's row, so no caller changed. 119 existing AWS and Azure integration tests pass with three assertions renamed.
assignee: steve
label:
- tech_debt
priority: high
task_status: review
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