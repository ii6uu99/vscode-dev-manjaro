#!/usr/bin/env bash

#https://github.com/microsoft/vscode-dev-containers/blob/main/containers/ubuntu/.devcontainer/library-scripts/common-debian.sh


#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/common.md
# 维护者：VS Code 和 Codespaces 团队
#
# Syntax: ./common-debian.sh [install zsh flag] [username] [user UID] [user GID] [upgrade packages flag] [install Oh My Zsh! flag] [Add non-free packages]

set -e


#接收用户名这个变量
USERNAME=${1:-"ming"}




SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"

if [ "$(id -u)" -ne 0 ]; then
    echo -e '脚本必须以 root 身份运行。在运行此脚本之前，使用 sudo、su 或将“USER root”添加到 Dockerfile.'
    exit 1
fi

# 如果用户使用 ENV 更新了 PATH，请确保登录 shell 获得正确的路径。
rm -f /etc/profile.d/00-restore-env.sh
echo "export PATH=${PATH//$(sh -lc 'echo $PATH')/\$PATH}" > /etc/profile.d/00-restore-env.sh
chmod +x /etc/profile.d/00-restore-env.sh



# ** shell定制部分 **
if [ "${USERNAME}" = "root" ]; then 
    user_rc_path="/root"
else
    user_rc_path="/home/${USERNAME}"
fi


 #如果bashrc文件不存在或为空，则从bashrc文件中恢复用户 .bashrc 默认值
if [ ! -f "${user_rc_path}/.bashrc" ] || [ ! -s "${user_rc_path}/.bashrc" ] ; then
    cp -i /etc/skel/.bashrc "${user_rc_path}/.bashrc"
fi

#如果bash_profile文件不存在或为空，则从bash_profile文件中恢复用户 .profile 默认值
if  [ ! -f "${user_rc_path}/.bash_profile" ] || [ ! -s "${user_rc_path}/.bash_profile" ] ; then
   cp -i /etc/skel/.bash_profile "${user_rc_path}/.bash_profile"
fi






# .bashrc/.zshrc snippet
rc_snippet="$(cat << 'EOF'

if [ -z "${USER}" ]; then export USER=$(whoami); fi
if [[ "${PATH}" != *"$HOME/.local/bin"* ]]; then export PATH="${PATH}:$HOME/.local/bin"; fi

# 如果已配置且终端是交互式的，则显示可选的首次运行图像特定通知
if [ -t 1 ] && [[ "${TERM_PROGRAM}" = "vscode" || "${TERM_PROGRAM}" = "codespaces" ]] && [ ! -f "$HOME/.config/vscode-dev-containers/first-run-notice-already-displayed" ]; then
    if [ -f "/usr/local/etc/vscode-dev-containers/first-run-notice.txt" ]; then
        cat "/usr/local/etc/vscode-dev-containers/first-run-notice.txt"
    elif [ -f "/workspaces/.codespaces/shared/first-run-notice.txt" ]; then
        cat "/workspaces/.codespaces/shared/first-run-notice.txt"
    fi
    mkdir -p "$HOME/.config/vscode-dev-containers"
    # 将首次运行通知标记为 10 秒后显示，以避免快速终端刷新隐藏它的问题
    ((sleep 10s; touch "$HOME/.config/vscode-dev-containers/first-run-notice-already-displayed") &)
fi

# 如果尚未设置，请设置默认 git 编辑器
if [ -z "$(git config --get core.editor)" ] && [ -z "${GIT_EDITOR}" ]; then
    if  [ "${TERM_PROGRAM}" = "vscode" ]; then
        if [[ -n $(command -v code-insiders) &&  -z $(command -v code) ]]; then 
            export GIT_EDITOR="code-insiders --wait"
        else 
            export GIT_EDITOR="code --wait"
        fi
    fi
fi

EOF
)"

# 代码垫片，如果代码不可用，它会退回给代码内部人员
cat << 'EOF' > /usr/local/bin/code
#!/bin/sh

