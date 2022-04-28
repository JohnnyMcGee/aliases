
# ALIASES AND FUNCTIONS

alias cl="clear"
alias enable-touchpad="xinput enable 'SynPS/2 Synaptics TouchPad'"
alias bfg="java -jar C:/BFG/bfg-1.14.0.jar"
alias d="cd ~/Documents/ && ls"
alias w="code -r ."

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

# VirtualBoxManager
vm() {
  if [[ $# > 0 ]]; then
    VBoxManage $@
  else
    VBoxManage list vms
  fi
}

# General
function mcd () {
    mkdir $1;
    cd $1;
}

function tree () {
    clear;
    cmd //c tree $1 //f;
}
