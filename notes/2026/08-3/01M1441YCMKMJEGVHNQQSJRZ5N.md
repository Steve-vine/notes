---
id: 01M1441YCMKMJEGVHNQQSJRZ5N
created: 2026-08-28T12:03:32.884411Z
updated: 2026-08-28T14:43:02.238695Z
type: memo
title: Chinwag-V2 Nginx configuration issues
---
### Temporary design
The Nginx design was only intended to be temporary. Both the Nginx conf and the REACT Dockerfile say so.

The nginx config describes itself as "a proxy that mirrors the Vite dev server" and says: "Behind an external ingress that routes /api and /worker itself, drop those two blocks." The Dockerfile repeats it: "Drop the proxy blocks in the nginx config if an external ingress routes those instead." We then built the external ingress and kept the blocks — and have since added two more routes (/numbers-api, /billing-api) to a mechanism its own author marked for deletion. Billing would be the third.

---

### Backwards dependancy
The admin console is a customer of the billing API, not its front door. Right now Stripe's webhook address is defined by a config file inside the UI's container, so a third party's connection to the billing system is owned by the team that ships the web front-end, in a different repo. Any future API clients have to come in through the console too.

---

### A UI deploy is now a billing outage
Everything reaches the backend through one container. Restart or roll the console and the Stripe webhook path goes with it. We've already had to work around a related version of this, nginx refuses to start if any backend name is missing, which would take the whole console down over one unused service, so the chart now has to create placeholder entries for services that aren't even switched on.

---

### UI Pod sizing is difficult
The UI pod is sized to serve web pages, but it's doing a lot more. It's allocated the resources of a static file server, yet it's also carrying live streaming chat sessions, phone-number provisioning and payment webhooks. If webhook traffic grows, the only lever is to scale the web front-end.

---

### We can't see or control the traffic separately
To all our monitoring, every backend request appears to come from "the UI". We can't rate-limit the Stripe endpoint, restrict it by source, or alert on it without applying the same rules to the entire admin console. Same for the network rules — the UI has to be allowed to talk to everything, so we can't lock anything down. For a backend service to be accessible on the internet, so is the web UI.

---

### We're running two routing systems and only one is visible
The cluster already has a routing layer that's managed through config. This second one lives inside an application container image, which means a routing change needs a code change, an image build and a deploy, and none of our platform tooling knows it exists.

---

#### Alternative context
We've made the reception desk also be the switchboard, the post room and the card machine — so nobody can redecorate reception without stopping payments.

---

# Way Forward

1. Developers don't use the nginx proxy at all. The inner loop runs docker-compose.override.yml, which targets the deps stage — the Vite dev server. The proxying devs actually rely on lives in vite.config.ts, and it already handles all four prefixes with the same rewrites. The nginx blocks only exist in the prod stage, which is the "run the production image locally" path, not the daily loop.

2. The Stripe webhook never touches the gateway in dev. The runbook has devs run stripe listen --forward-to localhost:5080/webhooks/stripe — straight at the service. The /billing-api/webhooks/stripe path is a production-only construct that no developer ever exercises.

3. The routing rules are already written twice and diverging. Once in vite.config.ts, once in react_ui.nginx.conf, and zero times in the thing that actually fronts production. That's not parity — that's two copies of a rule with no test that they agree.

So the honest reading is that nginx was made to imitate Vite, not to imitate production. The parity was achieved by making prod look like dev.

---

