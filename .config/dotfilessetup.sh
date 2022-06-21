#git clone --bare https://github.com/violetbp/dotfiles.git
#not actually sure any of this works its far from perfect

git clone --bare git@github.com:violetbp/dotfiles.git  $HOME/.cfg
alias config='/run/current-system/sw/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
config config --local status.showUntrackedFiles no
