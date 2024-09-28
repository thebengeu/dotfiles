#!/usr/bin/env bash
nix profile upgrade '.*'
nix profile install nixpkgs#{aws-vault,awscli2,bandwhich,dbmate,delta,eksctl,fennel,fzf,hledger,hledger-ui,hledger-web,k6,ledger,less,lf,miller,nethogs,nnn,nushell,peco,pspg,vifm}
