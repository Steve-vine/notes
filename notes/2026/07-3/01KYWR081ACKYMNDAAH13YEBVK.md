---
id: 01KYWR081ACKYMNDAAH13YEBVK
created: 2026-07-31T18:46:49.642572Z
updated: 2026-08-07T08:34:53.279021Z
type: task
title: '@mention the recipient on high/critical notifications'
project: 01KX671DATY39VW6GWK3M2T3DN
number: 451
sprint: s8rg5n9
assignee: steve
priority: medium
task_status: done
---
Deferred out of ISE-448 deliberately, not forgotten — it needed behaviour that could not be verified without a live tenant, and shipping an unverified mention would render as broken text rather than failing cleanly.

**Why it is worth doing**: a mention cuts through muting and lands in the Activity feed. It is the strongest attention primitive a bot has, given bots CANNOT send "urgent" priority messages (no 2-min-for-20-min repeat; `ActivityImportance.High` does not trigger it — established in the ISE-448 research, do not re-derive).

**Where it actually matters**: GROUP CHATS. A 1:1 direct message already notifies hard, so a mention adds little there. A group chat is exactly where messages get muted and a card scrolls past.

**The blocker to resolve first**: the mention entity needs the TEAMS member id (the `29:…` form), NOT the Entra object id ISE already holds from ISE-447. Getting it means a roster call — `GET /v3/conversations/{conversationId}/members` on the Bot Connector — matching on `aadObjectId` to find the member, then using that member's `id`. Verify live: whether the roster call is permitted for a bot in a group chat it was installed into, and whether the id it returns is accepted in `msteams.entities`.

Shape:
- `<at>Display Name</at>` in the card's TextBlock, with a matching entry in the card's `msteams.entities` referencing the member id.
- BEST EFFORT, mirroring the supersede edit (ADR 0069 §5): if the roster lookup fails or the member cannot be matched, post WITHOUT the mention rather than failing the notification. An unmatched `<at>` renders as literal broken text, which is worse than no mention.
- Gate on severity — high and critical only. Mentioning on every info-level notice trains people to ignore mentions.

Consider at build: whether resolving and caching the member id per (conversation, user) is worth it, or whether one roster call per send is acceptable given notification volume is low.