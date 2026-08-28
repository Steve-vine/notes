---
id: 01M14AYSP2TY0M2S826MAYQJDJ
created: 2026-08-28T14:04:09.794746Z
updated: 2026-08-28T18:21:57.794608Z
type: task
title: AI risk gets something to assess against — the standard behind "AI-specific risk sources"
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 482
sprint: s31sysr
comments:
- id: 01M14QP5RB7297APX9AF26V3C0
  author: Steve Vine
  at: 2026-08-28T17:46:38.731668Z
  text: |-
    Done — PR #479, merged as 1cebb0a.

    **An AI Risk Assessment Standard**, published under AI Governance next to the Artificial Intelligence Policy — a standard sitting under a policy, the way every other domain is arranged. Four parts: what we are trying to achieve with AI, written so a specific system can be judged against each objective rather than admire it; where AI risk comes from, grouped as the model, its data, how it is used, what it depends on, and deliberate attack; and how to record what you find. It names `AIG.5`, so a reader arrives back at the control it serves.

    **It sends risks to the one register.** Not a separate AI risk process — same 5x5 scale, same appetite, opened alongside every other technology risk. The guidance is explicit that where AI is merely the *route* to a familiar risk, it is categorised where it belongs: data reaching a model provider is a supply-chain and privacy risk, and the recipient being a model does not make it a new kind of exposure.

    **The `ai` appetite category** is in, since the task flagged it as the natural moment. Seeded at the default threshold alongside security, regulatory, operational, financial and reputational; a company wanting AI held tighter sets that in admin. Insert-if-absent, so no migration.

    **Standards are a new seed, and they seed authored or not at all.** A policy lands as a shell for someone to write; a standard only earns its place if it says something, so `import-standards` carries a body. Same ADR 0028 rule as the AI Policy — written only over a placeholder, never over an edit made in Compass, and there is a test for that. Wired into the CLI and the deploy Job.

    Annex C stayed the reference and not the source: written in our own words, organised around Compass's own risk categories, and a test asserts the shipped text names no annex.

    Deliberately still out of scope, as the task said: the library of suggested AI risks a company adopts into its register. That is a general capability and wants its own task.
assignee: steve
company:
- moneypenny
label:
- feature
priority: medium
task_status: done
---
Follow-up from COM-431.

`AIG.5` says AI risks are identified, assessed and treated through the technology
risk process, **using risk sources specific to AI**. Compass hands a company nothing
to use. The risk register starts empty and the only risk content that ships is the
scoring rubric and the appetite thresholds, so the control asks for a judgement the
product gives no help in making — and an assessor has nothing to ask to see.

ISO/IEC 42001 Annex C is the missing input: a catalogue of the objectives an
organisation might be pursuing with AI, and of where AI risk actually comes from —
how opaque the model is, how much runs without a person in the loop, the quality and
representativeness of the training data, the complexity of the environment it runs
in, where it sits in its life cycle.

## What to build

**An AI Risk Assessment Standard, in the playbook, under AI Governance.** A standard
sitting under a policy, which is how every other domain is arranged — it lands next
to the Artificial Intelligence Policy and gives `AIG.5` something to point at.

Two sections, matching what Annex C is for:

- **What we are trying to achieve with AI** — the objectives worth stating, each
  written so a specific system can be judged against it rather than admired.
- **Where AI risk comes from** — the prompt sheet. Enough that someone opening a risk
  on an AI system is reminded of the sources a general security assessment will not
  surface.

Written in **our own words**, organised around Compass's own risk categories. Annex C
is copyrighted, exactly like Annex B — read it, do not ship it. That constraint is
what keeps this a writing task rather than a transcription one.

## Also worth doing here, if wanted

An **`ai` risk appetite category** alongside security, regulatory, operational,
financial and reputational, so a company can set a distinct tolerance for AI risk.
Small, and it is the natural moment.

## Deliberately not in scope

**A library of suggested AI risks a company adopts into its register.** It is the more
powerful answer and it is where this ends up — but a catalogue of starter risks is a
**general** capability, useful to every domain, and building it AI-first would be the
same mistake COM-431 spent its effort avoiding. It wants its own task, with AI as the
first content to land in it rather than the shape of the thing.

**Not a framework import, and not more controls.** A framework requirement is
something a company is scored against; "level of automation" is not something you can
be compliant with, and importing Annex C as requirements would add rows nobody can
ever satisfy and drag the coverage figure down for nothing — the same reason 42001's
nine control objectives are non-assessable. And it is not another control: `AIG.5`
already exists. This is the content that makes it doable.