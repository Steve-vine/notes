---
id: 01K6JDS6X31V7VFZ6DD86DADJZ
created: 2025-10-02T12:19:05.251317463Z
updated: 2026-01-09T10:37:12.31722082Z
type: memo
title: 2026 Objectives
imported_from: Obsidian
---
02-10-2025 13:19

Tags: 


---
### Steve
 - KR3: Implement Protos 24x7 Proactive NOC support by end of 2026
### John
 - *Sort out accounts and security groups. AD User/License Cleanup (John, Neil)*
 - Datadog - Outage windows
 - *Sort out Datadog monitoring (John, Deb, Paul, Chris)*
 - *Migrate MSG to Moneypenny EUC Platform and M365 (John, Neil)*
 - *Achieve SOC 2 Type 2 Compliance (Everyone)*
 - Review EUC management tools (Jamf, Intune) and identify issues and gaps
### Deb
 - *Shut down/consolidate all old Cloud accounts. (Deb, Paul, Chris)*
 - Review of API keys and authentication methods. key recycling policy/strategy.
 - ~~Review of all services and things that we're paying for, especially in US (E.g. Google)~~
 - *Sort out Datadog monitoring (John, Deb, Paul, Chris)*
 - Ownership of assets, starting with databases
 - *Achieve SOC 2 Type 2 Compliance (Everyone)*
### Paul
 - *Shut down/consolidate all old Cloud accounts. (Deb, Paul, Chris)*
 - *Look into Twingate Identity Firewall (PAM) (Paul, Cory)*
 - *Firewall standardisation (Paul, Chris, Joe)*
 - *Plans for infrastructure growth, EOL equipment, (including Sunshine and MSG) (Paul, Chris)*
 - *Sort out Datadog monitoring (John, Deb, Paul, Chris)*
 - *Automation of enrolling new servers, IAC for non-cloud (Automox, Semophore(Ansible), Argo Workflows) (Neil, Paul, Chris)*
 - Exchange SE
 - Create a plan to retire AD
 - Achieve SOC 2 Type 2 Compliance (Everyone)
 - *Deliver Sunshine Office Network and Infrastructure Decommissioning (Chris, Paul)*
 - *Improve Network Resilience and Security (Paul, Steve)*
### Chris
 - *Shut down/consolidate all old Cloud accounts. (Deb, Paul, Chris)*
 - *Firewall standardisation (Paul, Chris, Joe)*
 - *Plans for infrastructure growth, EOL equipment, (including Sunshine and MSG) (Paul, Chris)*
 - *Cyber Essentials Plus (US)*
 - *Sort out Datadog monitoring (John, Deb, Paul, Chris)*
 - *Automation of enrolling new servers, IAC for non-cloud (Automox, Semophore(Ansible), Argo Workflows) (Neil, Paul, Chris)*
 - *Achieve SOC 2 Type 2 Compliance (Everyone)*
 - *Deliver Sunshine Office Network and Infrastructure Decommissioning (Chris, Paul)*
 - Decommission NinjaNumber Infrastructure
### Cory
 - Build a library of hardened images
 - *Look into Twingate Identity Firewall (PAM) (Paul, Cory)*
 - *Separate Azure production and non-production systems (Cory, Zeshan)*
 - Azure IAC Gaps (Cory, Zeshan)
 - Achieve SOC 2 Type 2 Compliance (Everyone)
 - Optimise Kubernetes Infrastructure (Steve, Cory, Zeshan, Milo)
 - Provide Infrastructure Support for Kora (Cory, Milo)
### Zeshan
 - *Separate Azure production and non-production systems (Cory, Zeshan)*
 - *Azure IAC Gaps (Cory, Zeshan)*
 - *Achieve SOC 2 Type 2 Compliance (Everyone)*
 - *Optimise Kubernetes Infrastructure (Steve, Cory, Zeshan, Milo)*
 - Perform a gap analysis of the Azure environment (External Access, Let's encrypt etc.)
### Milo
 - Can we use Cloudflare Tunnels for external services
 - Cloudflare proxied DNS everywhere
 - *Achieve SOC 2 Type 2 Compliance (Everyone)*
 - *Optimise Kubernetes Infrastructure (Steve, Cory, Zeshan, Milo)*
 - *Deliver Infrastructure for Self Serve Portal (Milo, Cory)*
### Neil
 - ~~Sort out accounts and security groups. AD User/License Cleanup~~
 ~~- Azure AD Access Review~~
 - *PEM replacement (Neil, Joe)*
 - *Migrate MSG to Moneypenny EUC Platform and M365 (John, Neil)*
 - *Achieve SOC 2 Type 2 Compliance (Everyone)*
 - *Automation of enrolling new servers, IAC for non-cloud (Automox, Semophore(Ansible), Argo Workflows) (Neil, Paul, Chris)*
### Joe
 - Self serve password resets
 - Passwordless authentication
 - *Firewall standardisation (Paul, Chris, Joe)*
 - *Enable SSO for all SaaS services where supported (E.g. SendGrid)*
 - Abnormal, Phishing simulation and CBT
 - ~~*PEM replacement (Neil, Joe)*~~
 - Document Security Controls
 - Vulnerability Scanning/Pen Testing
 - *Achieve SOC 2 Type 2 Compliance (Everyone)*
 - implement a capability to perform active/passive network discovery
 - Implement controls to ensure only approved software is installed on workstations (including browser extensions/plugins)
 - Create and implement secure benchmarks for asset configuration
 - Identify and clean up the overlap between Abnormal and Defender, which system should be performing which functions
 - Move Nessus to the cloud, either self managed or SaaS
 - Determine if we should deploy Nessus agents?
 - Reduce the number of global admins

---
## References