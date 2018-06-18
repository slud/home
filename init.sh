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

echo "Checking VundleVim if repo exists in" $HOME"/.vim/bundle/Vundle.vim"

#if ! [ -d $HOME/.vim/bundle/Vundle1 ]
#then
#  echo "fgffffffffff"
#fi

if [ -d $HOME/.vim/bundle/Vundle.vim ]
then
  echo "Vundle already exists. Skipping cloning..."
else
  echo "No VundleVim repo. Cloning..."
  git clone https://github.com/VundleVim/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
fi

print_sep

echo "Setting up .vimrc to use github version."


function link_vimrc()
{
  echo "Linking .vimrc from" $PWD/.vimrc
  if [ ! -f $PWD/.vimrc ]
  then
    echo "No" $PWD"/.vimrc file. No linking performed."
  else
    ln -s $PWD/.vimrc $HOME/.vimrc
  fi
}

if [ -f $HOME/.vimrc -o -L $HOME/.vimrc ]
then
  echo $HOME/".vimrc already exists. Replace [y/n]?"
  read replace_vimrc
  if [ "$replace_vimrc" == "y" ]
  then
    echo "Deleting old .vimrc"
    rm $HOME/.vimrc
    link_vimrc 
  fi
else
 link_vimrc 
fi

print_sep

echo "Including" $PWD/.bashrc_common "in" $HOME/.bashrc

if [ -f $HOME/.bashrc -o -L $HOME/.bashrc ]
then
  has_bashrc=`grep paza_bashrc_included ~/.bashrc`
  echo "has_bashrc var is ["$has_bashrc"]"
  if [ "$has_bashrc" == "" ]
  then
    echo "Seems like bashrc_common hasn't been included yet on this system."
    echo "Including it in" $HOME/.bashrc
    echo "" >> $HOME/.bashrc
    echo "#paza_bashrc_included" >> $HOME/.bashrc
    echo ". "$PWD/.bashrc_common >> $HOME/.bashrc
  else
    echo $HOME/.bashrc already includes $PWD/.bashrc_common", skipping..."
  fi
fi

print_sep

echo Finished
