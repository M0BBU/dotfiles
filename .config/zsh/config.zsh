eval "$(direnv hook zsh)"

export EDITOR="vim"

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source <(fzf --zsh)

autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{green}danielchoo %F{cyan}%~%f %F{red}${vcs_info_msg_0_}%f$ '

case ":${PATH}:" in
    *:"$HOME/.bin":*)
        ;;
    *)
        export PATH="$HOME/.bin:$PATH"
        ;;
esac

if ! type "gs" >/dev/null 2>/dev/null; then
    mkdir -p "$HOME/.bin"
    cd "$HOME/.gitspice"
    go build -o "$HOME/.bin"
fi

alias config='/usr/bin/git --git-dir=$HOME/.mycfg/ --work-tree=$HOME'
alias bupdate="brew update &&\
    brew bundle install --file=~/.config/Brewfile &&\
    brew upgrade"

alias ll='ls -alF --color=auto'
alias arcd='arc diff --noautoland --amend-all --apply-patches --allow-untracked HEAD^'
alias arcl='arc lint --apply-patches'
alias update='gca && arhp --no-interactive'

alias ga='git all -A'
alias gcm='git commit -m'
alias grm='git rebase -i main'
alias grc='git rebase --continue'
alias gsw='git switch'
alias gst='git status'
alias gbup=rebase_branch

alias arhp='arh publish --apply-fixes'
alias gbc=git_branch_create
alias gcc='gs cc -a -m'
alias gca='gs ca -a --no-edit'
alias resync='gs rs && gs rr'
function git_branch_create() {
    if [ $# -eq 0 ]; then
        echo "No arguments provided. Exiting."
        return 1
    fi

    parent="$(git rev-parse --abbrev-ref HEAD)"
    gs bc $1 --no-commit
    git branch --set-upstream-to=$parent
}

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

function exists() {

}
