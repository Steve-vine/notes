---
id: 01H0CZRZQGPKACB86RPPN8XDDA
created: 2023-05-14T11:19:18Z
updated: 2023-05-19T10:41:23Z
type: memo
title: Generate Self Signed SSL Cert
imported_from: Obsidian
---
14-05-2023 12:20

Tags: #ssl #certificatre

---
## Generating the cert

Generate a 4096 bit private CA key
```Bash
openssl genrsa -aes256 -out ca-key.pem 4096
```

Generate CA Certificate valid for 10 years
```Bash
openssl req -new -x509 -sha256 -days 3650 -key ca-key.pem -out ca.pem
```

Generate a 4096 bit private cert key
```Bash
openssl genrsa -out cert-key.pem 4096
```

Generate certificate signing request
```Bash
openssl req -new -sha256 -subj "/CN=home.lan" -key cert-key.pem -out cert.csr
```

Create config file
```Bash
echo "subjectAltName=DNS:*.home.lan" >> extfile.cnf
```
Generate certificate
```Bash
openssl x509 -req -sha256 -days 3650 -in cert.csr -CA ca.pem -CAkey ca-key.pem -out cert.pem -extfile extfile.cnf -CAcreateserial 
```

Create the full keycain
```bash
cat cert.pem > fullchain.pem
cat ca.pem >> fullchain.pem
```

## Installing and trusting the cert

#### Install the cert on the device
Copy the output of the cert-key.pem into the Private Key field
Copy the output of fullchain.pen into the Certificate Chain field

#### Trust the CA on the client
Import ca.pem into the trusted root CA on the client and set it to always trusted

Windows
```Bash
Import-Certificate -FilePath "C:\ca.pem" -CertStoreLocation Cert:\LocalMachine\Root
```

Ubuntu
Move the CA certificate (`ca.pem`) into `/usr/local/share/ca-certificates/ca.crt`.
```Bash
sudo update-ca-certificates
```

---
## References
https://github.com/ChristianLempa/cheat-sheets/blob/main/misc/ssl-certs.md