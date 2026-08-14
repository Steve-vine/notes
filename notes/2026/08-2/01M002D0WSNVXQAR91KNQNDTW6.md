---
id: 01M002D0WSNVXQAR91KNQNDTW6
created: 2026-08-14T12:01:59.193497Z
updated: 2026-08-14T12:03:37.791893Z
type: memo
title: Kiran Kumar - Senior DevOps Engineer
meeting:
- Interview
---
Opening — career shape and motivation

- You've spent 12 years across large enterprises and consultancies — BMW FS, DBS, Companies House, Accenture. This is a small in-house team of three engineers owning Moneypenny's own platform for the long haul. What's drawing you to that, and where do you expect the adjustment from big-enterprise DevOps to be hardest?

Listening for: whether he's ready for a smaller, hands-on team where he owns the platform's long-tail consequences rather than governing at enterprise scale with layers beneath him. "Architected and governed" language on the CV can mean deep hands-on or can mean oversight — find out which.

Azure & Entra ID — his strongest card, and directly relevant to your roadmap

This is where Kiran is genuinely differentiated and where Moneypenny has live work in flight (Entra ID SSPR, the SMS/voice auth retirement). Press it, because it's the area he could add most.

- Walk me through the Entra ID work at BMW FS — landing zones, Key Vault, RBAC. What did you own hands-on versus set direction for?
- We're mid-way through Entra ID authentication changes — SSPR rollout, and planning around Microsoft retiring SMS/voice as auth methods. If you were leading that, how would you approach Conditional Access design and the migration off legacy auth methods without locking people out?
- How have you handled secrets and Terraform state security in an Azure-native shop? You mentioned a Vault adoption strategy at Companies House — did that land, and how did it compare to Key Vault?

Listening for: real operational depth in Entra/Azure identity, not just a landing-zone deployment. The SSPR/Conditional Access scenario tests whether he can reason about your actual near-term problem. If this is strong, he's adding capability the team needs now.

DevSecOps & regulated compliance — his other strong card

- You've embedded SAST, DAST, SonarQube, Fortify and Twistlock/Prisma across several shops. Pick one pipeline and walk me through how you set severity gates — how do you stop a hard gate either flooding engineers with noise or getting quietly bypassed?
- The JD calls out the OWASP Top 10 CI/CD security risks specifically — which is distinct from the app-level Top 10. Which of those CI/CD risks do teams most often miss, and how have you defended a pipeline against it?
- You've worked in regulated FS — BMW FS, DBS, Companies House. Have you built delivery controls to satisfy an auditor directly: segregation of duties, auditable deployment trails, evidence collection? How did you keep that from becoming a ticket queue that slows delivery?

Listening for: whether DevSecOps is a genuine threat-model understanding or a tool inventory (his CV lists a lot of tools). The compliance question matters because Moneypenny carries ISO 27001 / SOC 2 / GDPR / PCI DSS — you want someone who's operated controls, not sat adjacent to a compliance team who owned them.

GitOps — the genuine gap, so probe it honestly

This is the main thing separating Kiran from your top tier — there's no Argo CD or Flux anywhere on his CV, despite Moneypenny running Argo CD GitOps as the delivery model. Don't dance around it.

- Our delivery model is Argo CD GitOps — declarative desired state in git, environment state is auditable, and rollback is a git revert. Your CV is strong on Azure DevOps and Jenkins pipelines but I don't see GitOps tooling — how much have you run in a pull-based GitOps model versus push-based CI/CD?
- If you joined and had to get productive with Argo CD quickly, how would you go about it? What do you think the hard parts of GitOps are — where does it break down?
- More broadly: when you hit a paradigm you haven't used, how do you get up to speed without quietly steering the stack back toward what you already know?

Listening for: honesty about where he is, and intellectual flexibility. Either "I've done push-based CI/CD, here's how I'd ramp" or "I've actually done more GitOps than the CV shows, here's the detail" is fine — you just need the truth, since he'd be ramping into it. The flag would be bluffing or dismissing GitOps as a rebrand of what he already does.

Kubernetes depth

- Your K8s is EKS and AKS across banking workloads. Take me through a genuinely hard production Kubernetes incident you led — what was failing, how you diagnosed it, and what the permanent fix was.
- You hold a CKA — how much of your recent work is hands-on cluster operations versus architecture and governance?

Listening for: whether the Kubernetes experience is deep operational troubleshooting (what the JD wants) or more platform-architecture-at-a-remove. The CKA is a good sign; the "governed/directed" CV language means it's worth confirming he's still close to the metal.

Leadership — lead title, but test the management substance

- Your current title is Lead DevOps/SRE. Tell me concretely what you lead — direct reports, or technical direction for a function? Have you owned people: their growth, their reviews, their underperformance?
- One of your three engineers is consistently shipping work that's technically sound but always late, and it's straining the on-call rota. How do you handle it?
- How do you run infra-change or pipeline review so it raises the bar without becoming a bottleneck?

Listening for: the real scope behind "Lead." Enterprise "lead" titles sometimes mean senior IC / tech lead rather than line manager. That's fine if he's clear about it and shows the right instincts on the scenario — evasion or inflating the title is the flag.

Standardisation & fit with the stack

- Our IaC is Crossplane-first — Kubernetes-native infra provisioned through GitOps — not the Terraform-module approach you've built everywhere. How would you get productive in that, and how would you avoid pulling our stack back toward Terraform because it's what you know?
- This role is explicitly about reducing tooling divergence. Across your roles you've used Jenkins, Azure DevOps, GitHub, Concourse. If you joined and found several competing pipeline systems, how would you decide what to standardise on and get teams to adopt it?

Listening for: the JD's core competency — driving consistency and influencing adoption — plus flexibility over tool loyalty. Terraform-heavy people sometimes quietly relitigate a Crossplane decision for months; you want curiosity about your model, not a pitch for his.

Depth behind the numbers

Pick the achievement you're proudest of — the 60% provisioning reduction, or the MTTR improvements. Give me the baseline, how you measured it, what you changed, and what broke along the way.
Listening for: whether the round numbers survive contact. A real owner can tell you the messy middle; if the metrics dissolve into "roughly, it was a team effort," that's informative too.

Close

What would you change in your first 90 days — and, harder, what would you deliberately leave alone until you understood why it was built that way?
London to Wrexham is a real distance — what are you expecting on location, hybrid, and travel?
What do you want to ask me about the team, the platform, or how success is measured?
Listening for: restraint on the first question (a good lead doesn't rewrite everything on day one); a straight answer on location, since it's a practical factor for this role; and the quality of his own questions, which often reveal more than his answers.

Two interviewer notes. Spend your richest time in the Azure/Entra and DevSecOps sections — that's where Kiran is strongest and where Moneypenny has the most to gain, so confirm the depth is real rather than certification- and tool-list-deep. And be direct about the GitOps gap rather than working around it — how he handles "here's where you're light for our stack" is itself a strong signal about how he'll take feedback and ramp as a lead.

Since you've now interviewed or are interviewing Sairam Yalamarthi, Anand, and Kiran, I could build a single scoring sheet across the three — same JD criteria, side by side — so you can compare them cleanly once Kiran's done. Want me to put that together?