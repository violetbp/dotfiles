#eval "$(thefuck --alias)"

alias nixpurge-3d='sudo nix-collect-garbage --delete-older-than 3d'
alias nixgenerations='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'

alias nixupdate='sudo nixos-rebuild switch'

alias nixupgrade='sudo nixos-rebuild --impure --flake /home/vboysepe/.config/nixos switch'


#alias nixupgradeext='sudo nixos-rebuild --impure --builders "ssh://root@triforce.fac.cs.cmu.edu x86_64-linux,i686-linux /home/vboysepe/.ssh/id_rsa 200" --max-jobs 0 --flake /home/vboysepe/.config/nixos switch'
#alias nixupgradeext8='sudo nixos-rebuild --impure --builders "ssh://root@triforce.fac.cs.cmu.edu x86_64-linux,i686-linux /home/vboysepe/.ssh/id_rsa 8" --max-jobs 2 --flake /home/vboysepe/.config/nixos switch'

alias flakeupdate='nix flake update ~/.config/nixos'

alias config='/run/current-system/sw/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'


alias chpkg='nano ~/.config/nixos/programs.nix'
alias chcfg='nano ~/.config/nixos/configuration.nix'

#vpn
alias umvpn='sudo openconnect --protocol=anyconnect --authgroup="Campus VPN" umvpn3.umnet.umich.edu'

alias updateChannel='sudo nix-channel --remove nixos 
sudo nix-channel --add https://nixos.org/channels/nixos-23.05 nixos
sudo nix-channel --list
sudo nix-channel --update'

alias df='df -h'

alias EWW="eww -c $HOME/.config/hypr/themes/neon/eww/"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#[ [ -s "$HOME/.rvm/scripts/rvm" ] ] && source "$HOME/.rvm/scripts/rvm"
#export PATH="$PATH:$HOME/.rvm/bin"

#nu



alias configfiles="GIT_WORK_TREE=$HOME GIT_DIR=$HOME/.cfg"
alias configcode="configfiles code ~/.config"
alias confignix="configfiles code ~/.config/nixos"

