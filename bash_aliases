# ALIASES AND FUNCTIONS
# Conda shorthand
alias ce="conda info --envs"
alias ca="conda activate"
alias cda="conda deactivate"
alias clist="conda list"
alias cc="conda create -n"
alias cr="conda env remove -n"
alias bfg="java -jar C:/BFG/bfg-1.14.0.jar"

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

# General

function mcd () {
    mkdir $1;
    cd $1;
}

function tree () {
    clear;
    cmd //c tree $1 //f;
}

function d () {
    cd ~/Documents/;
    ls;
}