#!/bin/bash

# This script will create a .gitignore file in the current directory
# it uses GitHub's gitignore templates
# the fist command line argument is the name of template to use

# check if user have git installed
if ! command -v git &> /dev/null
then
    echo "git could not be found"
    exit
fi

# check if gitignore repo is cloned under ~/.config/gitignore.repo
# if not, clone it
if [ ! -d ~/.config/gitignore.repo ]; then
    git clone https://github.com/github/gitignore.git $HOME/.config/gitignore.repo &> /dev/null
fi

# try pulling the latest changes
old_wd=$(pwd)
cd ~/.config/gitignore.repo
git fetch > /dev/null 2>&1
git pull --rebase > /dev/null 2>&1
cd $old_wd

# check if user provided a template name
# if not, ask for it
if [ -z "$1" ]; then
    # list all files ending with .gitignore, remove the .gitignore extension
    # and print them
    echo "Available templates:"
    ls ~/.config/gitignore.repo | grep .gitignore | sed 's/.gitignore//g' | xargs -I {} echo {}
    echo "Please enter the name of the template to use (name.gitignore):"
    read template
else
    template=$1
fi

template_file="$HOME/.config/gitignore.repo/$template.gitignore"

# check if the template exists
if [ ! -f "$template_file" ]; then
    echo "Template $template.gitignore does not exist"
    exit
fi

# copy the template to the current directory
# first check if the file already exists
# if it does, add the template in the beginning of the file
if [ -f .gitignore ]; then
    cp $template_file .gitignore.tmp
    cat .gitignore >> .gitignore.tmp
    mv .gitignore.tmp .gitignore
else
    cp $template_file .gitignore
fi

# add the file to git
# git add .gitignore
