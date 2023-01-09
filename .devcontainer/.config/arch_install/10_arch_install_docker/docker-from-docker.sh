#! /usr/bin/env bash

USERNAME=${1:-'code'}
DEV_CONFIG_PATH=${2:-'undefined'}
ENABLE_NONROOT_DOCKER=${3:-'true'}

DOCKER_INIT_STUB_PATH="${STUB_PATH}/docker-init.stub"
DCO_ALIAS_STUB_PATH="${STUB_PATH}/dco-alias.stub"


SOURCE_SOCKET="/var/run/docker-host.sock"
TARGET_SOCKET="/var/run/docker.sock"

# 安装 docker 套件
pacman -Sy --noconfirm \
   helm \
   docker \
   kubectl \
   minikube \
   docker-compose


# 默认情况下，使源和目标套接字相同
touch "${SOURCE_SOCKET}"
ln -s "${SOURCE_SOCKET}" "${TARGET_SOCKET}"

# 允许非root用户使用docker
if [ "${ENABLE_NONROOT_DOCKER}" == "true" ]
then
   # 为非root用户启用docker使用
   chown -h "${USERNAME}":root "${TARGET_SOCKET}"

   # 安装 socat 以在第一种方法出现回退时提供帮助
   pacman -Sy --noconfirm socat

   #用相应的值替换占位符...
   sed -i \
      -e "s^\$ENABLE_NONROOT_DOCKER^$ENABLE_NONROOT_DOCKER^g" \
      -e "s^\$USERNAME^$USERNAME^g" \
      -e "s^\$TARGET_SOCKET^$TARGET_SOCKET^g" \
      -e "s^\$SOURCE_SOCKET^$SOURCE_SOCKET^g" "${DOCKER_INIT_STUB_PATH}"

else
   echo \
      -e "#!/usr/bin/env bash\n\n# PH_COMPOSE_FILE_BINDER" > "${DOCKER_INIT_STUB_PATH}"
fi

# 尝试一些其他方法来处理下面的块......使用的不是最佳的

# 如果未定义开发配置文件，则为空文件...
if [ "$DEV_CONFIG_PATH" != "undefined" ]
then
   sed -i -e "s^\$DEV_CONFIG_PATH^$DEV_CONFIG_PATH^" "${DCO_ALIAS_STUB_PATH}"
else
   echo "" > "${DCO_ALIAS_STUB_PATH}"
fi

sed -i \
   -e "/# PH_COMPOSE_FILE_BINDER/r ${DCO_ALIAS_STUB_PATH}" \
   -e '/# PH_COMPOSE_FILE_BINDER/d' "${DOCKER_INIT_STUB_PATH}"


# 将处理后的存根移到 init.d
mv "${DOCKER_INIT_STUB_PATH}" "${ENTRYPOINT_INIT_D}/docker-init.sh"

echo -e "\nDone!\n"
