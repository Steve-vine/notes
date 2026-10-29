---
id: 01M64G1CHKNZZDT7QSDRVFH92V
created: 2026-10-29T18:51:26.643378Z
updated: 2026-10-29T19:52:57.902052Z
type: task
title: 'Install guide and version point at the old registry: releases are now 0.16.0 under ghcr.io/rootcause-it'
project: 01M32Q7WT6058ZQFMMRM8KP1K6
number: 22
sprint: sstqjgj
comments:
- id: 01M64GDDH3PWG62KYS6DA6H7XV
  author: Steve Vine
  at: 2026-10-29T18:58:00.867455Z
  text: |-
    Pushed to staging (1c05807). Not deployed: the live site keeps showing 0.7.0 until main is moved.

    What changed:
    - The version lookup, the chart address and the image names now point at ghcr.io/rootcause-it/compass. The build picks up 0.16.0, and the fallback is 0.16.0. Nothing in the built site mentions steve-vine any more.
    - Configuration page, re-checked against the v0.16.0 chart and Admin screens:
      - Sizing figures now match the chart and the install guide (2.5 GB / 5 GB; the page said 2 / 4).
      - Added the worker's new status container (it feeds System status).
      - Added a "Network add-on" section, for reaching on-premises domain controllers.
      - The seed Job's list now includes house style, policies and standards, and the data subject request rules and letter templates.
      - Removed the Appearance tab, which no longer exists.
      - Rewrote Integrations as the seven cards now on the screen: Directory setup (AD only / Hybrid / Entra ID only), Microsoft 365, Entra ID access, Exchange Online, Active Directory, Entra ID sign-in, AWS identity.
    - Overview and home page: Access Control is no longer described as Entra ID only.
    - CLAUDE.md: the registry and directory facts are updated.

    The Install and Upgrading pages needed nothing beyond the registry address. The chart's install steps are unchanged since 0.7.0.

    To look at: /docs/install/ (version 0.16.0, rootcause-it address), /docs/configuration/ (Sizing, Network add-on, Inside the app ▸ Integrations), and the Access Control card on the home page.

    Not done here: the overview still describes the product as it was at 0.7.0. It doesn't mention SAP, Incidents, Attestations, Data Subject Requests, Actions or System status. Nothing it says is false any more, but it is incomplete. The Operators Manual sections will cover those features.
- id: 01M64KJ19EEJBV2T3VG3AAKVHF
  author: Steve Vine
  at: 2026-10-29T19:52:57.901892Z
  text: One more fix pushed. The Install and Upgrading pages read the admin password and the session key from a Secret named "compass". The chart has always called it "<release>-secrets", i.e. "compass-secrets", so those two commands never worked. Found by following the evaluation install word for word on a fresh 0.16.0 on g5. Apart from this, the install went through as written.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Since the move to RootCause-IT, Compass releases publish to `ghcr.io/rootcause-it/compass` (chart `oci://ghcr.io/rootcause-it/compass/charts/compass`). The latest release is v0.16.0 (2026-10-20). The site still points everything at `ghcr.io/steve-vine/compass`, where the newest version is 0.7.0. The version lookup, the install commands and the image names are all stale, so a visitor following the install guide gets a version nine releases old.

Fix: point `src/lib/release.ts` (lookup, images, fallback) and every page at the new registry; diff `chart/README.md`, `values.yaml` and `NOTES.txt` between v0.7.0 and v0.16.0 against Install, Configuration and Upgrading; re-check the home page and the overview for claims that changed; update the checked facts in CLAUDE.md.