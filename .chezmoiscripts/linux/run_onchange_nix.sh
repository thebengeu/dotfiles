#!/usr/bin/env bash
nix profile upgrade '.*'
nix profile install nixpkgs#{bandwhich,dbmate,delta,fennel,fzf,hledger,hledger-ui,hledger-web,k6,ledger,less,lf,miller,nethogs,nix,nnn,nushell,peco,pspg,vifm}
