---
id: 01M755WSQHPBTHYCAAM4ZTW4ST
created: 2026-11-11T11:29:06.801738Z
updated: 2026-11-11T14:00:25.412949Z
type: task
title: A feed's findings show their source as the service and feed ("Nessus · Findings"), never its internal name ("f:40ee2489")
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1725
sprint: sep79bz
comments:
- id: 01M75CS1H8VK18GRFR17PD8SAK
  author: Steve Vine
  at: 2026-11-11T13:29:23.752385Z
  text: |-
    Built and merged to main (PR #1723, 2026-11-11). On the chain: the API gains a list of the sources a company's vulnerability screens may name, with their names. Goes to staging with the sprint.

    What changed:
    - No screen keeps its own list of sources any more. Names come from the server, so a new feed is named without a code change.
    - A feed's source reads as its service and feed, e.g. "Nessus · Findings":
      - the Register's source marks, Source filter and CSV export;
      - the Overview's "Open by source";
      - a vulnerability's Sources table;
      - the matching rule window's "From" list.
    - The Source filter offers every feed that can bring the company findings, even ones with none yet.
    - A renamed service or feed shows its new name within 5 minutes. A deleted feed's findings say "A deleted Collection feed".
    - A rule limited to a feed, and "Fixed — waiting for … to confirm", now name the feed rather than "f:…".
    - Polaris's vulnerability tools give sources by name, and accept a source by name (feeds included) when filtering reads or saving a rule.
    - Small wording change: the rule window's "Pen tests" is now "Pen test", as everywhere else.

    Tests: a feed integration test (named before its first run, not offered to another company, rule description, waiting-for, rename, delete), the assistant tools' names in and out, and the Register, Overview and vulnerability page with a feed source on screen.

    To check on staging after the deploy: Nessus findings in Test Company show "Nessus · Findings".
- id: 01M75EHVJ4Q7EDRPWRQW025GKH
  author: Steve Vine
  at: 2026-11-11T14:00:25.412731Z
  text: |-
    Pre-UAT on staging (bb59b9a2), 2026-11-11: **Passed** through the assistant tools; the screen is for Steve.

    Test Company's latest reads now name the feed "Nessus · Findings (read by a Collection feed)", where they used to say f:40ee2489. The E2E Test Company has no feed findings, and its accounts can't open Test Company, so I couldn't check the screens there.

    Steve: look at Vulnerabilities in Test Company: the Register's source marks and Source filter, the Overview's Open by source, and a Nessus finding's Sources table.
assignee: steve
label:
- bug
priority: high
task_status: review
---
Found by Steve on staging 2026-11-11, after the Nessus Findings feed's first run brought in 13,026 findings (COM-1714). The Vulnerabilities screens show its source as "f:40ee2489".

The screens name sources from a fixed list built into the page (Nessus, Aikido, the pen test…). A Collection feed's source (ADR 0147 §5, COM-1698) isn't in it, so its internal name shows. The server already names a feed's source "<service> · <feed>" and uses that in activity history and "Accepted by …". The screens never ask for it.

**Chain:** on the chain (the API gains the sources' names)

## Where it shows
- the Register: each row's source marks, and the Source filter;
- the Overview: the latest reads table;
- a vulnerability's page: the table of who has seen it.

## What the person sees
- Everywhere a source is named, a feed's reads as its service and feed, e.g. "Nessus · Findings" or "Aikido · Issues in containers". Fixed sources keep their names.
- A renamed service or feed shows its new name within a few minutes. A deleted feed's findings say "A deleted Collection feed".

## Done when
- Each place above shows the feed's name, tested with a feed source on screen.
- No screen keeps its own list of sources: the names come from the server, so a new feed is named without a code change.