---
id: 01M755WSQHPBTHYCAAM4ZTW4ST
created: 2026-11-11T11:29:06.801738Z
updated: 2026-11-11T11:29:09.237396Z
type: task
title: A feed's findings show their source as the service and feed ("Nessus · Findings"), never its internal name ("f:40ee2489")
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1725
sprint: sep79bz
assignee: steve
label:
- bug
priority: high
task_status: todo
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