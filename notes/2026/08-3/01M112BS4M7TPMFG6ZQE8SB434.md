---
id: 01M112BS4M7TPMFG6ZQE8SB434
created: 2026-08-27T07:36:14.740691Z
updated: 2026-08-27T08:57:40.056087Z
type: memo
title: Ajay Sasidharan - Senior DevOps Engineer
meeting:
- Interview
---
Interview/screen questions — Lead DevOps Engineer role. Partial-fit candidate: strong Azure DevOps / Bicep / Terraform / DevSecOps, regulated-sector background (BNP Paribas, Circle Healthcare), British citizen. Gaps vs JD are the story: NO Kubernetes, NO GitOps, effectively single-cloud (Azure only). Release-management flavour throughout. Treat this as a screen to verify whether those three gaps are real or just under-sold — front-load the gap block.

## Gap verification — ask first (decisive)
- CV is Azure DevOps / release-focused; no ==Kubernetes== anywhere. Our platform is multi-region K8s at its core. What's your hands-on production experience deploying, running, troubleshooting it?
- No ==GitOps== (Argo CD / Flux) on the CV. Pull-based GitOps, or push-based Azure DevOps / Octopus releases?
- Cloud reads as Azure-only. Role wants 2+ of ==AWS==/Azure/GCP. Any production AWS or GCP?
- Listen for: whether the three core gaps are truly absent or under-represented. If all three thin = answer's early. Fair to be direct — these are non-negotiables.

## Azure & IaC depth (his genuine strength)
- ==Walk me through the most complex Azure infra you've automated end-to-end with Bicep/Terraform== — what did you own, what broke?
- ==You introduced IaC and DevOps standards at Circle and Control Risks — how did you get teams to actually adopt them==?
- Listen for: real hands-on depth vs. coordination; adoption story tests "influence standards across teams."

## DevSecOps depth
- Wide security toolset (Snyk, Semgrep, SonarQube, Qualys). Pick one pipeline: how did you set severity gates without flooding engineers with noise or getting bypassed?
- ==Role calls out OWASP Top 10 CI/CD risks specifically — which do teams most often miss==?
- Listen for: genuine threat-model understanding vs. a procurement list.

## Leadership currency
- Clearest people-leadership (6-person release team) was 2011–2018; recent roles are IC. This role manages three engineers directly. ==How current is your people-management — looking to lead again, or happiest hands-on?==
- How would you handle an engineer whose work is technically fine but consistently late?
- Listen for: wants to manage vs. settled into senior IC. Dated leadership evidence is a real question.

## Mindset — release management vs platform engineering
- Much of your background is release/change management (change boards, deployment validation, environment refreshes). This role is cloud-native platform engineering. How do you see the difference, and where's the adjustment hardest?
- Listen for: self-awareness about the shift. Genuine fork, not a trick — honesty matters more than polish.

## Fit with the stack
- Our IaC is Crossplane-first (K8s-native infra via GitOps), not Bicep/Terraform modules; delivery is Argo CD. You'd ramp into both at once. How do you get productive in paradigms you haven't used?
- Listen for: honesty and flexibility, learning two core pieces simultaneously.

## Close
- First 90 days — what would you change, what would you leave alone until you understood why it was built that way?
- What do you want to ask me?