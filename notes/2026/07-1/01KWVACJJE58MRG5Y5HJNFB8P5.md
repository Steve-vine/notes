---
id: 01KWVACJJE58MRG5Y5HJNFB8P5
created: 2026-07-06T08:58:15.502Z
updated: 2026-07-06T08:58:15.502Z
type: memo
title: G5 Rebuild Procedure
---
# G5 Rebuild Procedure

**Created:** 2026-07-05
**Host:** g5 / g5.citops.net / 192.168.1.5
**Role:** Dev box + single-node k3s cluster
**Base OS:** Ubuntu 26.04 LTS Server (2TB disk)

Rebuild time estimate: ~1 hour. Config lives in `~/code/g5` on the Mac (Helm values) and the dotfiles repo.

---

## 1. Base OS install

1. Install Ubuntu Server 26.04 LTS, user `steve`, hostname `g5`, LVM layout (default).
2. Static IP / DHCP reservation for **192.168.1.5** (DNS `g5.citops.net` and `zot.citops.net` point here).
3. **Expand the root LV** -- default install leaves most of the disk unused:
   ```bash
   sudo lvextend -l +100%FREE /dev/ubuntu-vg/ubuntu-lv
   sudo resize2fs /dev/mapper/ubuntu--vg-ubuntu--lv
   df -h /   # expect ~1.7T
   ```
4. Patch:
   ```bash
   sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
   ```

## 2. Shell & CLI tooling

```bash
sudo apt install -y mosh tmux zsh zoxide eza docker.io
chsh -s $(which zsh)
sudo ufw allow 60000:61000/udp   # mosh (if ufw enabled)
curl -s https://ohmyposh.dev/install.sh | bash -s   # oh-my-posh -> ~/.local/bin
```

Dotfiles: clone the dotfiles repo and link `.zshrc`, `.tmux.conf` (contains `set -g mouse on`). Key `.zshrc` lines:

```bash
export PATH="$HOME/.local/bin:$PATH"
eval "$(oh-my-posh init zsh --config <theme>)"
eval "$(zoxide init zsh)"
alias ls='eza'
alias ll='eza -l'
```

## 3. Git / GitHub

```bash
ssh-keygen -t ed25519 -f ~/.ssh/github -C "mail@stevevine.uk"
```

Add the public key to https://github.com/settings/keys (account `steve-vine`), then `~/.ssh/config`:

```
Host github.com
  IdentityFile ~/.ssh/github
  IdentitiesOnly yes
```

```bash
git config --global user.name "Steve Vine"
git config --global user.email "mail@stevevine.uk"
ssh -T git@github.com   # verify
```

## 4. Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude   # login on first run; claude doctor to verify
```

## 5. k3s + cluster tooling

```bash
curl -sfL https://get.k3s.io | sh -
mkdir -p ~/.kube
sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config
sudo chown steve:steve ~/.kube/config && chmod 600 ~/.kube/config
```

> Note: current cluster runs Traefik in its own `traefik` namespace plus MetalLB (`metallb-system`) -- installed separately from k3s defaults. MetalLB has **no IPAddressPool configured**; Traefik is reached via ports 80/443 on the node (192.168.1.5) directly.

CLI tools:

```bash
# kubie
curl -Lo kubie https://github.com/sbstp/kubie/releases/latest/download/kubie-linux-amd64
chmod +x kubie && sudo mv kubie /usr/local/bin/
# helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

On the Mac: copy kubeconfig to `~/.kube/g5.yaml`, edit server to `https://g5.citops.net:6443`.

## 6. Workloads (run from the Mac, kubeconfig `~/.kube/g5.yaml`)

### 6.1 cert-manager + Let's Encrypt

```bash
helm repo add jetstack https://charts.jetstack.io
helm upgrade --install cert-manager jetstack/cert-manager \\
  -n cert-manager --create-namespace --set crds.enabled=true \\
  --kubeconfig ~/.kube/g5.yaml
```

