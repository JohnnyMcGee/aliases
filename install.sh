#!/bin/bash

# If .bashrc is in home directory, append script to include bash_aliases file
# Then start a new bash session so .bashrc will be called.
bashrc="$HOME/.bashrc"
echo
echo "LOADING bash_aliases..."
echo "Checking  for file: $bashrc"
if [ -f $bashrc ] ; 
    then
        echo "Found $bashrc"
        fpath="$(pwd)/bash_aliases"
        cmd="\n\nif [ -f '$fpath' ] ; then\n    . $fpath\nfi"
        echo -e $cmd >> $bashrc
        echo "Added bash aliases to $bashrc"
        echo
    else 
        echo -e "FILE NOT FOUND: $bashrc\nCould not load bash aliases.\n"
fi

# If global gitconfig file not found, create one
# Append script to gitconfig file to Include git_aliases file path
gitconfig="$HOME/.gitconfig"
fpath="$(pwd)/git_aliases"
echo
echo "LOADING git_aliases..."
echo "Checking for file: $gitconfig"
if ! [ -f $gitconfig ] ; then
    echo "File not found at $gitconfig"
    echo "Creating file at $gitconfig"
    else
        echo "Found $gitconfig"
    cmd="\n[include]\n    path = $fpath"
    echo -e $cmd >> $gitconfig
    echo "Added git aliases to $gitconfig"
    echo
fi

echo "In order for changes to take effect, you will need to restart the terminal."
echo