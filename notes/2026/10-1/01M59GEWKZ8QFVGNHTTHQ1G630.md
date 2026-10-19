---
id: 01M59GEWKZ8QFVGNHTTHQ1G630
created: 2026-10-19T07:19:19.423218Z
updated: 2026-10-19T07:55:02.89378Z
type: task
title: CI stops measuring code coverage on every run, since nothing reads or gates on it, so the Python tests run faster
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1108
sprint: sjlj05e
assignee: steve
label:
- improvement
priority: high
task_status: active
---
Sprint 77, CI / Build optimisation. Raised 2026-10-19 from the review of sprint 77's tasks. Start after sprint 76 is on staging.

## Why

`app/backend/pyproject.toml` puts `--cov=compass_api --cov-report=term-missing` in pytest's `addopts`, so every run (unit, integration, local) traces every line and branch, and prints a 69,000-statement report at the end. Nothing reads that report and nothing gates on it: ADR 0016 chose pragmatic testing with no coverage gate. Tracing typically adds 10–30% to a Python test run, and here it's paid on the integration job (the PR's critical path) on every PR.

## What changes

- CI's backend test jobs run without coverage.
- Coverage is still one flag away for anyone who wants it locally, and stays available as an occasional report.
- Nothing about what is tested changes.

## Notes (technical)

- Simplest: drop `--cov*` from `addopts`, keep `pytest-cov` and the `[tool.coverage.*]` config, and document `uv run pytest --cov=compass_api` in the backend README. Alternatively keep `addopts` and pass `--no-cov` in `ci.yml`. Pick one and say why in the PR; the first also speeds up local runs.
- Optional: a weekly scheduled workflow run that reports coverage as a job summary, if a coverage figure is wanted at all. Leave it out unless it's cheap. It must not gate anything (ADR 0016) or add a coverage-% gate (hard rule).
- Measure: run the unit and integration jobs with and without coverage on the same commit (CI, both) and record the times in the PR.
- Check nothing else depends on `.coverage` files (Sonar, artifacts, scripts).

**Done when:** CI's backend test jobs run without coverage, the before/after times are in the PR, and coverage can still be run locally with one documented command.