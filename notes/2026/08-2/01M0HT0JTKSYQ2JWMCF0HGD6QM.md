---
id: 01M0HT0JTKSYQ2JWMCF0HGD6QM
created: 2026-08-21T09:21:42.739097Z
updated: 2026-09-01T13:55:50.905016Z
type: task
title: Audit integration-test fixture cost
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 333
sprint: sspwpgk
comments:
- id: 01M0JXM330SBCR0869P09NNASG
  author: Steve Vine
  at: 2026-08-21T19:44:02.144279Z
  text: |-
    Done — PR #321, squash-merged to main 2026-08-21.

    Profiled the whole suite with --durations=0 first, and the answer was not where the task expected:

      setup      646s   58%
      call       386s   35%   <- the tests themselves
      teardown    83s    7%

    The tests are barely a third of their own runtime. Within that setup, create_app() alone is 431ms called once per test — 263s, 41% of it. A cProfile run shows every millisecond is FastAPI constructing 336 routes and their pydantic TypeAdapters. Nothing inside it can be made faster; the only lever is to stop doing it 609 times.

    Which turns out to be free, because THE APP NEVER BOUND THE DATABASE. get_engine() is an lru_cache'd module-level function resolved lazily per request, so the per-test database is chosen by the cache_clear() every fixture already does — not by rebuilding the app. The rebuild bought nothing.

    Two conditions make sharing sound, and both were checked rather than assumed. No test mutates the app: no dependency_overrides, no add_route, no middleware added after construction, anywhere in tests/. And the app's shape depends on exactly four settings — database_url, session_redis_url, broker_url with readyz_broker_check_enabled, and metrics_enabled — of which every app fixture sets the first two and none touches the last.

    With one exception, which is why this is not a blanket rewrite: test_celery.py sets BROKER_URL, registering an extra readiness check and genuinely changing the app's shape. It keeps calling create_app() directly, and tests/app_factory.py's docstring states the rule and the exception so the next person does not tidy it away.

    609 passed either way; 197s -> 90s locally. Both runs shared the node with CI, so the absolute numbers are indicative — the mechanism is the real claim: 263s of the 1115 measured test-seconds stops happening.

    Also documents the intended fixture cost model in conftest (what is per-worker, what is per-test, and that anything per-test is paid 609 times), and corrects a stale claim there: the loadscope rationale still described module-scoped containers, which DEV-855 replaced with session-scoped ones. loadscope is now a balance choice, not a correctness one — which is exactly what COM-331 needed to know.
assignee: steve
label:
- tech_debt
priority: medium
task_status: done
---
Each integration test rebuilds create_app, clears cached singletons, and (verify) may re-run schema setup; the suite added ~25 tests this sprint and the cost multiplies. Profile where per-test seconds go (fixture setup vs test body), move what's safe to per-worker/session scope (schema create, containers are already session-scoped), and document the intended fixture cost model in the test README/conftest.