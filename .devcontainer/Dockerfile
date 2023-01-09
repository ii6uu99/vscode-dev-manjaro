#https://github.com/RavenKyu/docker-ubuntu-desktop-vnc，根据此修改
#使用manjaro镜像
FROM manjarolinux/base


#ENV container docker
#ENV DEBIAN_FRONTEND noninteractive


#----------------------------------------------------------


# 配置语言，添加这个会出现中文数字乱码
#ENV LANGUAGE zh_CN.UTF-8
#ENV LANG zh_CN.UTF-8
#ENV LC_ALL=zh_CN.UTF-8



#设置语言为en_US.UTF-8，避免vscode挂载后中文出现数字乱码
RUN sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen && \
    locale-gen && \
    #设置 LANG 变量
    echo 'LANG=en_US.UTF-8' > /etc/locale.conf


#----------------------------------------------------------


#设置时区
ENV TZ=Asia/Shanghai
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime


#----------------------------------------------------------


#manjaro切换中国镜像源
RUN pacman-mirrors --country China && pacman -Syyu --noconfirm

#----------------------------------------------------------

#添加环境变量的path
ARG ADD_PATH="./.devcontainer/.config/arch_install"
ARG TO_PATH="/tmp/SCRIPT_NAME"


#----------------------------------------------------------
ARG USERNAME=ming
ARG PASSWORD=ming
ARG ROOT_PASSWORD=ming

#创建一个普通用户ming，密码为ming
RUN useradd -m -s /bin/bash -G wheel ${USERNAME} && \
    echo -e "${PASSWORD}\n${PASSWORD}\n" | passwd ${USERNAME} && \
    echo -e "${ROOT_PASSWORD}\n${ROOT_PASSWORD}\n" | passwd root && \
    sed -i 's/# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/g' /etc/sudoers


#----------------------------------------------------------



#安装微软自带的配置init，创建用户，安装zsh和ohz，进行一些配置

ARG SCRIPT_NAME=1_arch_install_zsh.sh
ARG USER_RUN=root       #以什么用户来运行脚本
ADD ${ADD_PATH}/${SCRIPT_NAME} ${TO_PATH}/${SCRIPT_NAME} 
RUN chmod 777 ${TO_PATH}/${SCRIPT_NAME} && su - ${USER_RUN} -c "/bin/bash ${TO_PATH}/${SCRIPT_NAME} ${USERNAME}"


#----------------------------------------------------------

#添加alias.sh到omz文件夹
ARG SCRIPT_NAME=2_add_aliases.sh
ADD --chown=${USERNAME} .devcontainer/.config/arch_install/${SCRIPT_NAME} /home/${USERNAME}/.oh-my-zsh/custom/aliases.zsh


#----------------------------------------------------------



#扩展基础安装包
#sudo make在base-devel包里
RUN  pacman -S --noconfirm --needed vi man-db man-pages texinfo base-devel



#----------------------------------------------------------
#安装字体

ARG SCRIPT_NAME=3_arch_install_font.sh
ARG USER_RUN=root       #以什么用户来运行脚本
ADD ${ADD_PATH}/${SCRIPT_NAME} ${TO_PATH}/${SCRIPT_NAME} 
RUN chmod 777 ${TO_PATH}/${SCRIPT_NAME} && su - ${USER_RUN} -c "/bin/bash ${TO_PATH}/${SCRIPT_NAME}"


#----------------------------------------------------------

#安装miniconda

ARG SCRIPT_NAME=4_arch_install_miniconda.sh
ARG USER_RUN=root       #以什么用户来运行脚本
ADD ${ADD_PATH}/${SCRIPT_NAME} ${TO_PATH}/${SCRIPT_NAME} 
RUN chmod 777 ${TO_PATH}/${SCRIPT_NAME} && su - ${USER_RUN} -c "/bin/bash ${TO_PATH}/${SCRIPT_NAME}"

#----------------------------------------------------------

#安装python的一些库

ARG SCRIPT_NAME=5_python_lib.sh
ARG USER_RUN=root       #以什么用户来运行脚本
ADD ${ADD_PATH}/${SCRIPT_NAME} ${TO_PATH}/${SCRIPT_NAME} 
RUN chmod 777 ${TO_PATH}/${SCRIPT_NAME} && su - ${USER_RUN} -c "/bin/bash ${TO_PATH}/${SCRIPT_NAME}"


#----------------------------------------------------------

#安装dwm,普通用户安装

ARG SCRIPT_NAME=6_arch_install_dwm.sh
ARG USER_RUN=${USERNAME}       #以什么用户来运行脚本
ADD ${ADD_PATH}/${SCRIPT_NAME} ${TO_PATH}/${SCRIPT_NAME} 
RUN chmod 777 ${TO_PATH}/${SCRIPT_NAME} && su - ${USER_RUN} -c "/bin/bash ${TO_PATH}/${SCRIPT_NAME} ${USERNAME}"




#----------------------------------------------------------
#安装firefox,普通用户安装

ARG SCRIPT_NAME=7_arch_install_firefox.sh
ARG USER_RUN=${USERNAME}       #以什么用户来运行脚本
ADD ${ADD_PATH}/${SCRIPT_NAME} ${TO_PATH}/${SCRIPT_NAME} 
RUN chmod 777 ${TO_PATH}/${SCRIPT_NAME} && su - ${USER_RUN} -c "/bin/bash ${TO_PATH}/${SCRIPT_NAME}"



#----------------------------------------------------------

#用yay安装nomachine远程桌面
ARG SCRIPT_NAME=8_arch_install_nomachine.sh
ARG USER_RUN=root       #以什么用户来运行脚本
ADD ${ADD_PATH}/${SCRIPT_NAME} ${TO_PATH}/${SCRIPT_NAME} 
RUN chmod 777 ${TO_PATH}/${SCRIPT_NAME} && su - ${USER_RUN} -c "/bin/bash ${TO_PATH}/${SCRIPT_NAME} ${USERNAME}"


#----------------------------------------------------------


#https://curl.se/docs/caextract.html
#https://websockets.readthedocs.io/en/stable/contributing.html#bitcoin-users
#https://curl.haxx.se/docs/caextract.html
#ADD https://curl.haxx.se/ca/cacert.pem /etc/ssl/certs/ca-certificates.crt


#----------------------------------------------------------

#添加.config文件夹
ADD .devcontainer/.config /home/${USERNAME}/.config
RUN \
    cd /home/${USERNAME}/.config && \
    chmod 777 * -R

RUN mkdir /home/${USERNAME}/workspace
WORKDIR /home/${USERNAME}/workspace


#----------------------------------------------------------

# 4000是nomachine远程桌面的端口
#22是nomachine的ssh连接端口
#8888是jupyter notebook的默认端口
EXPOSE 4000 22 8888

#----------------------------------------------------------

#添加脚本，加入zerotier网络和启动nomachine
#ADD .devcontainer/nxserver.sh /
#RUN chmod 777 /nxserver.sh
#ENTRYPOINT ["/nxserver.sh"]

#----------------------------------------------------------
#添加自定义的命令到/usr/local/bin/
COPY .devcontainer/.config/bin/* /usr/local/bin/
RUN chmod 777 /usr/local/bin/*




















