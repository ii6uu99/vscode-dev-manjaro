#安装zerotier

#https://github.com/guedes84/zerotier-docker/blob/main/Dockerfile
#https://blog.csdn.net/weixin_44444810/article/details/124473244
#https://my.zerotier.com/network/b15644912e556725



pacman -S zerotier-one --noconfirm


#开启端口
zerotier-one -d

#加入网络

zerotier-cli join b15644912e556725


#启动nochime服务
#/etc/NX/nxserver --startup


