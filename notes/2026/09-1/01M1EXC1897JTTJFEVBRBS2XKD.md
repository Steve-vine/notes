---
id: 01M1EXC1897JTTJFEVBRBS2XKD
created: 2026-09-01T16:38:22.217814Z
updated: 2026-09-01T16:38:22.217814Z
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
| **Conductor** | Owns all scheduling: what runs, how often, and whether it runs at all | Do any work itself, or interpret results |
| **Obs Loop** *(name under review — see Open questions)* | The "what's changed" pass. Turns raw inbound material and estate state into Alerts and Observations, and maintains their transitions (new / recurring / recovered) | Judge importance, or create Incidents |
| **Correlator** | Determines what a thing really is and how important it is to the business. Decides what to escalate, dedupe or leave alone | Decide *what to do* about it |
| **Oracle** | The brain. Works out what should happen next, using Context and Playbooks. Can pull from any layer below it | Execute anything, or approve anything |
| **Visibility layer** | Collective term for every human-facing surface — Web UI, Reports, Teams, email | Hold logic of its own; it presents what lower layers decided |
| **Actor** | Performs actions passed to it | Choose actions, or decide whether they are safe |
| **Arbiter** | Refuses dangerous actions before they reach the Integrations | Judge intent — approval is a separate, earlier question |

## 2. Stores — things that *hold*

Named as plain nouns. A store is inert: it is written to and read from, and decides nothing.

| Name | Holds |
|---|---|
| **Estate** | Every discovered entity, its properties, tags and relationships |
| **Signal Queue** *(name under review)* | Alerts and Observations, including those never escalated |
| **Business Services & Definitions** | What composes each managed business service, and the definitions that let the Correlator prioritise |
| **Playbooks** | Known responses — engineer instructions, simple actions, or gated sequences |
| **Context** | Supporting material for diagnosis and remediation |

## 3. Objects — things that *exist*

The nouns that flow between layers. Kept separate from layer names on purpose: **Signal** the object is not the Signal Queue the store.

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
3. A **layer name is never an object name.** Signals sit in the Signal Queue; the Oracle is not an oracle result.
4. Prefer the word an operator would use over the word the code uses (ADR 0103 — the domain object keeps its name, nothing a human reads does).

## The flow, in one line

Integrations collect → **Obs Loop** determines what changed → **Correlator** determines what it is and how much it matters → **Oracle** determines what to do → **Visibility** shows a human → **Actor** executes → **Arbiter** refuses the dangerous → back out through Integrations. The **Conductor** paces all of it; upper layers may pull from lower ones at any time.

## Open questions

1. **Signal Queue vs Obs Loop is circular as drafted.** The store is described as holding Alerts and Observations, while the Obs Loop is described as producing them from that same store. Resolve one way: either the store holds *raw inbound material* and the Obs Loop produces Signals from it (suggesting a rename to **Intake**), or it holds Signals and the Obs Loop only maintains their transitions.
2. **"Queue" implies transient.** Non-escalated Signals persist with a lifecycle, so this is a store, not a queue. Consider **Signal Store**.
3. **"Obs Loop" is the only component not named as a role**, and the name is currently held by `obs_loop.py`, which does a different job (it dials out through connectors). Either rename the component — **Differ** and **Detector** both fit the pattern — or plan for that code to move into Integrations and free the name.
4. **"Oracle" collides with Oracle the database vendor**, in a product that integrates with databases. Live with it, or consider **Analyst** / **Advisor**.
5. **Arbiter placement** — beside the Actor as a wall on the outbound path, rather than a step inside it, so no ordering change can route around it.

## Deferred to their own sessions

**Business Services & Definitions** (composition and business context), the **prioritisation vocabulary** (what answers "P1 or P2, wake someone or wait till morning"), and **Playbooks** (the three execution modes).
