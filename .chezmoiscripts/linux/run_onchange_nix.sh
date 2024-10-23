#!/usr/bin/env bash
nix profile upgrade '.*'
nix profile install nixpkgs#{aws-vault,awscli2,bandwhich,bottom,cointop,croc,dbmate,delta,dsq,dua,dust,eksctl,eza,fennel,fzf,gdu,ghorg,gitui,glow,hledger,hledger-ui,hledger-web,hyperfine,jless,jwt-cli,k6,k9s,krew,kubectl,kubeswitch,lazydocker,lazygit,ledger,less,lf,mdcat,miller,miniserve,navi,nethogs,nnn,nushell,onefetch,peco,pspg,scc,sd,speedtest-cli,shfmt,sq,tealdeer,tere,tokei,todoist,topgrade,usql,vifm,walk,xh,yazi,yj}
krew install krew
