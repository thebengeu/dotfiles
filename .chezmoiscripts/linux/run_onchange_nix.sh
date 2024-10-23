#!/usr/bin/env bash
nix profile upgrade '.*'
nix profile install nixpkgs#{aws-vault,awscli2,bandwhich,bottom,dbmate,delta,dua,dust,eksctl,eza,fennel,fzf,gdu,gitui,hledger,hledger-ui,hledger-web,hyperfine,jless,jwt-cli,k6,k9s,krew,kubectl,kubeswitch,ledger,less,lf,mdcat,miller,miniserve,navi,nethogs,nnn,nushell,onefetch,peco,pspg,sd,speedtest-cli,tealdeer,tere,tokei,topgrade,vifm,xh,yazi}
krew install krew
