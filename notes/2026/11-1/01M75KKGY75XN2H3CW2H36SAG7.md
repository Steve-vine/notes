---
id: 01M75KKGY75XN2H3CW2H36SAG7
created: 2026-11-11T15:28:42.951958Z
updated: 2026-11-14T17:05:13.018735Z
type: task
title: A pen-test finding marked "Check this" says what to check and why
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1735
comments:
- id: 01M75WDJZE232GRCHXYA00ZTBD
  author: Steve Vine
  at: 2026-11-11T18:02:45.614267Z
  text: |-
    Done. PR #1728 (auto-merge on; migration 0811).

    What you see:
    - On a pen-test import page, a finding Polaris flags "Check this" shows its reason under the flag, followed by a "See page N" link. The link moves the report viewer to that page.
    - The reason stays after the finding is opened or edited, and the confirmed import still shows it. It isn't copied onto the vulnerability.
    - Retest outcomes Polaris flags carry a reason the same way.
    - Findings already flagged in production (the two on the external test) have no reason. They still show "Check this" without text.

    Polaris:
    - `vulnerabilities_propose_pentest_findings` and `vulnerabilities_propose_retest_outcomes` now take `check_reason`.
    - It is required for "check" and refused for "clear". A refused batch saves nothing.

    One change to know about: on a retest, if you pick an outcome yourself after Polaris flagged it, the flag and its reason now stay on the record (before, your choice removed the flag). Confirm still unlocks when you've looked at it.

    Checks:
    - backend: ruff, mypy, unit suite (2,183) and the pen-test integration tests all pass;
    - frontend: eslint, tsc and prettier are clean, and the import page tests pass 7 of 7;
    - schema.d.ts regenerated.
- id: 01M76B2JQ610Z8H6Y9WDVCSV9E
  author: Steve Vine
  at: 2026-11-11T22:18:53.542561Z
  text: |-
    Passed (Claude's pre-UAT pass, staging fcaf1d13, as E2E Admin A in E2E Test Company).

    Steps:
    1. Imported a 3-page test report through Vulnerabilities ▸ Import ▸ Pen-test report.
    2. Without Polaris's AI provider, posted findings to the import the way Polaris's vulnerabilities_propose_pentest_findings does. The tool sends exactly this request.

    Seen:
    - **Refused:**
      - a "check" finding with no reason ("say why it needs checking…");
      - a "clear" finding with a reason ("a finding read clearly has nothing to check…");
      - a batch with one good and one bad finding: nothing was saved.
    - **Shown on the import page:** a "check" finding with the reason "The text says three web servers but only one host is listed. Confirm the hosts with the tester." showed under CHECK THIS, followed by "See page 2". Clicking it moved the report viewer to page 2.
      - The viewer itself is blank in this headless browser because its PDF plugin is blocked. That's the test browser, not Compass.
    - **Kept after editing:** after I edited that finding, the flag read CHECKED and the reason stayed.
    - **Kept after confirming:**
      - the confirmed import still shows the reason;
      - the two VULs it made (VUL-2, VUL-3) don't carry it.

    Not checked: retest outcomes with a reason. They take the same field, but they weren't in "Done when".

    Steve may want to see Polaris write a real reason on a real report, which needs the AI provider.

    Screenshots: ~/compass-uat/sprint0-2026-11-11/COM-1735/ (check-reason-shown.png, confirmed-import-keeps-reason.png)
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Steve, 2026-11-11, confirming the external pen test import. Polaris proposed 13 findings and flagged two "Check this". The import page showed the flag, but not why, so he had to ask what he was meant to be checking. Polaris knew the reasons when it proposed them:
- Finding 10: the text says three web servers, but only one host is listed.
- Finding 12: the affected assets are private 192.168.6.x addresses, so the vulnerability belongs on the public DNS records or the systems behind them.

**Behaviour wanted**
- **A reason with every flag.** A finding flagged "check" carries a short reason: what was inferred or unclear, and what the person should look at. Examples: "The text says three servers but only one host is listed. Confirm the hosts with the tester." "The severity isn't stated, so it was inferred from the CVSS score."
- **Shown with the flag.** The import page shows the reason next to "Check this", with a link to the page it is on, so the person can read the report beside it. It stays visible until the finding is confirmed or dropped. Editing the finding doesn't clear it.
- **Required from the assistant.** `vulnerabilities_propose_pentest_findings` gets a `check_reason` field. It is required when confidence is "check" and refused when it is "clear". The tool's description says the reason is shown to the person, so write it for them. The same applies to retest outcomes (`vulnerabilities_propose_retest_outcomes`) where they have a confidence.
- **Kept afterwards.** Once a finding is confirmed, the reason is kept with the import's record of the finding, so a later reader can see what was queried. It isn't copied onto the vulnerability.

**Done when:**
- A "check" proposal without a reason is refused.
- The import page shows the reason and its page link beside the flag.
- The confirmed import still shows it.
- Tests cover the tool and the page.

Related: COM-1378 (pen-test import), COM-1734 (Imports tab).