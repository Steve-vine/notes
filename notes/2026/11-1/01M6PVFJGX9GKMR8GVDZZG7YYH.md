---
id: 01M6PVFJGX9GKMR8GVDZZG7YYH
created: 2026-11-05T21:57:45.629156Z
updated: 2026-11-06T00:10:52.866871Z
type: task
title: 'Reading Core systems for collection — one read-only way to ask AWS, Azure, Microsoft 365 and AD a question through the connections Compass already has: reads every page, refuses anything that changes something or returns a secret, and says which permission is missing'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1598
sprint: s1jcke1
blocked_by:
- 01M6PVDTTX6KZBCPXSXY1XXDW3
comments:
- id: 01M6Q339G46NAAM77AZABR2DWT
  author: Steve Vine
  at: 2026-11-06T00:10:51.780006Z
  text: |-
    Done: PR #1614 merged. No migration, no API change.

    What's there: `core/collection/core_reads.py`, one read-only way to ask a Core system a question, kept as data (a "read") and answered with every item or an error in words.

    - **AWS:**
      - only operations named Describe…, List…, Get… or Lookup…;
      - about 55 calls refused by name (secret values, SSM parameters, passwords, tokens, credentials, Lambda code and config, data reads such as s3:GetObject), plus any operation whose name says it hands over a secret;
      - WithDecryption and IncludeValue refused;
      - answers scrubbed of secret fields (user data, client secrets; environment variables show names only);
      - every page, across all enabled regions or the ones named; global services read once.
      - A missing permission says which: "Compass's AWS role can't call config:DescribeConfigRules. Add it to the policy, or attach AWS's SecurityAudit policy."
    - **Azure:** GET only, inside the connected subscription; action segments such as listKeys refused; api-version required; nextLink followed.
    - **Microsoft 365:**
      - Graph GET under /v1.0 or /beta;
      - next links followed on graph.microsoft.com only;
      - a single object counts as one item;
      - 403 names the missing Graph permission.
    - **AD:**
      - an LDAP search naming its attributes (never * or +);
      - password, LAPS, BitLocker and gMSA attributes are never asked for, and dropped even if returned;
      - paged to the end, on the worker.

    My calls:
    - **No Celery task of its own.** Everything that reads (Polaris jobs, scheduled collection) already runs on the worker.
    - **Stacked after COM-1597, not independent.** It reuses COM-1596's error type and its size caps.

    Tested: 108 unit tests, including every refused AWS name, made-up write operations, paths outside the subscription, links off Graph, and secret attributes returned by a fake directory.

    To check on staging: a read of `ec2:DescribeSecurityGroups` across the staging AWS account's regions, done through a collected check (COM-1601).
assignee: steve
label:
- feature
priority: high
task_status: review
---
Sprint "Evidence Collection - Integrations" (ADR 0142, COM-1595). Nothing new appears on screen in this task. It is the safe reader that collection plans (and Polaris, while designing them) use against Core systems. The Collection request client is built in COM-1596.

## What it does

A **read** names a connection (an AWS account, an Azure subscription, the Microsoft tenant, the AD directory) and a question in that system's own terms. It answers with every item, or fails in words.

- **AWS:** a service and an operation, with its parameters, run through the account's existing role or key.
  - Only operations whose names start `Describe`, `List`, `Get` or `Lookup` are allowed.
  - Operations that return secrets are refused by name: `secretsmanager:GetSecretValue`, `ssm:GetParameter(s)` with decryption, `kms:Decrypt`, `ec2:GetPasswordData`, `iam:GetCredentialReport` contents, `lambda:GetFunction` code links, and so on.
  - The region can be one or all of the account's regions.
- **Azure:** a Resource Manager path, read with GET only. `listKeys` and similar are POSTs, so they can never be made.
- **Microsoft 365:** a Microsoft Graph path, read with GET only. It's paged with `@odata.nextLink`; the `$select` must survive paging.
- **AD:** an LDAP search (base, filter, attributes), run on the worker as directory reads are today.
  - Never returns password, LAPS (`ms-Mcs-AdmPwd`, `msLAPS-*`), BitLocker recovery or similar attributes, even when asked.
- **Every page, or nothing.** Paging runs to the end. Throttling is retried, honouring Retry-After. A read that can't finish, or passes the item and size caps (ADR 0142), fails. It is never cut short.
- **Missing permission, in words:** "Compass's AWS role can't call `config:DescribeConfigRules`. Add it to the policy, or use AWS's SecurityAudit policy."
  - This task doesn't widen any shipped policy or role. It only says what's missing.

## Notes (technical)

- A new `core/collection/read.py` (or similar) with one function per platform behind a common `Read` / `ReadResult` shape. It reuses what's there:
  - boto paginators where an operation has one, or a manual NextToken loop;
  - `core/azure.py` token and retry;
  - `core/graph.py` `graph_get_all` (watch the httpx params trap: a `$select` baked into the URL is dropped);
  - the AD connection code from `core/ldap…`.
- The allow-list and refuse-list are code with tests. They are the safety boundary, so test them exhaustively: every refused name is refused, and a made-up operation outside the prefixes is refused.
- AD reads run as a Celery task on the worker (only the worker reaches on-prem through Twingate).

**Chain:** independent (no migration, no API change).

**Done when:** tests prove each platform's paging reads every page, the refuse-list blocks every listed call, and a POST or write can't be expressed. On staging, a read of `ec2:DescribeSecurityGroups` across all regions of the staging AWS account returns every group, and `secretsmanager:GetSecretValue` is refused before any call is made.