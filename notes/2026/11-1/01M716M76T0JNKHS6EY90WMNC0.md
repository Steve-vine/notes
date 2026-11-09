---
id: 01M716M76T0JNKHS6EY90WMNC0
created: 2026-11-09T22:24:56.538926Z
updated: 2026-11-09T23:05:25.438292Z
type: task
title: A Collection service with an IPv6 address can't be reached from an IPv4-only cluster — Compass picks the address that sorts first, not one it can reach (Datadog)
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1664
sprint: sjvqrdg
comments:
- id: 01M718YA8SMP550V8T3F5H1VS2
  author: Steve Vine
  at: 2026-11-09T23:05:24.505687Z
  text: |-
    **Done: merged to main in PR #1669, on staging aea14af8 (2026-11-09).**

    **What it does:**
    - Compass now tries a service's vetted addresses in order, IPv4 first, and moves on to the next if one can't connect. The address that worked is tried first next time.
    - The same applies to an OAuth token address, and a logo is fetched from an IPv4 address first.
    - **The safety rule is unchanged:** every address must still be public, and the connection still goes to a vetted address, so a second lookup can't redirect it.

    **Tests:**
    - New `test_collection_reach.py`: IPv4 before IPv6, an IPv6-only name, a private address still refused, falling through to the next address (remembered), none connecting, the token address, and the logo.
    - The 12 test files that stood in for DNS were moved to the new lookup.
    - The unit suite and the affected integration tests passed locally and in CI.

    **Pre-UAT: Passed.** Steve's Datadog account (Test Company, https://api.datadoghq.eu) now tests as "Signed in. The test read answered with: data, included, meta". It had failed with "Compass couldn't reach the service".

    Production's EKS pod network wasn't checked from here (no prod access from this machine). The fix works whether or not it has IPv6.
assignee: steve
label:
- bug
priority: urgent
task_status: review
---
Raised by Steve while testing on staging (2026-11-09). A Datadog Collection integration (https://api.datadoghq.eu, bearer) failed its test with "Compass couldn't reach the service". The token never reached Datadog.

## The problem

- To stop a second DNS lookup redirecting a request (ADR 0142 §8, "Internet only"), Compass looks the service's name up once, checks every address is public, and then connects to **one** of them. It picks `sorted(addresses)[0]`, the first as text.
- `api.datadoghq.eu` has an IPv6 address (`2600:1901:0:5e96::`) and an IPv4 one (`34.149.115.151`). As text the IPv6 one sorts first, so Compass connects to it.
- **Staging's cluster is IPv4-only** (pod network `10.42.0.0/24`), so that connection can't be made, and the test fails before any request is sent. The g5 host itself reaches both addresses.
- It hits **any** service with both kinds of address whose IPv4 address sorts after its IPv6 one as text (an IPv4 address starting 3–9, against IPv6's usual 2…). GitHub (140.82…) and Cloudflare (104.…) were lucky. Production (EKS) may be the same, so check its pod network.

## Done when

- **Compass reaches a service on whichever of its vetted addresses it can.** It tries IPv4 addresses first, then IPv6, and moves on to the next vetted address if a connection can't be made (refused, unreachable or timed out on connect). It gives "Compass couldn't reach the service" only when none can be reached.
- **The safety rule doesn't change:** every address the name has must still be public, or the request is refused. The connection still goes to a vetted address, with the name in the Host header and SNI, so a second lookup can't redirect it. Next-page links stay on the service's own host.
- The same applies to the token address for client-credentials sign-in, and to fetching a logo if it uses the same pinning.
- **Tests:**
  - a name with an IPv6 and an IPv4 address connects to the IPv4 one;
  - an IPv6-only name still connects to its IPv6 address;
  - when the first address can't be connected to, the next is tried;
  - when none can, the failure is "Compass couldn't reach the service";
  - a name with any private address is still refused.
- **On staging:** the Datadog integration's test gets an answer from Datadog: signed in, or Datadog's own words if the token is wrong. Steve's token passing is his to check.

## Notes

- **Independent:** backend only. No migration, no API change.
- Where:
  - `core/collection/client.py`: `public_address()` returns `sorted(addresses)[0]` and should return the vetted addresses IPv4 first; the client's `_get` / send and the token request should try them in turn;
  - `core/collection/accounts.py` `_resolve`;
  - check `core/assets.fetch_picture` for the same pattern.
- Before closing, check whether prod's EKS pod network is IPv4-only.
- Separately, Steve says he made an "application token". A Datadog application key (`ddapp_`) can't sign in as a bearer token on its own; a personal (`ddpat_`) or service account (`ddsat_`) access token can. Once reachable, a 401 or 403 with Datadog's words will show which it is.