get_in_path_except_current() {
    which -a "$1" | grep -A1 "$0" | grep -v "$0"
}

code="$(get_in_path_except_current code)"

if [ -n "$code" ]; then
    exec "$code" "$@"
elif [ "$(command -v code-insiders)" ]; then
    exec code-insiders "$@"
else
    echo "code or code-insiders is not installed" >&2
    exit 127
fi
EOF

chmod +x /usr/local/bin/code

#systemctl shim - 如果 systemd 未运行，则告诉人们使用“服务”
cat << 'EOF' > /usr/local/bin/systemctl
#!/bin/sh
set -e
if [ -d "/run/systemd/system" ]; then
    exec /bin/systemctl "$@"
else
    echo '\n"systemd" is not running in this container due to its overhead.\nUse the "service" command to start services instead. e.g.: \n\nservice --status-all'
fi
EOF

chmod +x /usr/local/bin/systemctl

# Codespaces bash and OMZ themes - partly inspired by https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/robbyrussell.zsh-theme
codespaces_bash="$(cat \
<<'EOF'

# Codespaces bash prompt theme
__bash_prompt() {
    local userpart='`export XIT=$? \
        && [ ! -z "${GITHUB_USER}" ] && echo -n "\[\033[0;32m\]@${GITHUB_USER} " || echo -n "\[\033[0;32m\]\u " \
        && [ "$XIT" -ne "0" ] && echo -n "\[\033[1;31m\]➜" || echo -n "\[\033[0m\]➜"`'
    local gitbranch='`\
        if [ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then \
            export BRANCH=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null); \
            if [ "${BRANCH}" != "" ]; then \
                echo -n "\[\033[0;36m\](\[\033[1;31m\]${BRANCH}" \
                && if git ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then \
                        echo -n " \[\033[1;33m\]✗"; \
                fi \
                && echo -n "\[\033[0;36m\]) "; \
            fi; \
        fi`'
    local lightblue='\[\033[1;34m\]'
    local removecolor='\[\033[0m\]'
    PS1="${userpart} ${lightblue}\w ${gitbranch}${removecolor}\$ "
    unset -f __bash_prompt
}
__bash_prompt

EOF
)"

codespaces_zsh="$(cat \
<<'EOF'
# Codespaces zsh prompt theme
__zsh_prompt() {
    local prompt_username
    if [ ! -z "${GITHUB_USER}" ]; then 
        prompt_username="@${GITHUB_USER}"
    else
        prompt_username="%n"
    fi
    PROMPT="%{$fg[green]%}${prompt_username} %(?:%{$reset_color%}➜ :%{$fg_bold[red]%}➜ )" # User/exit code arrow
    PROMPT+='%{$fg_bold[blue]%}%(5~|%-1~/…/%3~|%4~)%{$reset_color%} ' # cwd
    PROMPT+='$([ "$(git config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ] && git_prompt_info)' # Git status
    PROMPT+='%{$fg[white]%}$ %{$reset_color%}'
    unset -f __zsh_prompt
}
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}(%{$fg_bold[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg_bold[yellow]%}✗%{$fg_bold[cyan]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[cyan]%})"
__zsh_prompt

EOF
)"

# 添加RC_SNIPPET和自定义 bash 提示符
if [ "${USERNAME}" == "root" ]; then
    echo "${rc_snippet}" >> /etc/bash.bashrc
    echo "${codespaces_bash}" >> "${user_rc_path}/.bashrc"
    echo 'export PROMPT_DIRTRIM=4' >> "${user_rc_path}/.bashrc"
fi
   
if [ "${USERNAME}" != "root" ]; then
    echo "${codespaces_bash}" >> "/root/.bashrc"
    echo 'export PROMPT_DIRTRIM=4' >> "/root/.bashrc"
fi



# 可选择安装和配置 zsh 和 Oh My Zsh！
pacman -S --noconfirm zsh
echo "${rc_snippet}" >> /etc/zsh/zshrc



