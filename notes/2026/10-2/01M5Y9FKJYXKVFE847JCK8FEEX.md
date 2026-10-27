---
id: 01M5Y9FKJYXKVFE847JCK8FEEX
created: 2026-10-27T09:01:25.982335Z
updated: 2026-10-27T13:03:05.354422Z
type: task
title: Nessus and Aikido tiles — connect and test against our real Nessus Expert server and Aikido workspace, so we know before sprint 92 what Compass can pull from each
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1359
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
assignee: steve
label:
- feature
priority: high
task_status: active
---
Sprint 90, Integrations (ADR in COM-1347). Builds on COM-1349.

This de-risks sprint 92 (scanner sources). Steve, 2026-10-27: "Nessus Expert, on a server Compass can reach." Nessus Expert is the standalone scanner, and Tenable restricts its API. Uploading the `.nessus` export file will be offered in sprint 92 whatever this finds. This task establishes whether Compass can also **pull** scans itself.

## What people see

- **Two tiles in the Security tools category: Nessus and Aikido.**
- **Nessus:**
  - **Overview:** Compass reads finished scan results and never starts, stops or changes a scan. It needs an API key pair from a Nessus user who can see the scans.
  - **Configure:**
    - the server address (e.g. `https://nessus.internal:8834`);
    - the access key and secret key (write-only);
    - an optional CA certificate for a self-signed server;
    - **Test**.
  - **Test reports:** the Nessus version and licence type, how many scans the key can see, and the newest finished scan's name and date.
- **Aikido:**
  - **Overview:** Compass reads open issues from code, dependencies, containers and cloud. It changes nothing in Aikido. It needs a public-API client created in Aikido's settings.
  - **Configure:** client ID and client secret (write-only), **Test**.
  - **Test reports:** the workspace name, how many repositories and containers it covers, and how many open issues it has.
- **Features**, both tiles: **Vulnerabilities**, shown with "Arrives with the Vulnerabilities module", not switchable yet.
- **Status:** health from a background check every 15 minutes, the same as the cloud tiles.
- **Both are global.** Which company each Nessus scan or Aikido repository belongs to is set in sprint 92.

## Who can do what

Manage integrations.

## Findings to record (a comment on this task)

- **Nessus Expert:** which calls the key is allowed, against our real server:
  - list scans;
  - read a scan's results;
  - export a scan (`.nessus` and CSV);
  - read plugin details (CVE, CVSS, solution).
  - Note anything refused and the exact message.
- **Aikido:** which issue fields come back:
  - severity and score;
  - CVE;
  - affected repository, package, container or cloud resource;
  - first seen / fixed dates;
  - whether issues are grouped.
  - Note how its paging and rate limits behave.
- **Reach:** whether staging (g5) and production (EKS) can reach the Nessus server, or need the network-reach addon.

## Notes (technical)

- Two global settings rows with encrypted secrets (`core/secretbox.py`) and health columns, the shape of `exchange_settings`.
- Nessus auth: the `X-ApiKeys: accessKey=…; secretKey=…;` header. Aikido: OAuth client credentials.
- Use httpx with a fake transport seam for tests, like `core/azure._new_client`. No vendor SDKs.
- Nothing from either is stored yet beyond the health result.

**Chain:** on the chain (migration; API).

**Done when:**
- both tiles connect and Test green against Steve's real Nessus Expert and Aikido workspace on staging;
- the findings comment is written.