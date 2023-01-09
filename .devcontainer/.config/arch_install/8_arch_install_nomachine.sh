#----------------------------------------------------------


USERNAME=${1:-"ming"}

#desktop=`which dwm`


echo "exec dwm" > /usr/bin/startdwm && \
chmod 777 /usr/bin/startdwm


#安装yay
su - ${USERNAME} /bin/bash -c "sudo pacman -Sy --noconfirm yay"
    #执行以下命令修改 aururl :
    #su - ming /bin/sh -c "yay --aururl 'https://aur.tuna.tsinghua.edu.cn' --save"
    #echo -e "ming\n" | su - ming && \
    #yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
    #yay -P -g
    #网址替换加速yay



#用yay安装nomachine,并配置进入的桌面
su - ${USERNAME} /bin/bash -c "yes | yay -Sy nomachine" && \
sed -i "s|#EnableClipboard both|EnableClipboard both |g" /usr/NX/etc/server.cfg &&\
sed -i '/DefaultDesktopCommand/c\DefaultDesktopCommand "/usr/bin/startdwm"' /usr/NX/etc/node.cfg


#----------------------------------------------------------

## 配置ssh pacman -S  --noconfirm openssh-server &&


mkdir /var/run/sshd &&  \
echo 'root:ming' | chpasswd && \
sed -i 's/#*PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd



