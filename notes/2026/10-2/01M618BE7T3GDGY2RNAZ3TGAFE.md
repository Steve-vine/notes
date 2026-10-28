---
id: 01M618BE7T3GDGY2RNAZ3TGAFE
created: 2026-10-28T12:39:24.154915Z
updated: 2026-10-28T13:05:13.206486Z
type: task
title: Every Integrations tile shows its platform's own logo, as Microsoft's does, in place of the lettered squares
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 1393
sprint: s8fmesf
assignee: steve
label:
- improvement
priority: low
task_status: active
---
Sprint 90, Integrations. Found by Steve on staging, 2026-10-28, while testing sprints 90–93.

## What's wrong

On Admin ▸ Integrations, Microsoft's tile shows the Microsoft logo. Every other tile shows a coloured square with letters: "AD", "aws", "Az", "GC", "SMTP", "SG", "SES", "S3", "N", "Ai", "eol". This was my call in sprint 90, made to avoid shipping other companies' artwork. Steve wants the real logos.

## What people should see

Each tile, and the header of its own page, shows the platform's logo:

- **Active Directory** — Microsoft's Active Directory icon from its published Azure/Entra icon set (Microsoft has no separate Active Directory logo).
- **AWS** — the AWS logo.
- **Azure** — the Azure logo.
- **Google Cloud** — the Google Cloud logo.
- **Amazon SES** and **Amazon S3** — their AWS service icons.
- **SendGrid** — the SendGrid (Twilio) logo.
- **Nessus** — the Tenable Nessus logo.
- **Aikido** — the Aikido Security logo.
- **endoflife.date** — its logo.
- **SMTP** — no brand, so a plain envelope icon in the same style.

Every logo sits in the same square as Microsoft's, at the same size, and stays readable in dark mode: a dark wordmark such as AWS's needs its light version or a light backing.

## Notes

- Take each logo from the vendor's own brand or press kit, or from its published architecture-icon set (AWS, Azure, Google Cloud), and follow its usage guidance: unaltered, proportions kept, clear space respected. Record where each came from beside the files.
- Ship them as SVG files bundled into the app. Nothing is loaded from a vendor's site at run time.
- Logos show only on Admin ▸ Integrations, to name what a tile connects to. No logo appears on the public Trust Centre.