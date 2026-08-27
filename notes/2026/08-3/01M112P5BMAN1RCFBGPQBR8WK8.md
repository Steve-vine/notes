---
id: 01M112P5BMAN1RCFBGPQBR8WK8
created: 2026-08-27T07:41:54.932671Z
updated: 2026-08-27T11:49:43.145889Z
type: memo
title: Rudranil Sarkar - SRE Platform Lead
meeting:
- Interview
---
Interview questions — Lead DevOps Engineer role. Strong technical/stack fit: real multi-cloud (Azure+AWS, GCP limited to GKE), production K8s across AKS/EKS/air-gapped RKE2 (CKA + SUSE RKE2 cert), Argo CD/Workflows, Helm/Kustomize, and CROSSPLANE (rare — matches our direction). SLI/SLO/error budgets, OTel, Wiz/Trivy/Snyk. GPU-on-K8s + KServe MLOps (maps to Cory's GPU/AI platform). No sponsorship required, London. Two things to test: (1) CV is one employer (Srijan/Material 2018–2026) with client logos as undated "project contributions" — unpick real depth vs logo; (2) leadership is architect/tech-lead, NOT proven line-management. All-consultancy background — in-house ownership adjustment applies.

## Unpicking the CV structure — ask early
- One continuous employer (Srijan/Material 2018–2026) with McKinsey, OnCorps, Pizza Hut, Revvity etc. as project contributions. Map it — which were long/deep vs short, roughly how long on each?
- ==Flagship engagement — what did you personally own end-to-end vs the wider team==?
- Listen for: real duration + ownership behind the logos. Consultancy CVs make parallel/short engagements read like a senior career. Find the 2–3 he went deep on.

## Crossplane, GitOps & stack fit — his standout, lean in
- Crossplane appears in skills + OnCorps — rare and exactly our direction. ==What did you build with it, and how does it compare to your Terraform experience==?
- ==Walk through a GitOps setup you designed end-to-end on Argo CD== — repo structure, env promotion, secrets, what you'd change now.
- Our IaC is Crossplane-first, delivery Argo CD. ==Where is Crossplane genuinely better than Terraform, and where does it still hurt==?
- Listen for: Crossplane as hands-on depth vs bullet point. If real, one of very few externals who's touched our actual paradigm — significant edge.

## GPU / MLOps — platform-direction bonus
- ==You've deployed GPU nodes on K8s + KServe model serving. We run in-house AI models (transcription, routing, summarisation) on a GPU platform in-cluster. Walk me through your experience==.
- What's genuinely hard about GPU workloads + model serving in production K8s?
- Listen for: differentiator almost no one else has; maps onto Cory's GPU/AI platform. Signals he could grow into where the platform's heading.

## Multi-cloud & Kubernetes depth
- K8s across AKS/EKS/air-gapped RKE2 — ==take me through a genuinely hard production incident you led: diagnosis + permanent fix.==
- You're candid GCP is "limited to GKE." Realistically, production depth on Azure vs AWS?
- Listen for: air-gapped RKE2 is unusual/hard — good sign if it holds. Honest self-assessment (GCP/Dynatrace/Ansible "limited") is a credibility positive; confirm Azure+AWS both genuinely production-deep since "two of three" rests on them.

## Leadership — the real gap to test
- Titles are architect/tech-lead — direction, standards, mentoring. This role line-manages three engineers: growth, objectives, underperformance. Managed direct reports before? If not, why ready for the step?
- One engineer ships strong work but consistently late, straining on-call rota. How do you handle it?
- How do you give difficult feedback to someone you've worked alongside as a peer?
- Listen for: excellent on architect/mentor axis, unproven on people-management. Honesty about the gap beats a polished non-answer.

## In-house ownership & fit
- Whole background is consultancy — build and hand over. This is a small in-house team owning one platform for years. What draws you to that, where's the adjustment hardest?
- Role is about REDUCING tooling divergence — your CV spans GitLab CI, GitHub Actions, Azure DevOps, Jenkins, Spinnaker. If you found that spread, how would you decide what to standardise on and drive adoption?
- Listen for: appetite for long-term consequences vs next client; JD's core competency — consistency + influencing adoption.

## Close
- First 90 days — what would you change, what would you leave alone until you understood why it was built that way?
- What do you want to ask me about the team, the platform, or how success is measured?