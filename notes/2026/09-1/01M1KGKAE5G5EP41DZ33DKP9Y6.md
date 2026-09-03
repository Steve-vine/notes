---
id: 01M1KGKAE5G5EP41DZ33DKP9Y6
created: 2026-09-03T11:31:21.669051Z
updated: 2026-09-03T11:35:11.626623Z
type: memo
title: Deaglan Lynch - Senior DevOps Engineer
meeting:
- Interview
---
Interview questions — Lead DevOps Engineer role. Interviewing today. Notable: one of very few externals with BOTH real line-management (team of 6 at TalkTalk, 2 apprentices → Junior Engineer) AND Flux GitOps on a K8s estate — a combo most strong technical candidates lack. Multiple AKS migrations, ARM→Terraform standardisation, Security Champion (SCA/SAST gates). Software-dev foundation (Pega/.NET/test automation). Manchester, UK. Caveats: (1) leadership was 2021–22; since then "tech lead/Security Champion" not line manager — confirm real + still wants it; (2) almost entirely Azure — AWS listed as skill only, we're mid-migration TO AWS; (3) largely single-company (TalkTalk then Access) — check scale vs our 300+ app multi-region UK/US platform.

## Leadership — his standout, confirm real + current
- ==Managed 6 DevOps engineers at TalkTalk (sprint planning, roadmap, deadlines) + 2 apprentices → Junior Engineer. Direct reports? What did you own beyond technical==?
- That was 2021–22; since then at Access you're tech-lead/Security Champion, not line manager. Looking to manage people again, or centre of gravity moved to hands-on tech lead?
- Engineer ships sound work but consistently late, straining on-call — how handle?
- Both apprentices completing + converting is real — what did you actually do to get them there?
- Listen for: rare among externals — genuine line-management. Confirm it's real + he WANTS it (recent shift to tech-lead may = drifted to IC). Apprentice outcome good sign for developing our two juniors.

## GitOps & Kubernetes — strong on-paper fit
- Adopted Flux across the K8s estate at Access. Repo structure, env promotion, secrets — and why Flux over Argo? Ours is Argo CD; how approach the switch?
- Multiple AKS migrations (on-prem→AKS at Access, 10 K8s envs at TalkTalk). Hardest production K8s incident you led — diagnosis + permanent fix.
- Listen for: real GitOps depth (Flux is genuine GitOps, a plus) + hands-on cluster ops vs migration-planning-at-a-remove. CV leans "architected/led migrations" — confirm he's deep in day-to-day troubleshooting too.

## IaC & standardisation
- Led ARM→Terraform migration + "standardised IaC across the function." What did you standardise on, how get teams to adopt it?
- Our IaC is Crossplane-first (K8s-native via GitOps), not Terraform. How get productive, and avoid steering us back to Terraform because it's what you know?
- Listen for: JD core competency (consistency + adoption) + flexibility on an unfamiliar paradigm.

## Security — the "Security Champion" thread
- As Security Champion: automated security gates + SCA across all products. How set severity gates without flooding engineers with noise or getting bypassed?
- JD calls out OWASP Top 10 CI/CD risks specifically — which do teams most often miss?
- Listen for: genuine threat-model understanding vs SCA-tool rollout. ISO 27001 / SOC 2 / PCI DSS surface — test depth.

## Breadth & scale — gaps to probe
- Background almost entirely Azure (AKS, Azure DevOps, Azure hubs). JD wants 2 of 3 clouds, we're mid-migration TO AWS. AWS listed as skill — how much genuinely done in production?
- Largely TalkTalk then Access. Largest scale — clusters, teams, traffic — you've operated at, vs a 300+ app multi-region UK/US platform?
- Listen for: honest AWS depth (looks Azure-primary); whether scale matches ours. Not disqualifying, sizes the ramp.

## Fit & close
- Came up through software dev (Pega, .NET, test automation) into DevOps. How does that engineering foundation shape how you lead a platform team?
- First 90 days — what would you change, what would you leave alone until you understood why it was built that way?
- What do you want to ask me about the team, the platform, or how success is measured?