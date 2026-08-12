---
id: 01KZVE8EZ8P43WHXYWS2HS4T5X
created: 2026-08-12T16:53:00.520062Z
updated: 2026-08-12T16:54:01.185013Z
type: task
title: Best-practice defaults & guidance for vuln-management workflows (proxied, severities, scan granularity)
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 215
sprint: sp88phy
assignee: steve
imported_from: linear
label:
- tech_debt
priority: medium
task_status: done
---
Found diagnosing the `vul-scan` run `91b7f09c`. There are no per-workflow best-practice guardrails, and several engine defaults are wrong for a vuln scan. Codify the conclusions as a short doc + a review of seed-CR defaults / UI hints.

### Concrete findings to encode

1. **Proxied filtering by scan layer.** IP-dependent steps (port-scanner, service-detection) should run on **non-proxied** records — Cloudflare-proxied hosts resolve to the edge a…

---

*Excerpt — full description in Linear.*

Imported from Linear [DEV-567](https://linear.app/stevevine/issue/DEV-567/best-practice-defaults-and-guidance-for-vuln-management-workflows)