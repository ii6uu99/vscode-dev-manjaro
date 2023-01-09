pacman -S  --noconfirm curl \
&& curl -sSL https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -o /tmp/miniconda.sh \
&& bash /tmp/miniconda.sh -bfp /usr/local \
&& rm -rf /tmp/miniconda.sh \
&& conda install -y python=3 \
&& conda update conda

## 设置启动设置好的国内镜像源
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/free/ && \
conda config --add channels https://mirrors.ustc.edu.cn/anaconda/pkgs/main/ && \
conda config --set show_channel_urls yes && \
conda update --all -y


#设置pip的源为国内源
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple


# 安装python的一些编码规则库
pip install --upgrade black autopep8 yapf mypy bandit flake8 pylint pycodestyle pytest


