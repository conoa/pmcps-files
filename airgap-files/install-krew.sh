#!/bin/bash

sudo apt update
sudo apt install curl git -y

(
  set -x; cd "$(mktemp -d)" &&
  OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
  ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
  KREW="krew-${OS}_${ARCH}" &&
  curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
  tar zxvf "${KREW}.tar.gz"
)
./krew-linux_amd64 install krew
echo "kubectl krew version"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH" && bash

kubectl krew install allctx assert blame ca-cert cautious change-ns clog cnf cond config-cleanup count ctr ctx debug-shell deprecations doctor duplicate example get-all image images janitor ktop ns oidc-login pod-logs service-tree sql stern tail tree view-quotas view-utilization access-matrix


