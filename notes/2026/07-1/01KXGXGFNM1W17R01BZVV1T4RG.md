---
id: 01KXGXGFNM1W17R01BZVV1T4RG
created: 2026-07-14T18:16:29.620626927Z
updated: 2026-07-14T18:16:29.620626927Z
type: task
title: Deploy Compass on new server
task_status: done
priority: medium
assignee: steve
project: 01KXGC5PTGYHV30VM3E78G76S1
number: 158
---
I have created a new server to run Compass on, going forward I'll refer to that as g5.  All of the dependancies have been installed but do check first.
You are currently running on the g5 server.  The context is at ~/.kube/g5.yaml
Before continuing, enter plan mode so we can address the following changes and requirements.

* I have made changes to the workflow we will follow going forward.  This are documented in CLAUDE.md - How We Work section.  Review this first to ensure you understand and ask any questions you have.  I have not updated any other documents so please review documents in /brief /docs and /decisions to make sure there are no ambiguities.  Short version, all issues will be created on a feature branch and merged into staging, staging will be deployed into the cluster for testing and later merged into main.
* GitHub runners have been setup in this cluster and are setup in GitHub as compass-runners.  All actions should now use these rather than running in GitHub.  Review the CI pipeline and amend as necessary.
* Image repo.  previously you build images and coped them into the cluster.  The g5 cluster is running zot (zot.citops.net) - All images should be pushed here going foward once in staging and deployed from this repo.  This will more closely resemble the eventual prod environment for deployments and updates.

Next steps should be to discuss with me in planning mode how we get from here to a working Compass deployment in g5, using local runners, building the images and pushing to zot, and understanding the new way of working.  Finally updating any appropriate documentation.

---
*Migrated from Linear [DEV-845](https://linear.app/stevevine/issue/DEV-845/deploy-compass-on-new-server) · created 2026-07-05 · completed 2026-07-05*  
*Related to (Linear): DEV-855, DEV-854, DEV-853, DEV-852*