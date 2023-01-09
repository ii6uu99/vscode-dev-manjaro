#这里存储alias的命令
#cat > /etc/profile.d/alias.sh <<EOF

#运行本文件添加alias,添加完alias之后运行runalias
alias runalias="bash /home/ming/workspace/.config/script/alias.sh && echo 'source /etc/profile.d/alias.sh' >> /home/ming/.bashrc && source /home/ming/.bashrc && cat /etc/profile.d/alias.sh"

#切换目录
alias cdscript="cd /home/ming/workspace/.config/script"

#链接script目录下的所有文件到/usr/local/bin
alias initln="cd /home/ming/workspace/.config/script &&  chmod 777 * -R && ln -s /home/ming/.config/script/* /usr/local/bin"

#把当前文件夹的所有文件给权限和链接到/usr/local/bin
alias lnbin="sudo chmod 777 * -R && sudo ln -s /* /usr/local/bin"
#alias lnbin="sudo chmod 777 ./* && sudo cp -i /* /usr/local/bin"


alias big="xrandr -s 1920x1080"

alias ff="firefox"

alias home="cd /home/ming"


#运行script文件夹内的文件，go 文件名
alias go="export PATH=$PATH:/home/ming/workspace/.config/script  && cd /home/ming/workspace/.config/script &&  chmod 777 * -R && bash $1"

#首次运行git,git1 仓库网址
alias git1="git init && git config --global user.email 'ii6uu99@163.com'&& git config --global user.name 'ii6uu99' && git remote add origin $1"
alias git2="git add . && git commit -m "ne" && git push -u origin master"


alias wall="feh --no-fehbg --bg-fill '/home/ming/workspace/.config/picture/1.png'"


alias config="cd /home/ming/workspace/.config"







#----------------移植过来的
# Changing "ls" to "exa"
alias ls='exa -al --color=always --group-directories-first' # my preferred listing
alias la='exa -a --color=always --group-directories-first'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first'  # long format
alias lt='exa -aT --color=always --group-directories-first' # tree listing
alias l.='exa -a | egrep "^\."'


# pacman and yay 安装软件
alias pacsyu='sudo pacman -Syu'                  # 仅更新标准包
alias pacsyyu='sudo pacman -Syyu'                # 刷新 pkglist 并更新标准 pkgs
alias yaysua='yay -Sua --noconfirm'              # 仅更新 AUR pkgs（yay）
alias yaysyu='yay -Syu --noconfirm'              # 更新标准 pkgs 和 AUR pkgs (yay)
alias parsua='paru -Sua --noconfirm'             # 仅更新 AUR pkgs (paru)
alias parsyu='paru -Syu --noconfirm'             # 更新标准 pkgs 和 AUR pkgs (paru)
alias unlock='sudo rm /var/lib/pacman/db.lck'    # 移除 pacman 锁
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)' #删除孤立的包


# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'


# 覆盖前确认
alias cp="cp -i"
alias mv='mv -i'
alias rm='rm -i'


# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'


# git
alias addup='git add -u'
alias addall='git add .'
alias branch='git branch'
alias checkout='git checkout'
alias clone='git clone'
alias commit='git commit -m'
alias fetch='git fetch'
alias pull='git pull origin'
alias push='git push origin'
alias stat='git status'  # 'status' is protected name so using 'stat' instead
alias tag='git tag'
alias newtag='git tag -a'


# yt-dlp, yes | sudo pacman -S yt-dlp
alias yta-aac="yt-dlp --extract-audio --audio-format aac "
alias yta-best="yt-dlp --extract-audio --audio-format best "
alias yta-flac="yt-dlp --extract-audio --audio-format flac "
alias yta-m4a="yt-dlp --extract-audio --audio-format m4a "
alias yta-mp3="yt-dlp --extract-audio --audio-format mp3 "
alias yta-opus="yt-dlp --extract-audio --audio-format opus "
alias yta-vorbis="yt-dlp --extract-audio --audio-format vorbis "
alias yta-wav="yt-dlp --extract-audio --audio-format wav "
alias ytv-best="yt-dlp -f bestvideo+bestaudio "


# 在 shell 之间切换
# 我不建议从 bash 切换默认 SHELL
alias tobash="sudo chsh $USER -s /bin/bash && echo '已经更换为bash'"
alias tozsh="sudo chsh $USER -s /bin/zsh && echo '已经更换为zsh.'"
alias tofish="sudo chsh $USER -s /bin/fish && echo '已经更换为fish'"

### DTOS ###
# 将 /etc/dtos 的所有内容复制/粘贴到主文件夹。创建配置的备份。 （小心运行这个！）
alias dtoscopy='[ -d ~/.config ] || mkdir ~/.config && cp -Rf ~/.config ~/.config-backup-$(date +%Y.%m.%d-%H.%M.%S) && cp -rf /etc/dtos/* ~'

# 将 /etc/dtos 的内容备份到 $HOME 中的备份文件夹。
alias dtosbackup='cp -Rf /etc/dtos ~/dtos-backup-$(date +%Y.%m.%d-%H.%M.%S)'





#EOF





