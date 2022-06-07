#git clone --bare https://github.com/violetbp/dotfiles.git


git clone --bare git@github.com:violetbp/dotfiles.git  $HOME/.cfg
alias config='/run/current-system/sw/bin/git --git-dir=$HOME.cfg --work-tree=$HOME'
config config --local status.showUntrackedFiles no
