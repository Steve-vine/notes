---
id: 01M617FMQRNEVX4NQZTQYYD42Q
created: 2026-10-28T12:24:13.30477Z
updated: 2026-10-28T18:16:56.1954Z
type: task
title: Placing an Unmatched item says what reached the register — and when every finding is informational, says why nothing did and where to change that
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1392
sprint: ssp4evc
comments:
- id: 01M61G56JQTG9SQMY1PD7YYPMG
  author: Steve Vine
  at: 2026-10-28T14:55:48.311064Z
  text: |-
    Done. PR #1409, merged to main at f3e5b78d. Going to staging with the other six.

    A message now says what happened after any of these:
    - placing an Unmatched item
    - making an asset for it
    - saving a rule that places items
    - attaching a cloud resource in Inventory

    It reads, for example, "3 vulnerabilities added to Web shop", "2 added to Web shop, 1 already in the register" or "No vulnerabilities added to …". When informational findings stayed out, a second line says "26 informational findings kept out of the register — the company's vulnerability settings can bring them in", with an "Open the settings" link to Vulnerabilities ▸ Settings.

    Before you place anything, the Place and Make a technology asset windows show a yellow "Nothing will reach the register" note when every finding is informational and the company leaves them out. It links to the same setting.

    My calls (yours to overturn):
    - The message is a pop-up, staying about 15 seconds when it mentions informational findings, rather than a banner on the screen.
    - In Inventory the pop-up names the setting but has no link.
    - Saving a rule says nothing if it placed nothing.
    - Polaris's place, rule and attach tools now report the same counts.

    To check on staging: place a Nessus item that has only informational findings, for Test Company.

    Technical: `kept_out` added to the place response; `new`, `matched` and `kept_out` added to the rule-save response; an optional `vulnerabilities` block added to Inventory's attach and make-asset responses. Read summaries are unchanged. No migration.
assignee: steve
label:
- improvement
priority: medium
task_status: done
---
Sprint 92, Vulnerabilities - Scanner sources. Builds on the Unmatched task (COM-1375). Found by Steve on staging, 2026-10-28, while testing sprints 90–93.

## What happened

On Unmatched, Steve made a technology asset for the Nessus item **companiesmadesimple.com** (Test Company). The asset appeared in Inventory, but nothing appeared in the register.

That is the rule working: all 26 of the item's findings are **informational**, and informational findings stay out of the register unless the company has switched on bringing them in. Test Company has it off. Nothing was lost — the findings are kept, and switching the setting on brings them in.

The problem is that the screen says nothing. The item leaves Unmatched, the dialog closes, and the person is left to work out why the register is unchanged. Its findings can't be seen anywhere once it's placed, because Unmatched lists only unplaced items.

(The same Cloudflare address range has other items that do carry one medium each, all "HSTS Missing From HTTPS Server": londonpresence.com, login.msg.cool and mailroom.msg.cool. They're still on Unmatched.)

## What people should see

- **After placing an item or making an asset from it**, a message says what happened, for example "3 vulnerabilities added to companiesmadesimple.com" or "2 added, 1 already in the register".
- **When some or all of its findings are informational and the company leaves them out**, the message says so: "26 informational findings kept out of the register — the company's vulnerability settings can bring them in", with a link to that setting.
- **Before placing**, the Place and Make an asset dialogs say the same thing ahead of time when every finding is informational, so the person isn't surprised.

## Notes

- The place action already works out how many vulnerabilities it adds or matches; the screen just doesn't show it.
- Rule-based placing (Save as a rule) and attaching in Inventory (cloud resources, sprint 93) place items too. They should say the same thing where they show a result.