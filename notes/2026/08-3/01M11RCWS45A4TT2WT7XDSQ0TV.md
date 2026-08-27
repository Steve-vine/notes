---
id: 01M11RCWS45A4TT2WT7XDSQ0TV
created: 2026-08-27T14:01:19.908421Z
updated: 2026-08-27T17:18:22.861768Z
type: task
title: Four PCI requirements have no control that finishes them
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 462
sprint: s8cjs5n
assignee: steve
company:
- moneypenny
label:
- improvement
priority: medium
task_status: active
---
PCI is mapped end to end — all 313 assessable requirements have Core controls
attached — but five are only partly covered. Four are genuine holes. Each needs
one small, specific control, and each of those earns its place in the library
regardless of PCI.

### 1.2.7 — rulesets reviewed at least every six months

Attached today: **ACC.8** (recertifies *people's* access rights, on exactly the
right six-monthly rhythm but the wrong subject), **INA.2** (internal audit tests
whether controls work — independent, but episodic and general), **NES.11**
(network device changes go through change management). All three touch it and all
three miss the same thing: change management governs each change as it happens
and never comes back to look at what accumulated.

Roughly: *Network security control rulesets are reviewed at least every six
months, and rules no longer justified by a documented business need are removed.*
Domain NES. Also wanted by ISO 27001 A.8.20/A.8.22 and CIS 4.x.

### 1.4.3 — anti-spoofing

Attached: **NES.8** (firewall rules limit what may enter), **NES.14** (network
intrusion detection would see the attempt), **NES.20** (application-layer
filtering protects critical segments). Seeing it and filtering it are not the same
as dropping forged source addresses at the boundary.

Roughly: *Forged source IP addresses are detected and blocked at the network
boundary.* Domain NES.

### 1.4.5 — internal IP addresses and routing information not disclosed

Attached: **NES.3** (segregation limits what an outsider sees), **NES.5** (the
diagram records where the boundary is), **NES.20** (filtering can strip it).
Nothing states the requirement itself.

Roughly: *Internal IP addresses and routing information are not disclosed to
unauthorised parties.* Domain NES.

### 3.5.1.3 — disk encryption authenticated separately from the OS account

Attached: **KMC.8** (disk encryption is in place), **s42.ACC.5** (access
restricted by classification). The requirement is specifically that full-disk
encryption's own logical access is not the operating system account — otherwise
the encryption contributes nothing against someone already logged in.

Roughly: *Where disk or partition-level encryption is used, its logical access is
authenticated separately from the operating system account.* Domain KMC.

### 11.4.5 — not a gap, a judgement

Attached: **NES.3** (segregation designed and implemented) and **VUM.8**
(internal penetration testing). Between them these do close it — the requirement
asks that penetration testing confirms segmentation still holds, and both halves
are present. This is a joint-completeness declaration, not a new control. It can
be carried in the mapping data now; COM-461 is what lets a person make the same
call from the screen later.

## Implementation

- Four rows in `data/controls.csv` following the COM-424 conventions: seed key,
  domain code, next free ref in the domain, no legacy id, and a "what good looks
  like" description in the same shape as its neighbours.
- Four mapping rows in `data/mappings/pci-dss-4-0-1.csv` at `equal`, plus a
  `coverage_complete` row for 11.4.5.
- **Check each new control against the other seven frameworks before mapping it
  to PCI alone.** The ruleset review in particular should pick up ISO 27001 and
  CIS requirements. A control that maps to one framework only is usually a
  control written too narrowly.
- Write them to scope themselves by what is being protected rather than naming
  card data, per the COM-426 convention — none of these four is card-specific.
- The importer inserts missing rows keyed on the seed key, so this is additive.
  No migration.

Tests: PCI reads 313 of 313 fully covered once this and the 11.4.5 declaration
land; each new control appears against every framework requirement it was mapped
to.
