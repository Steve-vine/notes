---
id: 01M1YC3AC9AA9TBBYV097XXQDZ
created: 2026-09-07T16:44:21.769526Z
updated: 2026-09-07T16:44:21.769526Z
type: task
title: 'ECM4: Malware Protection Across Endpoints and Servers'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 44
---
## Control Objective

Malware protection measures, including regular signature and detection-engine updates, are implemented across Callitech Limited's endpoints and servers to prevent, detect, and remove malicious software such as viruses, spyware, and ransomware.

Scope

This control applies to all corporate endpoints (workstations, laptops) and servers used by staff in the Wrexham (UK), Atlanta (US), and Florida (US) offices, including systems that process employee and customer PII, call recordings, CRM data, and customer content. It covers infrastructure supporting telephone answering services (TAS), live chat, and AI-based answering systems, as these are the company's most critical services.

## Implementation Guidance

The Infrastructure and Cybersecurity function, overseen by the Head of Infrastructure and Cybersecurity, is responsible for deploying and maintaining anti-malware/endpoint protection software on all in-scope endpoints and servers.Anti-malware agents are configured for real-time scanning and automated retrieval of updated malware signatures/detection content, so that protection keeps pace with newly emerging threats without requiring manual intervention on each device.Endpoint protection status (coverage, update currency, and detected threats) is centrally reviewed by the Infrastructure and Cybersecurity team so that devices with outdated signatures or failed updates, or with active detections, are identified and remediated promptly.Network-layer controls (firewalls and, where deployed, intrusion detection/prevention capability) are configured to block known malicious traffic reaching offices and cloud-hosted environments in the EU and US, complementing endpoint-level protection.Because Callitech's business is a high-volume telephone answering and live chat operation where staff regularly handle inbound communications, links, and attachments from customers and third parties, staff receive periodic security awareness communications/training covering phishing, suspicious downloads, and other common malware delivery methods.Malware protection configurations and related procedures are reviewed periodically and updated to reflect new threats, changes in the endpoint fleet (including growth from the AI-based answering system rollout), or changes in supported operating systems and tools.

Restriction of software installation on endpoints

Standard user accounts on corporate workstations and laptops in the Wrexham (UK), Atlanta (US), and Florida (US) offices do not hold local administrator rights; installation of software requires action by, or documented approval from, the Infrastructure and Cybersecurity function.A list of software approved for use on corporate endpoints and servers is maintained by the Infrastructure and Cybersecurity function, covering the tools used to deliver telephone answering services, live chat, CRM handling, call recording, and the AI-based answering platform. Requests for additional software are reviewed for security and licensing suitability before approval.Endpoint management/protection tooling is used to report installed applications so that unapproved or unauthorized software is identified; identified items are investigated and removed or formally approved, and repeated occurrences are addressed with the relevant manager.Staff are reminded through security awareness activities that installing unapproved software or browser extensions on company devices is prohibited.

## Evidence Request

Evidence supporting this control includes: endpoint protection console reports showing device coverage and signature/update currency across UK and US offices; scan and detection logs or summary reports; anti-malware configuration/policy documentation; and records of security awareness communications or training delivered to staff.

Additional evidence

Approved software list and evidence of the approval process for new software requests.Configuration evidence that standard users lack local administrator rights.Installed-software or unapproved-application report from the endpoint management console, with records of remediation.