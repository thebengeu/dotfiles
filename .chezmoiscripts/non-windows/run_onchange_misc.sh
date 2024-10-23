#!/usr/bin/env sh
kubectl krew index add kvaps https://github.com/kvaps/krew-index

kubectl krew install \
  explore \
  fuzzy \
  ice \
  kvaps/node-shell \
  lineage \
  tail
