---
id: 01KKBBGNSFVJBFC6W3KJ6V9057
created: 2026-03-10T07:48:51.119932505Z
updated: 2026-03-11T20:09:42.599560931Z
type: memo
title: Deepgram
imported_from: Obsidian
---
10-03-2026 07:48

Tags: 


---
## ToDo
- [ ] Create initial template
- [ ] At some point this should be put behind an API key

## Notes
Self-hosting Deepgram services involves a few pieces of authentication,
running several container images, and exposing necessary config files and models.

Our documentation includes a series of guides that will take you through the steps of
provisioning hardware, configuring your deployment environment, generating credentials, 
deploying Deepgram services, and maintaining and scaling your environment. 
The series of guides start at this link:
https://developers.deepgram.com/docs/self-hosted-introduction

In the guides, you will be prompted to download models into a models directory. If you already 
have an existing self-hosted environment, you can download these newly provided models alongside
your currently deployed models. 

These model files are available for download from Amazon S3 at the following links.
Files:
  https://deepgram-self-hosted.s3.us-east-2.amazonaws.com/658fd240-7f2e-4413-9685-6284ec483758/models/entity-detector.batch.06bc8f36.dg
  https://deepgram-self-hosted.s3.us-east-2.amazonaws.com/658fd240-7f2e-4413-9685-6284ec483758/models/nova-3-general.en.streaming.40bd3654.dg
  https://deepgram-self-hosted.s3.us-east-2.amazonaws.com/658fd240-7f2e-4413-9685-6284ec483758/models/entity-detector.en.streaming.90424f3a.dg
  https://deepgram-self-hosted.s3.us-east-2.amazonaws.com/658fd240-7f2e-4413-9685-6284ec483758/models/flux-general-en.caf79279.dg
  https://deepgram-self-hosted.s3.us-east-2.amazonaws.com/658fd240-7f2e-4413-9685-6284ec483758/models/nova-3-general.en.batch.2187e11a.dg

To utilize all models/features in this deployment, you must upgrade your Deepgram product images to the `251118` self-hosted release or higher.
See the Deepgram Changelog (https://deepgram.com/changelog) for a list of all releases (filter by "Self-Hosted").



To support entity detection, you will need to update your API configuration files.
See https://deepgram.gitbook.io/help-center/self-hosted/how-can-i-enable-entity-detection-in-my-self-hosted-deployment#updating-your-self-hosted-deployment