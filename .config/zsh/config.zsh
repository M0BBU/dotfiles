eval "$(direnv hook zsh)"

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source <(fzf --zsh)

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{green}danielchoo %F{cyan}%~%f %F{red}${vcs_info_msg_0_}%f$ '

alias config='/usr/bin/git --git-dir=$HOME/.mycfg/ --work-tree=$HOME'
alias bupdate="brew update &&\
    brew bundle install --file=~/.config/Brewfile &&\
    brew upgrade"

alias ll='ls -alF --color=auto'
alias arcd='arc diff --noautoland --amend-all --apply-patches --allow-untracked HEAD^'
alias arcl='arc lint --apply-patches'
alias update='git add -A && git commit --amend --no-edit && arcd -m "Update"'

alias ga='git all -A'
alias gcm='git commit -m'
alias grm='git rebase -i main'
alias grc='git rebase --continue'
alias gsw='git switch'
alias gst='git status'
alias gbup=rebase_branch

alias gstash='git add -A && git commit -m "TEMPORARY STASH. DO NOT COMMIT."'
alias gpop='check_git_pop'
function check_git_pop() {
    if [ "$(git log -1 --pretty=%B)" = "TEMPORARY STASH. DO NOT COMMIT." ]; then
        git reset HEAD~1
        echo "Temporary commit reseted!"
    else
        echo "ERROR: HEAD is not a temporary commit."
    fi
}

function rebase_branch() {
    branch="$(git branch --show-current)"
    gsw main
    git pull
    gsw "$branch"
    git rebase main
}
