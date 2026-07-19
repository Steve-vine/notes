---
id: 01JW8RNFJB4BTCBX8HE4DTA9BH
created: 2025-05-27T11:39:54.827Z
updated: 2025-05-27T11:59:29.515Z
type: memo
title: Setting up an SSL Cert using Let's Encrypt
---
27-05-2025 12:39

Tags: #lets-encrypt #cloudflare


---
### Pre-requisites

This also uses Cloudflare to provide certificate authority so a a Cloudflare account with the domain name to be used is required.

### Process

In pfSense web console, do to **System->Package Manager** and install the **ACME** package

Go to **Services->Acme Certificates->Account Keys** and click **Add**
Complete the details using the "Let's Encrypt Staging" **ACME Server**
Click **Add new account key** followed by **Register ACME account key**
Then click **Save**

Go to **Services->Acme Certificates->Certificates** and click **Add**
Complete the form selecting the Account Key just created as the **ACME Account**
In the Domain SAN List, select **DNS-Clousflare** as the **Method**
Enter the **Token**, **Token Zone ID** and **Token Account ID**. 
The ID's can be found on the domain page in Cloudflare
![[CleanShot 2025-05-27 at 12.54.29@2x.png]]
Create an API Token under **Manage Account->Account API Tokens**
Click **Save**, then click on **Issue/Renew** to generate the cert

Go to **Services->Acme Certificates->General Settings** and tick **Cron Entry** to automate renewal.

Go to **System->Advanced** and change **SSL/TLS Certificate** to the new cert.  
Click **Save**



---
## References