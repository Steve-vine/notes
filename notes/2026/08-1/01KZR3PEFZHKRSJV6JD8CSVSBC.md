---
id: 01KZR3PEFZHKRSJV6JD8CSVSBC
created: 2026-08-11T09:50:41.151638Z
updated: 2026-08-11T10:43:29.527029Z
type: memo
title: Sairam Yalamarthi - Senior DevOps Interview
meeting:
- Interview
---
### Questions

**Opening — career shape and motivation**

- Your whole career so far has been at TCS, largely in a consultancy delivery model. This role is a small in-house team owning Moneypenny's own platform end-to-end. What's drawing you to that shift, and where do you think the adjustment will be hardest?
  
*Listening for: self-awareness about the difference between rotating across client engagements and living with your own platform's decisions for years. Consultancy engineers sometimes hand off before the long-tail consequences land; you want someone who's hungry for the ownership, not surprised by it.*

- manage team of 5 or 6 juniors

---

**Depth behind the numbers**

- Pick the achievement you're proudest of - walk me through it end to end: what the baseline actually was, how you measured it, what you changed, and what broke along the way.
- You reduced recurring production issues by 30%. Tell me about one recurring incident that didn't have a clean fix — what made it stubborn, and how did you land on the eventual solution?
  
*Listening for: whether the round numbers survive contact. A real owner can tell you the messy middle — the false starts, the thing that regressed, how they knew the baseline. If the metrics dissolve into "it was a team effort, roughly" that tells you something too.*

- 

---

**Standardisation and technical judgment (this is the core of the role)**

- Your CV lists five CI/CD systems — GitHub Actions, Azure DevOps, Jenkins, GitLab CI/CD, Bitbucket. This role is explicitly about reducing that kind of divergence. If you joined and found that spread, how would you decide what to standardise on, and how would you actually get three engineers and 5 dev teams to adopt it?
- Describe a time you set a standard the rest of a team initially resisted. What was the standard, why the resistance, and what did you do?
  
*Listening for: the JD's central competency — driving consistency and influencing adoption. Good answers weigh migration cost, blast radius, and team buy-in, not just tool preference. Watch for whether he leads with technical merit alone or also with how he'd carry people.*

- Not standardise, until understood. Take into account security, developer experience. EKS

---

**Leadership — the step up from mentoring to managing**

- Your CV describes mentoring juniors and reviewing code. This role is different: you'd own three engineers as their lead. Have you managed people directly, and if not, why do you think you're ready for it?
- One of your three engineers is consistently shipping work that's technically fine but always late. How do you handle that?
- How do you run a code or infra-change review so it raises the bar without becoming a bottleneck or feeling like a gate?
  
*Listening for: the honest answer to the first question matters more than a polished one. He may not have formal reports — that's fine if he's clear-eyed about the gap and shows the right instincts on the scenario. Evasion or treating "lead" as just "most senior IC" is the flag.*

- Understanding the work? Technical approach to change control

---

**Security and compliance (a named JD requirement, and Moneypenny's world)**

- The role calls out the OWASP Top 10 CI/CD security risks specifically. Which of those do you think teams most often get wrong, and how have you defended against it in a pipeline you've built?
- You integrated SonarQube, Trivy and secret scanning. How do you introduce security gates without engineers learning to rubber-stamp or bypass them?
- Moneypenny carries HIPAA, SOC 2, GDPR and PCI DSS. Have you previously built delivery controls to satisfy an auditor — segregation of duties, auditable deployment trails?
  
*Listening for: whether "DevSecOps" is a tool list or a genuine understanding of the CI/CD-specific threat model (poisoned pipeline execution, compromised runners, dependency/supply-chain, over-privileged pipeline credentials). The compliance question tests whether he's operated in a regulated environment or just adjacent to one.*

-

---

**Observability and SLOs**

- Your CV talks about MTTR and monitoring dashboards, but I want to dig into SLOs specifically. Have you defined SLOs and error budgets for a service, and how did you get a team to actually act on them rather than just display them?
- The JD asks for alerting that triggers on symptoms rather than outages. What does that distinction mean to you in practice?
  
*Listening for: this is a possible genuine gap — his CV is strong on monitoring/MTTR but light on explicit SLO/error-budget language. See whether he's done real SLO practice or whether "observability" for him stops at dashboards and alerts.*

-

---

**Fit with the Moneypenny stack**

- Our IaC is Crossplane-first with Argo CD GitOps, not Terraform-centric. You're clearly strong in Terraform — how do you approach getting productive in an IaC paradigm you haven't used, and how would you avoid forcing our stack back toward what you already know?
- Your GitOps experience is with Argo CD — walk me through how you structured repos, environment promotion, and secrets in a GitOps model. What did you get wrong the first time?
  
*Listening for: intellectual flexibility. Strong Terraform people sometimes quietly relitigate a Crossplane decision for months. You want curiosity about the model you've chosen, not a sales pitch for the one he knows.*

-

---

**Close**

- What would you want to change in your first 90 days — and, what would you deliberately leave alone until you understood why it was built that way?
- What do you want to ask me — about the team, the platform, or how success is measured here?
  
*Listening for: the restraint in the first question is the tell. A good lead resists the urge to rewrite everything on day one. And the questions he asks you often reveal more than his answers.*

-
