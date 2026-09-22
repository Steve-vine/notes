---
id: 01M32YZRFHPYP8P728Q6AHZHEF
created: 2026-09-21T21:47:07.633075Z
updated: 2026-09-22T21:15:17.717159Z
type: task
title: Write the Configuration and Upgrading docs pages
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 3
comments:
- id: 01M35ES840HYEVXG0G0BMJXPBG
  author: Steve Vine
  at: 2026-09-22T21:01:40.352225Z
  text: |-
    Pushed to staging. git pull only.

    What to look at: /docs/configuration/ and /docs/upgrading/.

    Configuration opens with the distinction that matters - values file (what the cluster needs before a pod starts) versus Admin screens (what an administrator decides once it is running; a saved setting beats the environment). Then "Things that must not change" (SESSION_SECRET_KEY, bundled DB name/owner, volume sizes, name overrides), the values reference grouped by sizing / images / the Secret / application settings / attachment volume / bundled services / reaching it / Jobs / identity and security, the Admin tabs in on-screen order, the three Integrations cards, Email, and pre-seeding by environment variable.

    Upgrading: before you start (back up, know the key, note the version, pick a quiet moment), the command and the five things that happen in order, how to check, what to do when the migration fails or the pods will not start, the two one-off commands, and what to back up.

    Four things worth knowing, all verified in the code rather than the README:
    1. config.email.* is a one-shot seed, not live configuration: read once by the seed Job, only when no transport exists, and it cannot carry SMTP credentials. The page says to set up email on the Admin screen. values.yaml describes it as if it were live - worth a COM task to fix the comment.
    2. The schema migrates while the previous release's pods are still serving, and nothing documents whether that overlap is safe. The page says to treat the rollout as a short maintenance window rather than promising zero downtime. If migrations are in fact written to be compatible, tell me and I will soften it.
    3. helm rollback returns pods but not the schema; alembic downgrades exist but are not an operator path. The page says the database backup is the way back.
    4. There is no changelog anywhere and GitHub release bodies are generated boilerplate. The page says so plainly. A release-notes habit (even a line per release) would let the site carry them.
    Also: the chart README says 2.5 GB / 5 GB for the two sizes; values.yaml says 2 GB / 4 GB. The pages use the values.yaml figures.

    Technical: src/content/docs/docs/configuration.mdx and upgrading.mdx; both pull the release version from src/lib/release.ts.
assignee: steve
label:
- feature
priority: medium
task_status: done
---
Both pages are linked from the site footer and the docs sidebar, and both are empty stubs.

Configuration: the settings an operator chooses - sizing, database, attachment storage, public URL, mail, the Vendor Portal's address, Entra ID sign-in - saying which are set at install time and which inside the app.

Upgrading: how to move to a newer release, what happens to the database, how to check it worked, and how to roll back.

Done when: each setting and step has been checked against the chart and the app, not written from memory.

Technical: src/content/docs/docs/configuration.md and upgrading.md. Source is chart/values.yaml, chart/README.md ("upgrade" section) and the release workflow in the app repo. Follows the install guide.