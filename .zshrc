alias config='/usr/bin/git --git-dir=$HOME/.mycfg/ --work-tree=$HOME'
alias bupdate="brew update &&\
    brew bundle install --cleanup --file=~/.config/Brewfile &&\
    brew upgrade"
