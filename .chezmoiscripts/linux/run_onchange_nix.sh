#!/usr/bin/env bash
nix profile upgrade '.*'
nix profile install nixpkgs#{aws-vault,awscli2,bandwhich,dbmate,delta,dua,eksctl,fennel,fzf,gdu,hledger,hledger-ui,hledger-web,k6,k9s,krew,kubectl,kubeswitch,ledger,less,lf,miller,nethogs,nnn,nushell,peco,pspg,speedtest-cli,vifm}
krew install krew
