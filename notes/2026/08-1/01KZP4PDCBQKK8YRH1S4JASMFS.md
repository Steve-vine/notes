---
id: 01KZP4PDCBQKK8YRH1S4JASMFS
created: 2026-08-10T15:29:39.723389Z
updated: 2026-08-10T15:29:39.723389Z
type: task
title: Downgrading below the threshold is a mute wearing a severity edit's clothes
assignee: steve
label: improvement
priority: medium
task_status: backlog
project: 01KX671DATY39VW6GWK3M2T3DN
number: 637
---
Raised 2026-08-10 out of [ISE-635]. A downgrade that lands below the auto-incident threshold is not a severity edit — it is "stop opening incidents for this class of signal", which is exactly what Ignore and Silence do. The difference is that those two say so and this one does not.

**The three tools are one decision spelled three ways.** In `promotion.py:200-213` they are consecutive `continue`s and a False from `should_auto_open` — the same outcome by four routes (ignore / silence / suppression / below threshold). Only the first three read as mutes to the operator who set them.

The asymmetry runs through the whole surface:

- **Reason**: Ignore and Silence carry a required reason *and* it is rendered — `suppression.reasons_for_findings` exists precisely to show "suppressed: <reason>" on the row. A downgrade's reason is stored and shown nowhere.
- **Trace**: Ignore and Silence mark the signal itself, so the Alerts row can say it is muted. A downgrade leaves the signal untouched — nothing on the row changes, which is the [ISE-635] invisibility.
- **Blast radius**: Ignore and Silence hit one signal. A downgrade hits every signal of that kind on that system ([ISE-636]).

So the one with the widest reach is the one that announces itself least.

**Scope** — make the act match its effect rather than its mechanism:
- When the chosen severity falls below the current auto-incident threshold, say so in the confirmation before the click: this will stop incidents opening, for this many signals, until it is removed. The threshold is already readable (`get_incident_policy`, `severity_api.py:122`), so the dialog can compute it rather than describe it abstractly.
- A signal held below the bar by an override should read as muted on the Alerts row, with the reason, the same way a suppressed observation does.
- Consider whether "downgrade to below threshold" should simply *be* the mute action, with a real severity re-grade (High→Medium, still above the bar) as the separate, quieter thing it actually is.

**Not in scope**: removing the capability. Muting a noisy class is legitimate and ADR 0026 §4 put the tool where the noise appears on purpose. The complaint is only that it is the quietest of the four mutes while being the loudest in effect.

**Acceptance**: choosing a severity below the threshold warns, with the count it will affect; a signal silenced by an override says so on its row with its reason.