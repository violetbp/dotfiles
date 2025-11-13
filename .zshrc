
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"


setopt no_nomatch
alias feh="feh -F -. -Z"
alias jour='journalctl -ef'

alias nixpurge-3d='sudo nix-collect-garbage --delete-older-than 3d'
alias nixgenerations='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'

alias nixupdate='sudo nixos-rebuild switch'

alias nixupgrade='sudo nixos-rebuild --impure --flake /home/vboysepe/.config/nixos switch'



alias flakeupdate='sudo nix flake update --flake /home/vboysepe/.config/nixos/'

alias config='/run/current-system/sw/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


alias chpkg='nano ~/.config/nixos/programs.nix'
alias chcfg='nano ~/.config/nixos/configuration.nix'



alias df='df -h'


alias configfiles="GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.cfg"
alias configcode="configfiles code ~/.config"
alias confignix="configfiles code ~/.config/nixos"
