#eval "$(thefuck --alias)"

alias nixpurge-old='sudo nix-collect-garbage --delete-older-than 3d'
alias nixgenerations='sudo nix-env -p /nix/var/nix/profiles/system --list-generations'

alias nixupgrade='sudo nixos-rebuild --impure --flake /home/vboysepe/.config/nixos switch'
alias nixupgradeext='sudo nixos-rebuild --impure --builders "ssh://root@triforce.fac.cs.cmu.edu x86_64-linux,i686-linux /home/vboysepe/.ssh/id_rsa 200" --max-jobs 0 --flake /home/vboysepe/.config/nixos switch'
alias nixupgradeext8='sudo nixos-rebuild --impure --builders "ssh://root@triforce.fac.cs.cmu.edu x86_64-linux,i686-linux /home/vboysepe/.ssh/id_rsa 8" --max-jobs 2 --flake /home/vboysepe/.config/nixos switch'
alias nixupdate='sudo nixos-rebuild switch'


alias config='/run/current-system/sw/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

alias ka='kinit vboysepe/admin'
alias kr='kinit vboysepe/root'

alias chpkg='nano .config/nixos/programs.nix'
alias chcfg='nano .config/nixos/configuration.nix'

#vpn
alias cmuvpn='sudo openconnect --protocol=anyconnect --user=vboysepe --authgroup="Campus VPN" vpn.cmu.edu'
alias umvpn='sudo openconnect --protocol=anyconnect --authgroup="Campus VPN" umvpn3.umnet.umich.edu'

alias updateChannel='sudo nix-channel --remove nixos 
sudo nix-channel --add https://nixos.org/channels/nixos-22.05 nixos
sudo nix-channel --list
sudo nix-channel --update'

alias df='df -h'

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
