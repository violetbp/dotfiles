#eval "$(thefuck --alias)"

alias nix-purge-old='sudo nix-collect-garbage --delete-older-than 10d'
alias nix-generations='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'
alias nixupgrade='sudo nixos-rebuild switch --upgrade'
alias nixupdate='sudo nixos-rebuild switch'


alias config='/run/current-system/sw/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
