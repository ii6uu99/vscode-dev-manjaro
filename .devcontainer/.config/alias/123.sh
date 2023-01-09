for i in ${to_installs[*]}
do
  echo """
#================
#********** $i ************
#================
  """ >> $HOME/.zshrc

sed -i '$r $i' $HOME/.zshrc

done


echo '123' > 123.sh
i=123.sh
sed -i '$r \$i' $HOME/.zshrc

