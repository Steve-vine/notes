---
id: 01M3H6XM5V2NG2ZRJF56WRYAJ9
created: 2026-09-27T10:35:08.347251Z
updated: 2026-09-27T10:37:07.185852Z
type: task
title: 'Admin ▸ Integrations: the directory setup (AD only / Hybrid / Entra ID only) and an Active Directory connection'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 776
sprint: sme8esk
blocked_by:
- 01M3H6WFYD0APAYJZEZYSG6S25
- 01M3H6WWZZ3YX4SRVZ8X91Y6HC
assignee: steve
label:
- feature
priority: high
task_status: todo
---
Part of the on-premises AD sprint (ADR in COM-773).

## What people see

- **Directory setup**, at the top of Admin ▸ Integrations. Three choices — **AD only**, **Hybrid**, **Entra ID only** — each saying in a sentence what Compass does in it. For example, *"Hybrid: people and groups that live in AD are changed in AD, cloud ones in Entra; anything Compass can't reach becomes a to-do."* The page shows which connections the current setup needs and whether each is working: AD only needs AD; Hybrid needs AD and Entra; Entra ID only needs Entra; Exchange stays optional, as today.
  - An existing install with Entra connected starts as **Entra ID only**, so nothing changes until an admin chooses Hybrid.
  - Switching setup after the first choice (with its preview) is COM-785. This task records the choice and shows what it requires.
- **An Active Directory card**, laid out like the Entra and Exchange cards:
  - fields: domain, domain controllers, service account and password, and the LDAPS certificate
  - **Test connection**, which says plainly what worked and what didn't: "can't reach dc01", "certificate not trusted", "wrong password"
  - a health badge
  - a line on **System status**
  - Settings saved from the environment are labelled "Configured via environment", as for the attachment store.

## Notes (technical)

- **Settings.** An `ad_settings` singleton with a Fernet-encrypted bind password (`core/secretbox.py`), the CA certificate PEM, the DC list and the base DN. The env fallback is `AD_*` (the ADR 0074 pattern). The setup is its own singleton, or a column on it.
- **Test connection** is dispatched to the worker (`apply_async().get`, the Exchange pattern). The API pod never talks LDAP.
- **Health.** A beat task `ad_health` with a label in `core/task_labels.py` (the test enforces it). `core/system_status.py::_connection` widens its `Literal["entra","exchange"]`.
- **A test domain for CI.** A Samba AD DC testcontainer with LDAPS and a self-signed CA; the image is pulled through zot under `compass/test/*` (see the memory on zot sync). Every later task's integration tests use it.
- New `/api/v1/integrations/ad*` routes. Run the OpenAPI drift script.

**Done when:** on staging, with the COM-774 add-on in place, *Test connection* against the real domain succeeds and names the domain, and the health badge and System status go green. A wrong password or an untrusted certificate each show a plain reason. The setup selector shows and saves all three choices.