---
id: 01M4S039HSCDKK9XTF47TGSD1R
created: 2026-10-12T21:25:31.321978Z
updated: 2026-10-12T21:57:13.811701Z
type: task
title: An Azure storage account that has not blocked anonymous access says so — not that anyone can read its blobs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 939
sprint: svsqcj9
comments:
- id: 01M4S0WVDH8WV76QNWJ86KEJYC
  author: Me
  at: 2026-10-12T21:39:28.817025Z
  text: |-
    Merged to main (PR #926, 2026-10-12). Not on staging until you say; staging still has the old wording.

    What to look at once it is deployed and the subscription has been read again (Read now):
    - A storage account's detail says "Anonymous access blocked: Yes" or "No", and its chip says "Anonymous access blocked" or "Anonymous access not blocked".
    - Attach one that says No to a technology asset: the finding reads "Storage account X does not block anonymous access to its blobs."
    - "Deleted blobs kept (days)" shows 0 on the 35 accounts where soft delete is off, and 30 on the one where it is on.

    Until the subscription is read again after the deploy, storage accounts keep the old fact and the check has nothing to read, so it raises nothing. That is the safe direction.

    Three things from the same read that I did not change, because each is a choice:
    - Runtime is Unknown on all 46 web apps (they are Windows apps; Azure states a runtime only for Linux ones in what Compass may read). The row could be left out for Windows apps instead of saying Unknown.
    - Public endpoint is Unknown on 45 of 46 web apps (Azure leaves the setting empty where nobody has chosen). Same option.
    - One of the three virtual machines runs SQL Server 2012. Compass lists it as a virtual machine and proposes it as a part, because it cannot see what a machine runs. If it holds data it wants to be a technology asset of its own, which you can do by hand.
label:
- bug
priority: high
task_status: done
---
Part of sprint 67, Inventory expansion. Found on the first real read of an Azure subscription on staging, 2026-10-12 (Steve's, 110 resources, every request answered). Nothing had been attached to a technology asset yet, so no finding carried the wrong sentence.

## What is wrong

**1. The finding overstates.** 33 of the 36 storage accounts have Azure's account-level setting "allow blob anonymous access" switched on. That setting only *permits* a container to be made public; it is the default on older accounts and does not mean any container is. Compass's finding for it reads "Storage account X lets anyone read its blobs without signing in", which is false for most of them. It is the same situation as an S3 bucket that has not blocked public access, and AWS's sentence is the right one.

**2. "Deleted blobs kept (days)" says Unknown when it is known.** On 35 of 36 accounts soft delete is switched off, and Compass shows "Unknown". Unknown is for something Compass could not read.

## What people see after

- The finding reads **"Storage account X does not block anonymous access to its blobs."**
- The fact is **"Anonymous access blocked: Yes / No"**, the same way round as an S3 bucket's "Public access blocked", and the chips say "Anonymous access blocked" or "Anonymous access not blocked".
- **"Deleted blobs kept (days)"** shows 0 where soft delete is off, and Unknown only where the blob settings could not be read.

## Notes (technical)

- `core/discovery/azure/storage.py`: fact `blob_public_access` becomes `anonymous_access_blocked` (the inverse); `soft_delete_days` is 0 when the policy is disabled.
- `core/discovery/checks.py`: the Azure `public_access_not_blocked` check reads the new fact and takes the new sentence.
- `core/discovery/review.py`: the label.
- Stored facts are replaced whole at each read, so the old key goes at the next one. No migration.

## Also seen on that read, not changed here (for Steve)

- **Runtime is Unknown on all 46 web apps.** They are Windows apps, and Azure only states the runtime of a Linux app in what the role may read; for Windows it sits behind the "list" action Compass refuses to hold.
- **Public endpoint is Unknown on 45 of 46 web apps.** Azure leaves the setting empty on apps where nobody has chosen, and what empty means depends on whether the app has a private endpoint.
- **Seven kinds found nothing** in this subscription (PostgreSQL and MySQL servers, scale sets, AKS, container apps, load balancers, application gateways), so their readers are still untested against real data.

**Done when:** after a read, an Azure storage account with anonymous access not blocked, attached to a technology asset, shows "does not block anonymous access to its blobs".