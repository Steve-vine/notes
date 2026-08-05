---
id: 01KYWHGF17XY27YYK08XYDQ8MX
created: 2026-07-31T16:53:21.063253Z
updated: 2026-08-05T19:29:36.267763Z
type: task
title: Teams bot foundation — ADR, bot client, retire the Power Automate poster
project: 01KX671DATY39VW6GWK3M2T3DN
number: 446
order: 1.25
sprint: s8rg5n9
assignee: steve
priority: medium
task_status: done
---
Foundation for bot-delivered notifications, and the removal of the mechanism it replaces.

- **ADR** (number TBD AT BUILD TIME — Freshservice claimed 0068 and parallel sprints are actively claiming numbers; check `docs/decisions/` before writing). Records: why Power Automate is banned outright (runs as its owner, dies silently on password/MFA change — a standing rule, see the sprint description), why Graph app-only cannot send Teams messages (`Teamwork.Migrate.All` only), why RSC cannot send to a chat, and why a bot is the only app-owned route. Amends ADR 0067, whose §1 claim about Graph is true but incomplete (omits RSC).
- **BotFrameworkClient** in the `msgraph.py` / `ArmClient` shape: client credentials → token for `https://api.botframework.com/.default`, cached with expiry, bounded 429 retry, injectable sleep seam. Zero new deps (httpx).
- **Credentials**: bot app id + secret in the existing credential store. A SECOND credential (Graph app permissions for destination discovery/install) may be needed — decide in build whether one app registration carries both or they stay separate.
- **RETIRE the `msteams` (Power Automate) channel kind** — ISE is single-tenant and the mechanism is banned, so shipping it would leave an unusable option in the UI. Migration: CHECK-constraint swap on `notification_channel.kind` (the 0075 pattern), `msteams` → `msteams-bot`, plus the destination columns ISE-446 needs. Remove `post_message`/URL handling from `notifications.py` and the URL field from the Settings card.

NOTE: migration head is 0077 and parallel sprints may take numbers — verify before writing.