---
id: 01M5Y9FKJYXKVFE847JCK8FEEX
created: 2026-10-27T09:01:25.982335Z
updated: 2026-10-27T16:10:40.030646Z
type: task
title: Nessus and Aikido tiles — connect and test against our real Nessus Expert server and Aikido workspace, so we know before sprint 92 what Compass can pull from each
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1359
sprint: s8fmesf
blocked_by:
- 01M5Y9C3P6MGA186PBB0BF38C4
comments:
- id: 01M5Z21GFFE8Y2BTTE5S066J9C
  author: Steve Vine
  at: 2026-10-27T16:10:38.447488Z
  text: |-
    Built — PR #1375, merged to main (migration 0713_scanner_settings). The real-server check is still to do; it needs your keys.

    What's there:
    - Nessus ▸ Configure: server address, access key, secret key (write-only), optional CA certificate for a self-signed server, and Test. Test reports the version and licence type, how many scans the key can see, and the newest finished scan's name and date. A refused call says which and gives Nessus's own message.
    - Aikido ▸ Configure: region (Europe, US, Australia, Middle East), client ID, client secret (write-only), and Test. Test signs in with OAuth client credentials, then tries the workspace, code repositories, containers and open issue groups in turn. For each it says whether it answered and how many came back.
    - Features ▸ Vulnerabilities on both: shown, not switchable ("Arrives with the Vulnerabilities module").
    - Status: a sign-in check every 15 minutes. A refused key turns the tile to Needs attention. The last Test's findings show on Status.
    - Both are global and manage-integrations only. Nothing else from either tool is stored.

    Still to do, which needs you once it's on staging:
    1. On Nessus Expert, create an API key pair for a user who can see the scans (My account ▸ API Keys). Enter the server address, the keys, and the CA certificate if the server's certificate is self-signed.
    2. In Aikido, create a public-API client (Settings ▸ API access, under Integrations). Enter the client ID and secret and pick the region.
    3. Press Test on both. Then I'll probe what Test doesn't cover and write the findings comment the task asks for: reading a scan's results, the .nessus and CSV exports, plugin details (CVE, CVSS, solution), Aikido's issue fields, paging and rate limits, and whether staging and production can reach the Nessus server.

    Caveat: Aikido's public docs only confirm the token endpoint. The four read paths Test tries are my best reading of their API. Test reports exactly which answered, which is itself the finding sprint 92 needs.
assignee: steve
label:
- feature
priority: high
task_status: review
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