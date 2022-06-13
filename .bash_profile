#_complete_ssh_hosts ()
HISTCONTROL=ignoreboth

alias wtf="sudo !!"

alias gt="git for-each-ref --sort='*authordate' --format='%(refname:short)' refs/tags"

alias gs='git status'
alias gc='git commit'
alias gco='git checkout'
alias gl='git pull --rebase'
alias gpom="git pull origin master"
alias gpu="git pull"
alias gp='git push'
alias gb='git branch'
alias gba='git branch -a'
alias gsc='chmod 775 sites/default; chmod 775 sites/default/settings.php; git checkout dev sites/default/settings.php'
alias del='git branch -d'
alias ddevel="git diff | egrep 'dpm|dsm|print'"

alias dsi="head -1 readme.md | bash"
alias dli="drush uli france"
alias ds-perm='drush eval "secure_permissions_rebuild();"'

alias ccp="compass compile -e production --force"
alias cw="compass watch --poll"
alias bccp="bundle exec compass compile -e production --force"
alias bcw="bundle exec compass watch --poll"

function tm {
  mv $1 /tmp
}

function title() {
  export PROMPT_COMMAND='echo -ne "\033]0;"'$1'"\007"'
}

source ~/.goto_shortcuts
function short () {
  shortcut=$(pwd)
  echo 'alias .'$1'="cd '$shortcut'"' >> ~/.goto_shortcuts
  source ~/.bash_profile
}
if [ -f "$HOME/.bash_ps1" ]; then
  . "$HOME/.bash_ps1"
fi
