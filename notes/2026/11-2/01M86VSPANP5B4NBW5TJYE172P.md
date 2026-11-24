---
id: 01M86VSPANP5B4NBW5TJYE172P
created: 2026-11-24T13:26:49.941142Z
updated: 2026-11-24T15:32:29.75634Z
type: memo
title: SOC2 In-scope systems
project: 01KY4JNC6MPPNNFXN416S398SG
company:
- moneypenny
scope:
- work
---
## Products
* Telephone Answering Service (TAS)
* AI Receptionist

## Locations
* Wrexham office
* Atlanta office
* AWS (Production)
* AWS (VoiceNation)
* Azure (Production)

## Systems
### Telephone Answering Service (TAS)
#### Kora
* AWS (Production)
  * Kubernetes (openanswer namespace) - UK
  * RDS Database master/slave - UK
  * Kubernetes (openanswer namespace) - US
* AWS (VoiceNation)
  * RDS Database master/slave - US
* SendGrid (Email)
* Twilio (Telephony)
* Genesys (Telephony)
* Magrathea (Telephony)
* Bandwidth (Telephony)
* Azure/EntraID (user authentication)

### AI Receptionist
* AWS (Production) version 2
  * Kubernetes (chinwag-v2 namespace) - UK
  * Kubernetes (deepgram-flux namespace) - UK
  * Kubernetes (chinwag-v2 namespace) - US
  * Kubernetes (deepgram-flux namespace) - US
* AWS (Chinwag) version 1
  * Kubernetes (chinwag namespace) - UK
  * Kubernetes (deepgram namespace) - UK
  * Kubernetes (chinwag namespace) - US
  * Kubernetes (deepgram namespace) - US
* MongoDB Altas (Database)
* Cartesia (TTS)
* LiveKit (Telephony)
* RunPod (GPU hosting)
* Cerebras (Inference)
* Auth0 (User authentication)
* Composio (Third party integration)
* SendGrid (Email)
* Magrathea (Telephony)
* Bandwidth (Telephony)
* Google Places (Geo data)

### Integrations
* AWS (Production)
  * Kubernetes (integrations namespace) - UK
* MongoDB Altas (Database)
