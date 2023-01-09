USERNAME=${1:-"ming"}



# 安装dwm桌面所必要的软件
#查询 pacman 的文件数据库以了解哪些软件包（包括未安装的软件包）提供了文件：
#sudo pacman -Fy    # the database likely needs to be refreshed
#pacman -F Xft.h
#/usr/local/bin/dwm
sudo pacman -S --noconfirm --needed make pkg-config xorg-server xorg-xinit git
sudo pacman -S  --noconfirm  libx11 libxft glibc libxinerama


#安装dwm
mkdir /home/${USERNAME}/suckless && \
sudo chmod 777 /home/${USERNAME}/suckless && \
    git clone https://github.com/bakkeby/dwm-flexipatch.git /home/${USERNAME}/suckless/dwm && \
cd /home/${USERNAME}/suckless/dwm && \
#启用自动启动的补丁
sed -i "s/#define AUTOSTART_PATCH 0/#define AUTOSTART_PATCH 1/g" patches.def.h && \
mkdir -p /home/${USERNAME}/.dwm/ && \
#写入自动启动文件
printf '%s\n' > /home/${USERNAME}/.dwm/autostart.sh \
#'fcitx &' \
#'clipmenud &' \
'xrandr -s 1920x1080' \
'firefox'
#'xrandr -s 1920x1080' \
#'xwallpaper --zoom ~/Pictures/wallpapers/0002.jpg'


#替换一些dwm的配置
cd /home/${USERNAME}/suckless/dwm && \
sudo sed 's/#define MODKEY Mod4Mask/#define MODKEY Mod1Mask/' config.def.h | sudo tee -a temp && sudo mv temp config.def.h && \
sudo sed 's/size\=9/size\=14/' config.def.h | sudo tee -a temp && sudo mv temp config.def.h && \
sudo sed 's/size\=8/size\=14/' config.def.h | sudo tee -a temp && sudo mv temp config.def.h && \
sudo sed 's/size\=10/size\=14/' config.def.h | sudo tee -a temp && sudo mv temp config.def.h && \
sudo cp config.def.h config.h && \
sudo make clean install


#安装demu
git clone https://git.suckless.org/dmenu /home/${USERNAME}/suckless/dmenu && \
cd /home/${USERNAME}/suckless/dmenu  && \
sudo sed 's/pixelsize\=11/pixelsize\=24/' config.def.h | sudo tee -a temp && sudo mv temp config.def.h  && \
sudo sed 's/pixelsize\=8/pixelsize\=24/' config.def.h | sudo tee -a temp && sudo mv temp config.def.h  && \
sudo cp config.def.h config.h  && \
sudo make clean install


#状态栏dwmblocks
git clone https://github.com/UtkarshVerma/dwmblocks-async.git /home/${USERNAME}/suckless/dwmblocks && \
cd /home/${USERNAME}/suckless/dwmblocks  && \
sudo make clean install



#st终端
git clone https://git.suckless.org/st  /home/${USERNAME}/suckless/st && \
cd /home/${USERNAME}/suckless/st  && \
sudo sed 's/pixelsize\=14/pixelsize\=16/' config.def.h | sudo tee -a temp && sudo mv temp config.def.h  && \
sudo cp config.def.h config.h  && \
sudo make clean install
