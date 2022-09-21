#eval "$(thefuck --alias)"

alias nixpurge-old='sudo nix-collect-garbage --delete-older-than 4d'
alias nixgenerations='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'
alias nixupgrade='sudo nixos-rebuild switch --upgrade'
alias nixupdate='sudo nixos-rebuild switch'


alias config='/run/current-system/sw/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias ka='kinit vboysepe/admin'
alias kr='kinit vboysepe/root'

alias chpkg='nano .config/nixos/programs.nix'
alias chcfg='nano .config/nixos/configuration.nix'

#vpn
alias cmuvpn='sudo openconnect --protocol=anyconnect --user=vboysepe --authgroup="Campus VPN" vpn.cmu.edu'
alias umvpn='sudo openconnect --protocol=anyconnect --authgroup="Campus VPN" umvpn3.umnet.umich.edu'


alias df='df -h'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
