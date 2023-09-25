if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [ -f /etc/bash.command-not-found ]; then
    . /etc/bash.command-not-found
fi

if [ -x "$(command -v exa)" ]; then
    alias ls="exa -1 --classify --group-directories-first"
    alias ll="exa --long --header --classify --icons --group-directories-first --no-permissions"
    alias lp="exa --long --header --classify --icons --group-directories-first"
    alias la="exa -a --long --header --classify --icons --group-directories-first"
    alias lt="exa --tree --long --header --classify --icons --group-directories-first"
    alias t="exa --tree --header --classify --icons --group-directories-first"
fi


#neofetch
export GOPATH="/home/aaron/go"
export PATH="/bin:/home/aaron/anaconda3/condabin:/bin:${PATH}:/usr/local/go/bin:/home/aaron/goL.bin:${PATH}:/opt/gcc-arm-none-eabi/bin:/home/aaron/.cargo/bin:/home/aaron/Downloads/sonar-scanner-4.7.0.2747-linux/bin:/home/aaron/.local/bin"
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k" # set by `omz` Use random for random themes

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"

# Only uncomment one
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# zstyle ':omz:update' frequency 13

# DISABLE_MAGIC_FUNCTIONS="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# COMPLETION_WAITING_DOTS="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=(git gitignore sudo )

source $ZSH/oh-my-zsh.sh
source ~/Documents/d2s2/ngafid2.0/init_env.sh
export CC=gcc
export CXX=g++
export GCC_ARM_TOOLS_PATH=/opt/gcc-arm-none-eabi/bin
export CMAKE_CXX_COMPILER=/opt/gcc-arm-none-eabi/bin/arm-none-eabi-g++
export CMAKE_C_COMPILER=/opt/gcc-arm-none-eabi/bin/arm-none-eabi-gcc

# NGAFID Stuff
export NGAFID_EMAIL_INFO=/home/aaron/Documents/d2s2/ngafid2.0/email_info
export NGAFID_ADMIN_EMAILS="amc9897@rit.edu"
export NGAFID_REPO=~/Documents/d2s2/ngafid2.0
export NGAFID_DATA_FOLDER=/home/aaron/Documents/d2s2/data/NGAFID_DATA/NGAFID_DATA
export NGAFID_PORT=8181 # You can use whatever port you need or want to use
export NGAFID_UPLOAD_DIR=$NGAFID_DATA_FOLDER/NGAFID_UPLOAD
export NGAFID_ARCHIVE_DIR=$NGAFID_DATA_FOLDER/NGAFID_ARCHIVE
export NGAFID_DB_INFO=$NGAFID_REPO/db/db_info.php
export TERRAIN_DIRECTORY=$NGAFID_DATA_FOLDER/NGAFID_GEODATA/terrain
export AIRPORTS_FILE=$NGAFID_DATA_FOLDER/NGAFID_GEODATA/airports/airports_parsed.csv
export RUNWAYS_FILE=$NGAFID_DATA_FOLDER/NGAFID_GEODATA/runways/runways_parsed.csv
export MUSTACHE_TEMPLATE_DIR=$NGAFID_REPO/src/main/resources/public/templates/
export SPARK_STATIC_FILES=$NGAFID_REPO/src/main/resources/public/

export PYTHONPATH=$PYTHONPATH:/home/aaron/Documents/Launch/AWP/src/python_tools 
export vim=nvim

# Ground Station
export GSW_HOME=/home/aaron/Documents/Launch/GSW-2021
alias GSW=/home/aaron/Documents/Launch/GSW-2021
alias gsw_start=/home/aaron/Documents/Launch/GSW-2021/startup/default/start_gsw
alias gsw_shut=/home/aaron/Documents/Launch/GSW-2021/startup/default/shutdown_gsw
 
alias hack="telnet telehack.com"

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# For a full list of active aliases, run `alias`.
alias zshconfig="vim ~/.zshrc"
alias kys="shutdown now"

# Code repo aliases
alias launch="cd ~/Documents/Launch"
alias evt="cd ~/Documents/EVT"
alias lab="cd ~/Documents/d2s2"
alias rit="cd ~/Documents/RIT"

# Dumb git aliases
#alias lg="git commit -am"
#alias gp="git push"
#alias gx="git x"

# snek
alias py="python3.7"


# Java
alias jfxargs="echo --module-path /home/aaron/.java/javafx-sdk-18/lib --add-modules javafx.controls,javafx.fxml,javafx.media"
alias javaswitch="sudo update-alternatives --config java"


alias nitron="ssh amc9897@nitron.se.rit.edu"
alias glados="ssh amc9897@glados.cs.rit.edu"
alias kinks="ssh amc9897@kinks.cs.rit.edu"
alias dsl="ssh amc9897@dsl.cs.rit.edu" # Distributed Systems Lab
alias ngafid_server="ssh aaron@ngafidbeta.rit.edu"
alias ngafid="cd ~/Documents/d2s2/ngafid2.0"
alias sshrig="ssh aaron@NICE_TRY" 
#alias ngafid_server="sh ~/Documents/d2s2/ngafid2.0/run_webserver.sh"

alias subclone="ls | xargs -I{} git -C {} pull"
# alias lpull='find . -type d -name ".git" -print0 | xargs -P 40 -n 1 -0 -I "{}" sh -c "cd \"{}\"/../ && git pull && pwd && echo "-------------------- \n " " \;'
alias llog=" ls | xargs -I{} git -C {} l" 

alias vim="nvim"

# ESP32 
alias get_idf='. $HOME/esp/esp-idf/export.sh'

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/aaron/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/aaron/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/aaron/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/aaron/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
source "$HOME/.cargo/env"

# Load Angular CLI autocompletion.
#source <(ng completion script)

export PATH=$PATH:/home/aaron/.spicetify

eval $(thefuck --alias)

fortune | cowsay
#neofetch --ascii "$(fortune | cowsay)"      
