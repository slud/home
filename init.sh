#!/bin/bash

cols_num=$(tput cols)

function print_sep()
{
  local sep=""
  for i in $(seq 1 $cols_num)
  do
    sep+='-'
  done
  echo $sep
}


echo $HOME 'dir will be used. Is that OK [y/n]?'

read use_home

if [ "$use_home" != "y" ]
then
  echo "You said no."
  exit 0
fi

echo "Using" $HOME "as a deployment dir."

print_sep

echo "Checking VundleVim repo exists in" $HOME"/.vim/bundle/Vundle"

#if ! [ -d $HOME/.vim/bundle/Vundle1 ]
#then
#  echo "fgffffffffff"
#fi

if [ -d $HOME/.vim/bundle/Vundle ]
then
  echo "Vundle already exists. Skipping cloning..."
else
  echo "No VundleVim repo. Cloning..."
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle
fi

print_sep

echo "Setting up .vimrc to use github version."

if [ -f $HOME/.vimrc ]
then
  echo $HOME/".vimrc already exists. Replace [y/n]?"
  read replace_vimrc
  if [ "$replace_vimrc" == "y" ]
  then
    echo "Deleting old .vimrc"
    rm $HOME/.vimrc
    ln -s .vimrc $HOME/.vimrc
  fi
else
  ln -s .vimrc $HOME/.vimrc
fi

print_sep

echo Finished
