---
id: 01M1EXC1897JTTJFEVBRBS2XKD
created: 2026-09-01T16:38:22.217814Z
updated: 2026-09-01T21:08:13.325894Z
type: memo
title: ISE Naming Convention
project: 01KX671DATY39VW6GWK3M2T3DN
---
Companion to [[ISE Flow]]. Fixes the vocabulary for the layered model **before** it reaches ADRs and code, where a name is expensive to change.

Three categories, kept deliberately distinct — most confusion in this domain is a **component** being mistaken for the **store** it reads, or for the **object** it produces.

## 1. Components — things that *do*

Named as roles (agent-nouns), so the name says who is responsible.

| Name | Does | Does **not** |
|---|---|---|
| **Integrations** | The only modules that talk to the outside world, in **either** direction — harvesting data, receiving pushed events, and carrying actions and notifications out | Decide anything, schedule themselves, or interpret what they collect |
| **Conductor** | Owns **all** scheduling — not just the Integrations: what runs, how often, and whether it runs at all | Do any work itself, or interpret results |
| **Differ** | The "what's changed" pass. Reads the Signal Store and the Estate, detects signal transitions (new / recurring / recovered) and estate change, and pushes **only what changed** to the Correlator | Talk to the outside world, judge importance, or create Incidents |
| **Correlator** | Determines what a thing really is and how important it is to the business. Decides what to escalate, dedupe or leave alone | Decide *what to do* about it |
| **Oracle** | The brain. Works out what should happen next, using Context and Playbooks. Can pull from any layer below it | Execute anything, or approve anything |
| **Visibility layer** | Collective term for every human-facing surface — Web UI, Reports, Teams, email | Hold logic of its own; it presents what lower layers decided |
| **Actor** | Performs actions passed to it | Choose actions, or decide whether they are safe |
| **Arbiter** | Sits **on the outbound edge, beside the Actor**, and refuses dangerous actions before they reach the Integrations | Judge intent — approval is a separate, earlier question |

The Arbiter is deliberately a wall rather than a step inside the Actor: a step in a sequence can be reordered by a later refactor, an edge cannot. This preserves today's property — the blast-radius check fires *after* approval, so no approver can click past it.

## 2. Stores — things that *hold*

Named as plain nouns. A store is inert: it is written to and read from, and decides nothing.

| Name | Holds |
|---|---|
| **Estate** | Every discovered entity, its properties, tags and relationships |
| **Signal Store** | Alerts and Observations, escalated or not. Backed by the `finding` table — the code name stays, the human name is Signal (ADR 0103) |
| **Business Services & Definitions** | What composes each managed business service, and the definitions that let the Correlator prioritise |
| **Playbooks** | Known responses — engineer instructions, simple actions, or gated sequences |
| **Context** | Supporting material for diagnosis and remediation |

## 3. Objects — things that *exist*

The nouns that flow between layers. Kept separate from layer names on purpose: **Signal** the object is not the Signal Store that holds it.

- **Signal** — the umbrella term. Every Signal is either an Alert or an Observation.
- **Alert** — an external system said something is wrong.
- **Observation** — ISE detected an anomaly or a change in state.
- **Incident** — a Signal the Correlator judged worth escalating. **Escalated = Incident created.** Anything not escalated stays an Alert or Observation and is retained, not discarded.
- **Entity** — a discovered thing in the Estate.
- **Business Service** — what a customer consumes, composed of Applications and Resources.
- **Proposed Change** — a specific mutation awaiting the Arbiter and execution by the Actor.

## Naming rules

1. A **component** gets a role name. If it does something, it is named for who does it.
2. A **store** gets a plain noun. If a name ends up describing both a store and the process over it, split it.
3. A **layer name is never an object name.** Signals sit in the Signal Store; the Oracle is not an oracle result.
4. Prefer the word an operator would use over the word the code uses (ADR 0103 — the domain object keeps its name, nothing a human reads does).

## The flow

Integrations write directly into the **Signal Store**, the **Estate** and **Context** — there is no separate intake stage for signals. The **Differ** then reads the Signal Store and the Estate and pushes what changed to the **Correlator**, which decides what it is and how much it matters, and escalates the worthwhile into Incidents. The **Oracle** works out what should happen, using Context and Playbooks. **Visibility** puts it in front of a human. The **Actor** executes, past the **Arbiter**, back out through the Integrations.

The **Conductor** paces all of it. Upper layers may pull from lower ones at any time.

**Why this fixes the repetition:** because the Differ passes *changes* rather than *state*, a flaking test that is still flapping in the same way produces nothing new to push up — it only reaches the Correlator when it actually transitions. The Correlator's importance judgement then handles the "minor service" half.

**One boundary to pin in the ADR:** today `reconcile_findings` both writes the signal and computes its transition in a single pass. Under this model that splits — the write belongs to the integration path, the transition detection belongs to the Differ. Everything downstream keys off those transitions, so the line matters.

## Retired terms

| Retired | Replaced by | Where the old term legitimately survives |
|---|---|---|
| **Obs Loop** | **Differ** (change detection) + **Integrations** (the outbound observation harvest) + **Conductor** (its cadence) | ADR 0030, which keeps its name — ADRs are superseded, never rewritten. `audit_event` actions `obs_run` (6,447 rows) and `obs_run_requested` (100), which cannot be rewritten: the table is append-only by trigger. `System.obs_detection_enabled` / `obs_interval_seconds` / `last_obs_run_at` until a migration retires them |
| **Signal Queue** | **Signal Store** | draft only — never shipped |
| **Reasoning** (as a layer name) | **Oracle** | ADR 0013 and the `agent_run` task types, which are unaffected |
| **Safety gate** | **Arbiter** | draft only — never shipped |

`obs_loop.py` is not renamed to `differ.py`. Its actual job — dialling out via `connector.detect_observations()` — is an outbound harvest and becomes an ordinary Integration capability; the Differ is new code doing the work that currently sits inside `reconcile_findings` and `drift`.

**Observation** survives untouched as an object name. That is where the "obs" idea properly lives.

The rule: **new code, docs and conversation use the new terms; existing history keeps its own words.**

## Settled

Oracle is kept — no intention of ever using Oracle DB. Arbiter sits beside the Actor on the outbound edge.

## Deferred to their own sessions

**Business Services & Definitions** (composition and business context), the **prioritisation vocabulary** (what answers "P1 or P2, wake someone or wait till morning"), and **Playbooks** (the three execution modes).
