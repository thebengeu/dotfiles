#!/usr/bin/env sh
kubectl krew index add kvaps https://github.com/kvaps/krew-index

kubectl krew install \
  browse-pvc \
  explore \
  fuzzy \
  ice \
  kvaps/node-shell \
  lineage \
  tail