Copy the Cloudflare DNS01 token secret + ClusterIssuer from ec2-testbox (canonical pattern):

```bash
kubectl --kubeconfig ~/.kube/ec2-testbox.yaml -n cert-manager get secret cloudflare-api-token -o json \\
  | jq 'del(.metadata.uid,.metadata.resourceVersion,.metadata.creationTimestamp,.metadata.annotations,.metadata.managedFields)' \\
  | kubectl --kubeconfig ~/.kube/g5.yaml -n cert-manager apply -f -

kubectl --kubeconfig ~/.kube/ec2-testbox.yaml get clusterissuer letsencrypt-prod -o json \\
  | jq 'del(.metadata.uid,.metadata.resourceVersion,.metadata.creationTimestamp,.metadata.annotations,.metadata.managedFields,.status)' \\
  | kubectl --kubeconfig ~/.kube/g5.yaml apply -f -
```

ClusterIssuer: `letsencrypt-prod`, DNS01 via Cloudflare, secret `cloudflare-api-token` (key `api-token`) in `cert-manager` ns.

### 6.2 Zot OCI registry

Values: `~/code/g5/zot-values.yaml` (20Gi local-path PVC, Traefik ingress `zot.citops.net`, TLS via `letsencrypt-prod`, UI + search enabled, `"compat": ["docker2s2"]` under `http` so Docker can push).

```bash
helm repo add project-zot http://zotregistry.dev/helm-charts
helm upgrade --install zot project-zot/zot -n zot --create-namespace \\
  -f ~/code/g5/zot-values.yaml --kubeconfig ~/.kube/g5.yaml
```

Verify: `curl https://zot.citops.net/v2/` returns 200. Test push: `docker pull alpine && docker tag alpine zot.citops.net/test/alpine && docker push zot.citops.net/test/alpine`. Delete images via API or `crane delete` -- the UI is browse-only.

### 6.3 GitHub Actions runners (ARC)

PAT: 1Password item **"GitHub - G5 Runner API Key"** (classic PAT, `repo` scope, account `steve-vine`).

```bash
# Controller
helm upgrade --install arc \\
  oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set-controller \\
  -n arc-systems --create-namespace --kubeconfig ~/.kube/g5.yaml

# PAT secret
kubectl --kubeconfig ~/.kube/g5.yaml create ns arc-runners --dry-run=client -o yaml | kubectl --kubeconfig ~/.kube/g5.yaml apply -f -
kubectl --kubeconfig ~/.kube/g5.yaml -n arc-runners create secret generic gh-pat \\
  --from-literal=github_token="$(op read 'op://Private/GitHub - G5 Runner API Key/credential')"

# One scale set per repo (workflows use runs-on: <release-name>)
for repo in compass redvektor; do
  helm upgrade --install ${repo}-runners \\
    oci://ghcr.io/actions/actions-runner-controller-charts/gha-runner-scale-set \\
    -n arc-runners --kubeconfig ~/.kube/g5.yaml \\
    --set githubConfigUrl=https://github.com/steve-vine/${repo} \\
    --set githubConfigSecret=gh-pat
done
```

Repo-level registration only (personal account -- no org-level runners). Default runner image has no Docker; enable dind mode if image builds are needed.

## 7. Backups

- Timeshift -> USB disk for system snapshots (`sudo apt install timeshift`).
- This document + `~/code/g5` values files + dotfiles repo = declarative rebuild.
- Refresh package list occasionally: `dpkg --get-selections > packages.txt`.

## 8. Verification checklist

- [ ] `df -h /` shows ~1.7T
- [ ] mosh + tmux session from Mac works
- [ ] `ssh -T git@github.com` authenticates
- [ ] `kubectl get nodes` (local and from Mac) -- g5 Ready
- [ ] `curl https://zot.citops.net/v2/` returns 200, cert valid (Let's Encrypt)
- [ ] Docker push to zot succeeds
- [ ] ARC listeners running: `kubectl -n arc-systems get pods`
- [ ] Test Actions run on `runs-on: compass-runners`
