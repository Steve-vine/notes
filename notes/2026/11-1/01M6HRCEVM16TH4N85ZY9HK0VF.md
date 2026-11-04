---
id: 01M6HRCEVM16TH4N85ZY9HK0VF
created: 2026-11-03T22:27:25.684723Z
updated: 2026-11-04T05:23:21.97789Z
type: task
title: 'GitHub integration — a GitHub tile on Admin ▸ Integrations: connect one or more GitHub organisations through a read-only GitHub App, with a health pill, the App''s key held write-only, and the permissions listed with why each is needed'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1575
sprint: sjrd5gz
blocked_by:
- 01M6HRBNQG0SZ90MQRNRD4YCFF
comments:
- id: 01M6JG5YR9J99P0T04N4CYVWNH
  author: Steve Vine
  at: 2026-11-04T05:23:18.409176Z
  text: |-
    Merged to main in PR #1589.

    **What's in it**
    - **Admin ▸ Integrations ▸ GitHub** is a new tile, under Security.
    - Its set-up shows the read-only GitHub App to create in the organisation, with every permission and why it's needed (all read only, no webhook).
    - For each company you then connect an organisation with the App's ID and its private key. The key is encrypted and never shown again; Replace key and Remove are there too.
    - **Test** finds the App's installation and says how many repositories it can see. The tile shows Connected, or needs attention if Test fails ("Can't sign in: the key was revoked…", "The App isn't installed on …").
    - The tile has two features, **Deploy keys and tokens** (COM-1581) and **Actions secrets** (COM-1576).
    - Every call goes to api.github.com and nowhere else. GitHub's API never returns a secret's value.

    **Couldn't check:** a live App. None is installed yet, so the Test against RootCause-IT is for Steve once the App exists.
assignee: steve
label:
- feature
priority: medium
task_status: review
---
Sprint "Secrets - New Module" (ADR 0141, COM-1563). Builds on COM-1574. It follows the integrations tile pattern (ADR 0128). This task is the connection alone. What Compass reads through it comes in the next tasks: deploy keys and tokens (COM-1581) and Actions secrets (COM-1576). Other modules could use the same connection later (Dependabot alerts in Vulnerabilities, GitHub's secret-scanning alerts) by adding permissions to the App, not a new connection.

## What people see

- **Admin ▸ Integrations ▸ GitHub.** A new tile, laid out like the other integration tiles. Connecting it walks through creating a GitHub App in the organisation:
  - The App's permissions are all read only. Compass shows the exact list, and why each is needed.
  - The App is installed on all repositories, or the ones chosen.
  - Then Compass is given the App ID, the organisation and the App's private key.
- **Health pill**, like Azure's:
  - "Connected · last read 10:42"
  - "Can't sign in: the key was revoked"
  - "Missing a permission: Secrets (read). Update the App's permissions and accept them in GitHub"
- **Test connection** signs in and lists the repositories the App can see, with a count.
- **More than one organisation** per company. Each has its own App and its own health.
- **Features** on the tile (ADR 0128). This sprint gives it two: **Secrets ▸ Deploy keys and tokens** and **Secrets ▸ Actions secrets**. Each can be switched off on its own.
- **Compass's own key.** The App's private key is held like the Azure client secret: encrypted, write-only, replaceable, never shown again, redacted from logs (ADR 0103 §3). It never expires, so the tile suggests registering it in Secrets like any other key.
- **What it can't do** is said on the tile: "Compass can't read a secret's value: GitHub's API never returns one."
- **Removing the connection** deletes the key and stops the reads. What was read stays, marked "No longer read".

## Notes (technical)

- GitHub App permissions, all requested now so people install once:
  - Repository **Metadata**: read (mandatory).
  - Repository **Administration**: read. Needed for deploy keys (COM-1581).
  - Organization **Personal access tokens**: read. Needed for fine-grained tokens (COM-1581).
  - Repository **Secrets**, repository **Environments** and organisation **Secrets**: read. Needed for Actions secrets (COM-1576).
- Authenticate with a JWT signed by the App key, then use installation tokens (short-lived). Cache them until shortly before expiry, keyed by the stored key, as Azure's are.
- Respect rate limits (the installation's 5,000/hour). Reads run on the discovery schedule.
- A new tile in `core/integrations/tiles/github.py`, plus the connection model and encrypted key column (`core/secretbox`). Add the column name to the redaction list.
- Gitleaks: no realistic-looking private keys in fixtures (memory: gitleaks scans branch history). Generate test keys at test time.
- Real check: Steve creates the App on RootCause-IT. Read locally first.

**Chain:** on the chain (migration and API).

**Done when:**
- Locally, connecting to RootCause-IT with the App installed passes Test connection and lists the compass repository.
- A revoked key turns the health pill to "Can't sign in".
- On staging, the GitHub tile shows on Admin ▸ Integrations with its two features, and the key is never returned by the API after saving.
- The live connection is **Couldn't check** in pre-UAT. Steve connects the tile.