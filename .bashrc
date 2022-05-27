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
