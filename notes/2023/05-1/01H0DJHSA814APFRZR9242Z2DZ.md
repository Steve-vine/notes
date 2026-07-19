---
id: 01H0DJHSA814APFRZR9242Z2DZ
created: 2023-05-14T16:47:25Z
updated: 2023-05-14T16:51:15Z
type: memo
title: kubectl krew
---
14-05-2023 17:47

Tags: #krew #kubectl


---
Krew is the plugin manager for `kubectl` command-line tool.
https://krew.sigs.k8s.io/docs/user-guide/setup/install/

Install krew
```Bash
(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz" &&
  ./"${KREW}" install krew
)
```

Add path variable

#### Mac OS
Add following line to ~/.zshrc
```Bash
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
```

---
## References