# 改编的、简化的内联 Oh My Zsh！安装添加的步骤，默认为代码空间主题。
# See https://github.com/ohmyzsh/ohmyzsh/blob/master/tools/install.sh for official script.
oh_my_install_dir="${user_rc_path}/.oh-my-zsh"

template_path="${oh_my_install_dir}/templates/zshrc.zsh-template"
user_rc_file="${user_rc_path}/.zshrc"
umask g-w,o-w
mkdir -p ${oh_my_install_dir}
git clone --depth=1 \
    -c core.eol=lf \
    -c core.autocrlf=false \
    -c fsck.zeroPaddedFilemode=ignore \
    -c fetch.fsck.zeroPaddedFilemode=ignore \
    -c receive.fsck.zeroPaddedFilemode=ignore \
    "https://github.com/ohmyzsh/ohmyzsh" "${oh_my_install_dir}" 2>&1
echo -e "$(cat "${template_path}")\nDISABLE_AUTO_UPDATE=true\nDISABLE_UPDATE_PROMPT=true" > ${user_rc_file}
sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="codespaces"/g' ${user_rc_file}

mkdir -p ${oh_my_install_dir}/custom/themes
echo "${codespaces_zsh}" > "${oh_my_install_dir}/custom/themes/codespaces.zsh-theme"
# 在仍然启用更新的同时缩小 git
cd "${oh_my_install_dir}"
git repack -a -d -f --depth=1 --window=1

group_name="$(id -gn $USERNAME)"

# Copy to non-root user if one is specified
if [ "${USERNAME}" != "root" ]; then
    cp -rf "${user_rc_file}" "${oh_my_install_dir}" /root
    chown ${USERNAME}:${group_name} "${user_rc_path}/.bashrc"
fi



# 保留图像元数据信息，如果在同一目录中找到 meta.env 脚本
meta_info_script="$(cat << 'EOF'
#!/bin/sh
. /usr/local/etc/vscode-dev-containers/meta.env

# Minimal output
if [ "$1" = "version" ] || [ "$1" = "image-version" ]; then
    echo "${VERSION}"
    exit 0
elif [ "$1" = "release" ]; then
    echo "${GIT_REPOSITORY_RELEASE}"
    exit 0
elif [ "$1" = "content" ] || [ "$1" = "content-url" ] || [ "$1" = "contents" ] || [ "$1" = "contents-url" ]; then
    echo "${CONTENTS_URL}"
    exit 0
fi

#Full output
echo
echo "Development container image information"
echo
if [ ! -z "${VERSION}" ]; then echo "- Image version: ${VERSION}"; fi
if [ ! -z "${DEFINITION_ID}" ]; then echo "- Definition ID: ${DEFINITION_ID}"; fi
if [ ! -z "${VARIANT}" ]; then echo "- Variant: ${VARIANT}"; fi
if [ ! -z "${GIT_REPOSITORY}" ]; then echo "- Source code repository: ${GIT_REPOSITORY}"; fi
if [ ! -z "${GIT_REPOSITORY_RELEASE}" ]; then echo "- Source code release/branch: ${GIT_REPOSITORY_RELEASE}"; fi
if [ ! -z "${BUILD_TIMESTAMP}" ]; then echo "- Timestamp: ${BUILD_TIMESTAMP}"; fi
if [ ! -z "${CONTENTS_URL}" ]; then echo && echo "More info: ${CONTENTS_URL}"; fi
echo
EOF
)"

if [ -f "${SCRIPT_DIR}/meta.env" ]; then
    mkdir -p /usr/local/etc/vscode-dev-containers/
    cp -f "${SCRIPT_DIR}/meta.env" /usr/local/etc/vscode-dev-containers/meta.env
    echo "${meta_info_script}" > /usr/local/bin/devcontainer-info
    chmod +x /usr/local/bin/devcontainer-info
fi




