pacman -S --noconfirm net-tools \
    python3 \
    rxvt-unicode \
    supervisor \
    ttf-dejavu \
    x11vnc \
    xorg-server \
    xorg-apps \
    xorg-server-xvfb \
    xorg-xinit


cd /opt/
git clone https://github.com/kanaka/noVNC.git

# 启动 noVnc 时避免再次签出
cd /opt/noVNC/utils/
git clone https://github.com/kanaka/websockify

export DISPLAY=:0.0

#EXPOSE 8083


cat > /etc/supervisor.d/supervisord.ini <<EOF

[supervisord]
nodaemon=true

[program:X11]
command=/usr/bin/Xvfb :0 -screen 0 1024x768x24
autorestart=true

[program:x11vnc]
command=/usr/bin/x11vnc
autorestart=true

[program:noVNC]
command=/opt/noVNC/utils/novnc_proxy --vnc localhost:5900 --listen 8083
autorestart=true

[program:dwm]
command=/usr/local/bin/dwm
autorestart=true

EOF


#启动novnc命令
/usr/bin/supervisord
#网址 vnc_lite.html 






