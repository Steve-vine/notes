---
id: 01KZVBB10QJZA2KCEGSNFH69BC
created: 2026-08-12T16:01:58.807958Z
updated: 2026-08-12T16:01:58.807958Z
type: task
title: 'setup.sh: nerdctl.toml idempotency check always rewrites (trailing-newline comparison)'
imported_from: linear
priority: low
assignee: steve
task_status: backlog
project: 01KZV767QMFTN9CZ3TPGTSAASD
number: 113
---
Observed during DEV-295 / Brief 069 testing (pre-existing, from Brief 064/068's `setup.sh`).

`scripts/bootstrap/setup.sh` (\~lines 191–197) decides whether to rewrite `/etc/nerdctl/nerdctl.toml` by comparing `"$(sudo cat /etc/nerdctl/nerdctl.toml)"` against an expected body. Bash command substitution strips trailing newlines from the LHS but the expected body retains its trailing `\n`, so the equality check is always false and the file is rewritten on every run — emitting `[ok] wrote /etc/nerdctl/nerdctl.toml` instead of `[skip]`.

Cosmetic only — the written content is byte-identical — but it breaks the idempotent-`[skip]` contract the rest of the script follows.

Fix options: compare with `grep -q` on a stable marker (e.g. `k8s.io`), or `cmp` the expected body written to a temp file, rather than string-comparing command-substitution output.

---

Imported from Linear [DEV-298](https://linear.app/stevevine/issue/DEV-298/setupsh-nerdctltoml-idempotency-check-always-rewrites-trailing-newline)