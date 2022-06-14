# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#ZSH_DISABLE_COMPFIX=true
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#export TERM="xterm-256color"

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#source ~/.fonts/*.sh
#POWERLEVEL9K_MODE='nerdfont-complete'
#ZSH_THEME="powerlevel9k/powerlevel9k"
#ZSH_THEME="awesomepanda"

#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir_writable dir vcs )
#POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir_writable dir )
#POWERLEVEL9K_PROMPT_ON_NEWLINE=true
#POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
#POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
#POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "

# create a $fill of all screen width minus the time string and a space:
precmd() { print '' }

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )
ZSH_THEME="codespaces"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  bundler
  dotenv
  zsh-history-substring-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
function blt() {
  if [[ ! -z ${AH_SITE_ENVIRONMENT} ]]; then
    PROJECT_ROOT="/var/www/html/${AH_SITE_GROUP}.${AH_SITE_ENVIRONMENT}"
  elif [ "`git rev-parse --show-cdup 2> /dev/null`" != "" ]; then
    PROJECT_ROOT=$(git rev-parse --show-cdup)
  else
    PROJECT_ROOT="."
  fi

  if [ -f "$PROJECT_ROOT/vendor/bin/blt" ]; then
    $PROJECT_ROOT/vendor/bin/blt "$@"

  # Check for local BLT.
  elif [ -f "./vendor/bin/blt" ]; then
    ./vendor/bin/blt "$@"

  else
    echo "You must run this command from within a BLT-generated project."
    return 1
  fi
}
#export PATH="/usr/local/opt/node@12/bin:$PATH"
eval "$(starship init zsh)"
eval $(thefuck --alias oi)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Custom functions/Aliases

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

