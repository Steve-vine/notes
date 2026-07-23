---
id: 01KY6WZPNVNS5G3MHHTV6SHT9A
created: 2026-07-23T07:10:37.243463Z
updated: 2026-07-23T11:04:51.918174Z
type: task
title: Repo scaffolding & governance baseline
task_status: done
comments:
- id: 01KY6WZZZM2E44ZA9PDGB18KAW
  author: Steve Vine
  at: 2026-07-23T07:10:46.771919Z
  text: |-
    Steve Vine · 2026-06-19:

    **Done building — in review.**

    **What was done**
    - `README.md` — one-liner (from mission brief), status, repo-layout pointers (`brief/`, `decisions/`, `CLAUDE.md`), how work is tracked, links to ADR 0007 + ways-of-working.
    - `.gitignore` — added Secrets (`.env`, `.env.local`) and Logs (`*.log`); annotated that Tauri/Rust-specific paths land in DEV-478 and `Cargo.lock` is committed deliberately.
    - `.github/workflows/ci.yml` — placeholder `lint`/`build`/`test`/`typecheck` jobs (ADR 0007 gate categories), on PR + push to `main`.
    - **Branch ruleset on `main`** (via GitHub API, ruleset #17900300): PR required to merge, **squash-only** merges, **admin bypass allowed**.

    **Decisions / things to know at review**
    - Branch protection is a **repo ruleset** (not classic protection) with admin bypass — documents intent + blocks accidental direct pushes without blocking solo work. As a bonus it enforces ADR 0007's squash-only strategy at the platform level.
    - CI jobs are intentional **placeholders** — no app code yet; M1/DEV-478 replaces each echo with real commands. Verified: all four jobs ran and **passed** on PR #2.

    **PR:** https://github.com/Steve-vine/notula/pull/2
    **Branch:** `brief-476-repo-scaffolding-governance-baseline` · commit `da9a719`
imported_from: linear
assignee: steve
priority: medium
project: 01KY6W9951TW0904DT0GGJVGE7
number: 1
sprint: s14yww4
---
Get the repo to a clean, contributable baseline before brief work starts.

**Checklist**

- [X] Add `README.md` — short quickstart + pointers to `brief/` and `decisions/`
- [X] Review `.gitignore` for Tauri/Rust + JS frontend build artefacts
- [X] Enable branch protection on `main` (PRs required, no direct push)
- [X] CI skeleton — a lint/build workflow stub (filled out per stack as M1 lands)

**Done when:** repo has a README, protected `main`, and a CI workflow that runs on PRs.

---

### Agreed approach (planned 2026-06-19)

1. **README.md** — one-liner (from mission brief), current status (early dev, MVP arc), repo-layout pointers (`brief/`, `decisions/`, `CLAUDE.md`), and a "no app yet — code lands in M1" note + how work is tracked (briefs in Linear, ADRs in `decisions/`).
2. **.gitignore** — already covers OS/IDE/Claude-local + `node_modules`/`dist`/`build`/`target`. Added secrets (`.env`, `.env.local`) + `*.log`; kept `Cargo.lock` tracked; Tauri-specific paths deferred to DEV-478.
3. **CI skeleton** — `.github/workflows/ci.yml`, runs on PR + push to `main`, four placeholder jobs **lint/build/test/typecheck** per ADR 0007; real commands wired in M1 (DEV-478).
4. **Branch protection** — GitHub **repo ruleset** on `main`: PR required to merge, squash-only, **admin bypass allowed**.

**PR:** [https://github.com/Steve-vine/notula/pull/2](https://github.com/Steve-vine/notula/pull/2)

---

Linear DEV-476 · M0 — Brief, decisions & project setup · created 2026-06-19 · done 2026-06-19