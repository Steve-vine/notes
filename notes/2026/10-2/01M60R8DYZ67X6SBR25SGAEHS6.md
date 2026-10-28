---
id: 01M60R8DYZ67X6SBR25SGAEHS6
created: 2026-10-28T07:58:08.351942Z
updated: 2026-10-28T09:16:06.737187Z
type: task
title: Nessus Test and Refresh reach an on-premises server — they run where the network add-on is, not in the web server
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1389
sprint: ssp4evc
comments:
- id: 01M60TQCG8C24KT13ZQPT7WCKJ
  author: Steve Vine
  at: 2026-10-28T08:41:15.528203Z
  text: |-
    Fixed — PR #1399, merged to main (408b9c70, build green). No migration, no API change.

    - **Test** and **Refresh** on the Nessus tile now ask the background worker to talk to Nessus. The worker is where Twingate is, as with Active Directory's Test.
    - They show the same lines as before. If no worker answers within 45 seconds, they say "The worker did not answer in time — is it running?"
    - "Nessus isn't set up" and "the secret key can't be decrypted" still come back at once.
    - Aikido is unchanged (a cloud service).

    Before the fix I checked from the staging worker: nessus.moneypenny.local resolves through Twingate, and port 8834 answers.

    To try on staging once deployed: Integrations ▸ Nessus ▸ Test should say the Nessus version and how many scans the key can see. Then Refresh on Configure lists the scans.
- id: 01M60WQ6PH6HDKB59PS4BHZYEJ
  author: Steve Vine
  at: 2026-10-28T09:16:06.73691Z
  text: |-
    On staging since 09:15 GMT (084af128, deployed with COM-1390 and COM-1383).

    Checked on the staging worker: Test now reaches nessus.moneypenny.local. The next stop is the server's certificate: "certificate verify failed: unable to get local issuer certificate".

    The server still has the certificate Nessus installs with:
    - issued to "Nessus" by "Nessus Certification Authority", with no name for nessus.moneypenny.local;
    - expired 30 Jan 2023.

    Pasting that CA on the tile won't pass either check. For Steve: give the server a new certificate (on the Nessus host, `nessuscli mkcert` with hostname nessus.moneypenny.local, then restart Nessus, or one from the internal CA). Then paste the CA certificate (Linux: /opt/nessus/com/nessus/CA/cacert.pem; Windows: C:\ProgramData\Tenable\Nessus\nessus\CA\cacert.pem) into the tile's "CA certificate" box and press Test.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Sprint 92, Vulnerabilities - Scanner sources. Found by Steve setting up Nessus on staging.

## What's wrong

On the Nessus tile, **Test** said "Compass couldn't reach the Nessus server: [Errno -2] Name or service not known", although Twingate reaches the server. The scheduled Nessus reads work; the buttons don't.

## What changes

- **Test** and **Refresh** (the list of scans on the Configure tab) ask the background worker to talk to Nessus, as Active Directory's Test already does. They then show its answer.
- The person sees the same lines as before, or "The worker did not answer in time — is it running?" if no worker answers.
- Aikido is unchanged: it is a cloud service, reachable from anywhere.

## Notes (technical)

On staging `networkAddon.targets` is `[worker]`: the Twingate sidecar lives only in the worker pod. `POST /integrations/nessus/test` and `POST /integrations/nessus/parts/refresh` called `nessus.*` in the API pod, which can't resolve `nessus.moneypenny.local`. I checked from the worker: it resolves it (100.102.139.169) and reaches TCP 8834. The fix is Celery tasks in `tasks/scanner_health.py`, awaited with `apply_async().get(timeout, propagate=False)`, as in `active_directory.py`'s test route.

**Chain:** independent (no migration, no API shape change).

**Done when:** Test on the staging Nessus tile reaches nessus.moneypenny.local and says what the key can see.