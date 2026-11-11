---
id: 01M73Q9S96V19DX5JNC9G9GYXP
created: 2026-11-10T21:54:49.254874Z
updated: 2026-11-11T11:49:36.985142Z
type: task
title: 'Secrets from a feed: a service''s keys arrive on Secrets ▸ Discovered as keys at their source, with expiry, last use and rotation proof, and stored copies come in by name and date'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1700
sprint: sep79bz
blocked_by:
- 01M73Q8M80365XPSJR7G8BG302
comments:
- id: 01M7402VP2EHTYV7TWFEBJYEZP
  author: Steve Vine
  at: 2026-11-11T00:28:19.522441Z
  text: |-
    **Done: merged to main in PR #1701.**

    **What it does:**
    - **Keys at their source.** A Secrets keys feed puts the service's keys on **Secrets ▸ Discovered**.
      - Each one shows the owner, created date, expiry, last use, whether it can write, and who added it.
      - It's titled after the service: "Edge host key · Deploy pipeline — Deploy token t1".
      - Making a secret of one gets expiry reminders.
      - A key is gone when the Status says so, or (closing by "missing") when a complete read through that account no longer has it.
    - **Rotation proof works with no special handling.** A newer key on the same owner, the stored copy changing after it, and the old key gone and unused since are recorded as *Seen at source and store*. The test proves it end to end.
    - **Stored copies.** A copies feed puts copies on Discovered by name, where and last change, e.g. "Edge host ▸ deploy pipeline ▸ DEPLOY_TOKEN", with the service as the store. A newer last-changed date on a copy kept for a secret is half of a rotation's proof.
    - **Never a value.** Every mapped text goes through the register's own "looks like a key" check. One that does refuses the whole read: the run is Broken, saying which slot, never the value, and the preview shows the same.
    - **One new kind, "collection",** is added to both tables whatever the service. Rows are scoped per feed (migration 0802).

    **Tests:**
    - New integration tests: keys and copies arrive; one is made a secret and a copy attached; a rotation is proven on its own; a key-shaped value is refused and never echoed.
    - The existing Secrets tests (21), the Secrets screens and the unit suite pass.
assignee: steve
label:
- feature
priority: high
task_status: done
---
The Secrets side of ADR 0145 (COM-1695), plugged into feeds (COM-1697).

**Chain:** on the chain — migration + API

## What the person sees

- A feed into Secrets takes one of two forms, chosen when the feed is made:
  - **Keys at their source.** The service's own API keys and tokens (e.g. Cloudflare API tokens, MongoDB Atlas service-account secrets). Each one shows the mapped name, the service's ID, owner, created, **expiry**, last used and what it can do. New ones wait on **Secrets ▸ Discovered** to be made a secret, added to one, or discarded, as Entra, AWS and GitHub keys do today (ADR 0141).
  - **Stored copies.** Secrets held in a vault or CI system, by name and last-changed date, never a value. They link to secrets by suggestion or by hand.
- Everything Secrets does with a coded source works for a feed: expiry reminders, *gone* when a complete read no longer finds a key, and **rotation proof**. A rotation is proven *Seen at source and store* once Compass has seen all of: a newer key on the same owner, every copy changed after it, the old key gone, and the old key not used since (where the service gives last-used).
- Compass **never reads a value**. The feed can only map names, IDs and dates. A slot mapped to something that looks like a key is refused at preview and at every run (the same pattern pass as ADR 0142 §2).
- One account, one company, as for the other areas.

## Done when

- A feed can map both of ADR 0145's Secrets shapes. The preview lists keys or copies it would add, update or mark gone.
- Discovered, making and adding, gone, expiry reminders and rotation proof behave as for a coded source, tested with a fake service against real Postgres.
- A key-looking value in any mapped slot fails the preview and the run (Broken, with the reason), and the value isn't stored or logged.
- `secrets_list_discovered`, `secrets_get_discovered` and `secrets_get` show the feed as the source.
- No service name in code (COM-1696).

## Notes

- `models/secret.py`: `SecretSourceKey` (`kind`, `owner_ref`, `key_ref`, dates, `can_write`) and `SecretStoreEntry`. A feed needs its own source identity (the Collection account), not a new `kind` per service.
- Follow `core/secrets/sources.py` and `store_sync.py` for the proof rules. `github_source.py` is the closest model, but don't copy its GitHub logic.
- `core/secrets/guard.py` `looks_like_key` is the pattern pass.