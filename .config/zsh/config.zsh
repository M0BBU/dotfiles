eval "$(direnv hook zsh)"

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

    # For the environments with nix, we need to install go with nix-shell first.
    if type "nix" >/dev/null 2>/dev/null; then
        cd "$HOME/.gitspice"
        nix shell nixpkgs#go
        go build -o "$HOME/.bin"
        exit
        cd "$HOME"
    else
        # Assume go is installed in environments otherwise.
        go build -o "$HOME/.bin"
        cd "$HOME"
    fi
fi

# fun git config
git config --global branch.autoSetupMerge always
git config --global spice.branchCreate.prefix $(whoami)/


alias config='/usr/bin/git --git-dir=$HOME/.mycfg/ --work-tree=$HOME'
alias bupdate="brew update &&\
    brew bundle install --file=~/.config/Brewfile &&\
    brew upgrade"

alias ll='ls -alF --color=auto'
alias arcd='arc diff --noautoland --amend-all --apply-patches --allow-untracked HEAD^'
alias arcl='arc lint --apply-patches'
alias update='gca && arhp --no-interactive'

alias gaa='git all -A'
alias gcm='git commit -m'
alias grm='git rebase -i main'
alias grc='git rebase --continue'
alias gsw='git switch'
alias gst='git status'
alias gbup=rebase_branch

alias arhp='arh publish --apply-fixes'
alias gcc=create_commit
alias gcf='gs cc -a -m'
alias gca='gs ca -a --no-edit'
alias resync='gs rs && gs rr'

alias gstash='git add -A && git commit -m "TEMPORARY STASH. DO NOT COMMIT."'
alias gpop='check_git_pop'

function create_commit() {
    if [ $# -eq 0 ]; then
        echo "No arguments provided. Exiting."
        return 1
    fi

    parent="$(git rev-parse --abbrev-ref HEAD)"
    gs bc -a -m $1
    git branch --set-upstream-to=$parent
}

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

function rtmux() {
    kitten ssh -t $1 "if tmux -qu has; then tmux -qu attach; else EDITOR=hx tmux -qu new; fi"
}

function clipcopy() {
    printf '\033]52;c;%s\a' "$(cat | base64 | tr -d '\n')"
}
