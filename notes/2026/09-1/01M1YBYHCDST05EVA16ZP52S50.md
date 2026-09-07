---
id: 01M1YBYHCDST05EVA16ZP52S50
created: 2026-09-07T16:41:45.101634Z
updated: 2026-09-07T16:41:45.101634Z
type: task
title: 'AM1: Asset inventory is maintained to track, identify, and record all organizational assets throughout their lifecycle'
priority: medium
assignee: steve
task_status: backlog
project: 01KY4JNC6MPPNNFXN416S398SG
number: 28
---
## Control Objective

Callitech Limited maintains an inventory of organizational assets to track, identify, and record assets throughout their lifecycle, across its Wrexham (UK), Atlanta (US), and Florida (US) locations.

## Implementation Guidance

The inventory covers the categories of assets relevant to Callitech's operations, including:

Hardware and endpoints: workstations, laptops, and mobile devices used by staff across all office locations, including remote/field equipment.Infrastructure and cloud resources: cloud-hosted infrastructure (EU and US regions), identity systems, and communications platforms supporting telephone answering services (TAS) and AI-based answering systems.Software and application components: internally developed and third-party software, including the databases in use (MySQL, MongoDB, PostgreSQL, SQL Server) and application frameworks (Vue, React, CakePHP, Tailwind CSS) that support customer-facing services.Data assets: employee and customer PII, call recordings, CRM data, and customer content, including data subject to HIPAA obligations for certain clients and PCI DSS (self-certified) where card data volumes are low.Third-party and vendor-managed assets: telecom and cloud provider services that are operationally critical to service delivery.

Each identified asset is assigned an owner (e.g., the Head of Infrastructure and Cybersecurity, service desk, or relevant business/application owner) who is responsible for identifying, classifying, and valuing the asset, and for ensuring appropriate security measures are applied based on its sensitivity and criticality. Asset owners are responsible for keeping inventory records current as assets are acquired, redeployed, or decommissioned.

Inventory records currently maintained through SharePoint and spreadsheets are reviewed and reconciled on a periodic basis by the service desk/infrastructure function, with the intent of consolidating tracking into a dedicated asset management capability (e.g., a GRC/asset module) as the organization matures its tooling. Records identify, at minimum, asset type, owner, location or hosting environment, and status (active, retired, disposed).

## Evidence Request

If using a dedicated asset module: Provide a generated report showing asset details, ownership assignments, and a log of asset management activity demonstrating regular updates and accurate tracking.

If using spreadsheets/SharePoint: Submit the current documented inventory of assets, categorized by type (hardware, software/application components, databases, data assets, cloud/vendor services), including ownership, location, and status, along with evidence of periodic review/reconciliation.