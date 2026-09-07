---
id: 01M1V9JYK5MAG9HSES4Y5WBNRG
created: 2026-09-06T12:02:44.965032Z
updated: 2026-09-06T16:22:25.190132Z
type: task
title: the Microsoft 365 panel never shows the reply URL its own sign-in needs
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 584
sprint: s2fcksg
comments:
- id: 01M1VNPX6Y173FWMPXJYNA5YWV
  author: Steve Vine
  at: 2026-09-06T15:34:37.534423Z
  text: |-
    Done — PR #598 merged to main.

    The Microsoft 365 panel now shows a read-only Redirect URI field beside the credential fields, in every state (configured or not), built the way the sign-in panel builds its own: the app base URL plus the grant callback path. The wording says it belongs to the Microsoft 365 registration and not the sign-in one, since registering it against the wrong app is the mistake this is meant to prevent.

    On staging it will read https://compass.citops.net/api/v1/integrations/m365/grant/callback — that is the Web redirect URI to add to the Microsoft 365 app registration. COM-585 (the callback refusing its own popup) is the other half of getting "Sign in and grant" working.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Setting up the SharePoint site connection, "Sign in and grant" fails at Microsoft with:

```
AADSTS500113: No reply address is registered for the application.
```

The app registration is fine except for one missing entry — the grant popup's callback URL, which has to be added as a **Web** redirect URI in Entra. Nothing on the Microsoft 365 panel tells you what that URL is, so there is no way to discover it from the screen where the failure happens; you have to know it, or read the code.

The sign-in panel already solves this: a read-only **Redirect URI** field with "Paste into the app registration's Web redirect URIs." The Microsoft 365 panel needs the same field, showing its own (different) callback.

- [ ] `M365SettingsOut` gains `redirect_uri`, built the way `_sso_out` builds its own — `app_base_url` (falling back to the request base) + `/api/v1/integrations/m365/grant/callback`.
- [ ] The Microsoft 365 panel in `IntegrationsSection.tsx` shows it as a read-only field with the same wording, alongside the credential fields.
- [ ] Regenerate `schema.d.ts`.

Two registrations, two different callbacks (ADR 0045 §2 keeps them independent) — the field must make clear this one belongs to the Microsoft 365 registration, not the sign-in one. Registering it against the wrong app is exactly the mistake this is meant to prevent.

## Related

- COM-248/266 — the sign-in panel's redirect URI field, the pattern to copy.
