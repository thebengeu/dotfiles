#!/usr/bin/env sh
kubectl krew index add kvaps https://github.com/kvaps/krew-index
kubectl krew index add netshoot https://github.com/nilic/kubectl-netshoot.git

kubectl krew install \
  explore \
  fuzzy \
  ice \
  kvaps/node-shell \
  lineage \
  netshoot/netshoot \
  tail
