
# 安装基本字体
pacman -S --noconfirm --needed \
            freetype2 \
            gsfonts \
            ttf-cascadia-code \
            ttf-dejavu \
            gucharmap


# 安装文泉驿微米黑字体
#https://v2ex.com/t/430768
pacman -S --noconfirm --needed wqy-microhei wqy-zenhei ttf-hack
#ln /etc/fonts/conf.d/65-wqy-microhei.conf /etc/fonts/conf.d/69-language-selector-zh-cn.conf


