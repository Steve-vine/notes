---
id: 01M3H6XM5V2NG2ZRJF56WRYAJ9
created: 2026-09-27T10:35:08.347251Z
updated: 2026-09-27T12:47:35.493844Z
type: task
title: 'Admin ▸ Integrations: the directory setup (AD only / Hybrid / Entra ID only) and an Active Directory connection'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 776
sprint: sme8esk
blocked_by:
- 01M3H6WFYD0APAYJZEZYSG6S25
- 01M3H6WWZZ3YX4SRVZ8X91Y6HC
comments:
- id: 01M3HEG34W4X5RAFEXVZ0CSY9K
  author: Steve Vine
  at: 2026-09-27T12:47:33.532623Z
  text: |-
    Done: PR #786, merged to main (ba2e6cb) and on staging.

    **Admin ▸ Integrations now opens with *Directory setup*:**
    - **AD only**, **Hybrid** or **Entra ID only**, each with a sentence on what Compass does in it.
    - Below the choice: what the current setup needs (Active Directory, Entra ID, Exchange Online, the last optional) and whether each is configured and healthy.
    - Staging starts as **Entra ID only**, so nothing behaves differently until you choose Hybrid. Changing it is recorded in the audit trail. For now the choice is recorded and shown; what it switches on arrives with COM-784/785.

    **A new *Active Directory* card, laid out like Exchange's:**
    - **Fields:**
      - domain
      - domain controllers (one per line, tried in order; add `:port` if not 636)
      - service account (UPN, DOMAIN\name or DN)
      - password (stored encrypted, never shown again)
      - the CA certificate the controllers' certificates chain to (checked when you save; its name and expiry are shown)
    - **Test connection** runs on the worker and says in plain words what it found:
      - on success: *Connected to corp.example.com through DC01… as CORP\svc-compass*
      - or what's wrong: can't reach a controller (and on which port), certificate not trusted, certificate doesn't name the host, account or password refused, or the controller belongs to a different domain
    - A wrong password is **not** retried on every controller, so a typo can't lock the service account out.
    - A health check runs every 5 minutes, drives the badge, and appears on **System status** as *Active Directory*.

    **One change of plan:** the throwaway test domain (Samba) in CI moves to COM-777, the first task that actually reads AD. Here the check's wording and behaviour are tested without it.

    **Smoke test:**
    1. Admin ▸ Integrations: *Directory setup* at the top shows *Entra ID only* and what it needs. Pick *Hybrid* and save; the list gains Active Directory, marked *Not configured*.
    2. Fill in the Active Directory card and save.
    3. *Test connection* can't succeed until the worker has a route to your domain controllers (the Twingate add-on). Until then it should say *Can't reach dc… on port 636 — is there a route from the worker to the domain controller?* That is itself a useful check of the wording.
assignee: steve
label:
- feature
priority: high
task_status: review
---
Part of the on-premises AD sprint (ADR in COM-773).

## What people see

- **Directory setup**, at the top of Admin ▸ Integrations. Three choices — **AD only**, **Hybrid**, **Entra ID only** — each saying in a sentence what Compass does in it. For example, *"Hybrid: people and groups that live in AD are changed in AD, cloud ones in Entra. A change Compass isn't set up to make becomes a to-do; one that fails can be retried."* The page shows which connections the current setup needs and whether each is working: AD only needs AD; Hybrid needs AD and Entra; Entra ID only needs Entra; Exchange stays optional, as today.
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
- **"Set up" means configured, not healthy.** Routing reads "is AD configured for this setup" (plus COM-778's managed OUs), never the health badge. An unhealthy but configured AD makes changes **fail and retry** (COM-773's rule).
- **Test connection** is dispatched to the worker (`apply_async().get`, the Exchange pattern). The API pod never talks LDAP.
- **Health.** A beat task `ad_health` with a label in `core/task_labels.py` (the test enforces it). `core/system_status.py::_connection` widens its `Literal["entra","exchange"]`.
- **A test domain for CI.** A Samba AD DC testcontainer with LDAPS and a self-signed CA; the image is pulled through zot under `compass/test/*` (see the memory on zot sync). Every later task's integration tests use it.
- New `/api/v1/integrations/ad*` routes. Run the OpenAPI drift script.

**Done when:** on staging, with the COM-774 add-on in place, *Test connection* against the real domain succeeds and names the domain, and the health badge and System status go green. A wrong password or an untrusted certificate each show a plain reason. The setup selector shows and saves all three choices.