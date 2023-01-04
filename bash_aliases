# ALIASES AND FUNCTIONS

alias cl="clear"
alias enable-touchpad="xinput enable 'SynPS/2 Synaptics TouchPad'"
alias bfg="java -jar C:/BFG/bfg-1.14.0.jar"
d() { cd "$HOME/Documents/$1" && ls; }
alias w="code -r ."
alias src="source ~/.bashrc ."
alias mini="PS1='$ '"
alias df="df -h"
alias locip="ip a | grep eth0"
alias cdc="cd /c/code"
# Workaround for Storybook compatibility issues
alias oslp="export NODE_OPTIONS=--openssl-legacy-provider"

# Conda shorthand
alias ce="conda info --envs"
alias ca="conda activate"
alias cda="conda deactivate"
alias clist="conda list"
alias cc="conda create -n"
alias cr="conda env remove -n"

# Docker shorthand
alias sd="sudo docker"
alias sdi="sudo docker image"
alias sdis="sudo docker images"
alias sdc="sudo docker container"
alias sdbld="sudo docker build -t"
alias sdrun="sudo docker run -t -d"
alias sdex="sudo docker exec -it"
sdpsh() { sudo docker push "johnnymcgee/$1"; }
alias sdpl="sudo docker pull"
sdplj() { sudo docker pull "johnnymcgee/$1"; }
alias sdcomp="sudo docker compose"
alias sdclear="sudo docker container rm -f $(sudo docker container ls -aq) && sudo docker image rm -f $(sudo docker image ls -q)"

# Flutter tool
alias fclnup="flutter clean && flutter pub get && flutter pub upgrade"
alias frun="flutter run -v"
alias ftst="flutter test"
alias fbr-watch="flutter pub run build_runner watch"
alias fbr-build="flutter pub run build_runner build"

alias fa-bb="adb shell setprop debug.firebase.analytics.app com.juliankohann.bubblebrawl"

# Google Drive Shorthand
alias pg="sudo docker exec -it search pirate-get"
alias rt="sudo docker exec -it download rtorrent -d /root/files"
alias gd="sudo docker exec -it upload gdrive"
alias torrents="sudo docker exec -it download ls -Alh"
alias files="sudo docker exec -it upload ls -Alh"
alias files-up="sudo docker exec -it upload ./upload.sh"
alias files-cl="sudo docker exec -it upload ./clear.sh"
alias torrents-down="sudo docker exec -it download ./download.sh"
alias torrents-cl="sudo docker exec -it download ./clear.sh"

# Git shorthand
# No arguments: `git status`
# With arguments: acts like `git`
g() {
  if [[ $# > 0 ]]; then
    git $@
  else
    git status
  fi
}

# Github shorthand

alias prdev="gh pr create -B dev -l enhancement -a @me -b '' -t"
alias prmd="gh pr merge -rd && git fetch && g sla"
function pdprmd() {
  git psuoc
  gh pr create -B dev -a @mea -b '' -t $1
  gh pr merge -rd && git fetch && g sla
}

# VirtualBoxManager
vm() {
  if [[ $# > 0 ]]; then
    VBoxManage $@
  else
    VBoxManage list vms
  fi
}

# General
function mcd() {
  mkdir $1
  cd $1
}

function tree() {
  clear
  cmd //c tree $1 //f
}
function cln() {
  git clone "https://github.com/JohnnyMcGee/${1}"
}

# clone over ssh
function scln() {
  git clone "git@github.com:JohnnyMcGee/${1}.git"
}

# search network listeners for given string
# slightly different options for windows (Msys) version
function netgrep() {
  if [ "Msys" = "$(uname -o)" ]; then
    netstat -ano | findstr LISTENING | findstr $@

  else
    netstat -anolp | grep $@
  fi
}
