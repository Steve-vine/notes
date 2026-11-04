---
id: 01M6HK9XH4C9SWTB3X48YKWPGS
created: 2026-11-03T20:58:39.524682Z
updated: 2026-11-04T07:45:43.107239Z
type: task
title: 'ADR: Initiatives — a named piece of work in one company, owned by one person, that gathers controls with their gaps, risks, decisions and content, shows their actions, and measures progress as the share of its actions finished'
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1552
sprint: snyzymp
comments:
- id: 01M6HMG1V6FDRCK197JAQXC46C
  author: Steve Vine
  at: 2026-11-03T21:19:29.125864Z
  text: |-
    Done: PR #1566 merged (718323b7).

    `decisions/0140-initiatives.md` records the rules agreed on 2026-11-03:
    - one company and one owner per initiative;
    - controls bring their gaps, risks, decisions and content, kept live;
    - risks, decisions and content can be added directly, and linked items left out;
    - Requires review for controls and content;
    - percentage complete is the share of the initiative's actions finished;
    - the Actions tab, plus "Initiative · Deliver" for the owner;
    - finishing keeps a snapshot;
    - View/Manage initiatives permissions.

    CLAUDE.md's key-ADR list now names 0140.
assignee: steve
label:
- feature
priority: high
task_status: done
---
Sprint "Initiatives - New Feature". Write ADR 0140 recording the rules Steve agreed on 2026-11-03.

## The rules

- **What it is.** An initiative is a named piece of work, such as "Ransomware readiness". It has a description, one **owner** (a person) and an optional **target date**. It belongs to **one company**, because assessments, gaps and risks are per company. Its reference is INI-N.
- **Menu.** Initiatives is a new menu item directly below Actions in Overview. It's company data, so it carries the Company gate.
- **What's in it.**
  - You add **controls**. Each control brings everything linked to it: its gaps, the risks linked to it, decisions linked to the control or to those risks, and content linked to it (including its domain's policy, ADR on policies bound by domain membership).
  - What a control brings stays **live**. A gap raised on the control next month appears in the initiative by itself.
  - You can also add a **risk, decision or content item directly**, without a control.
  - You can **leave out** a linked item that isn't part of this piece of work, and put it back later. Left-out items are listed, not hidden.
- **Owners.** The initiative's owner is responsible for the whole. Each item keeps its own owner: the control's assessment owner, the gap or risk owner, the content's reviewers. Decisions are reference only and have no owner (decided against on 2026-11-03).
- **Requires review.** When you add a control or a content item, you can mark it **Requires review**, with a due date that defaults to the target date (or 30 days if there is none).
  - The review lands on the owner's Actions list with the reason "Part of initiative INI-3 · Ransomware readiness".
  - It follows the pattern of a runbook sent back for review by a failed exercise (COM-1412).
  - A review that's already scheduled is brought forward, never duplicated.
  - Two initiatives asking for the same review share one action, showing both reasons.
  - Recording the review clears it.
- **Percentage complete.** The initiative's actions that are finished, divided by all its actions (finished and open). Each one counts the same.

  | Item | Counts as | Done when |
  |---|---|---|
  | Gap | Remediate | complete (a cancelled gap drops out of the count) |
  | Risk with no treatment plan | Create a treatment plan | a plan exists, or the risk is accepted or closed |
  | Each treatment plan | Complete | done (a cancelled plan drops out) |
  | Control marked Requires review | Review | reviewed after being marked |
  | Content marked Requires review | Review | reviewed after being marked |

  The following are **not counted**: decisions; controls or content not marked for review; repeating reviews (a risk's routine review never finishes); and anything already finished when it joined.

  The percentage **can go down** when new work arrives. That's intended, because it shows the work as it really stands.
- **Actions.** The initiative page shows every open action on its items, routine reviews included, even though those don't count. Under ADR 0137, an open initiative is itself one action for its owner: "Initiative · Deliver", due on the target date.
- **Finishing.** The owner can mark the initiative **Complete** or **Cancelled** at any time. It then keeps its percentage and item list as they stood, and is read-only until reopened.
- **Who can do what.**
  - Two new permissions, *View initiatives* and *Manage initiatives*. The built-in Admin gets both; the starter roles stay frozen.
  - The owner can edit their own initiative.
  - Working an item from the initiative needs that item's own permission (assessing needs *Assess*, and so on). An initiative grants nothing.
  - Content and decisions are shared by every company, so reviewing content from an initiative counts for every company, as it does today.

**Chain:** independent (an ADR only).

**Done when:** `decisions/0140-initiatives.md` is merged, and CLAUDE.md's key-ADR list names it.