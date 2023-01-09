#!/usr/bin/bash

# add array value based on alias/<filename>.txt
to_installs=(capistrano rails git system)
> alias.txt
for i in ${to_installs[*]}
do
  echo """
#================
#********** $i ************
#================
  """ >> alias.txt
  cat alias/"$i".txt >> alias.txt
done
cp alias.txt .alias

mv .alias $HOME
cd $HOME

#grep -qxF 'source "$HOME/.alias"' .profile || echo 'source "$HOME/.alias"' >> .profile

#grep -qxF 'source "$HOME/.alias"' .bashrc || echo 'source "$HOME/.alias"' >> .bashrc

echo 'source "$HOME/.alias"' >> .bashrc
source .bashrc

#echo 'source "$HOME/.alias"' > ~/.oh-my-zsh/custom/alias88.sh

sed -i '$r .alias' .zshrc
#source .zshrc

echo "往bashrc添加成功alias"

