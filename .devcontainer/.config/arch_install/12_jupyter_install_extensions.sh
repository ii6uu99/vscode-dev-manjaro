#!/bin/bash
set -x
#https://github.com/S0urC10ud/jupyter-with-extensions
pacman -S nodejs npm


declare -a pip_extensions=( \
                    "jupyterlab-spellchecker" \
                    "aquirdturtle_collapsible_headings" \
                    "pwntools" \
                    "torchattacks" \
                )

declare -a jupyter_extensions=( \
                    "@jupyter-widgets/jupyterlab-manager" \
                    "bqplot" \
                    "jupyterlab-kernelspy" \
                    "@jupyterlab/latex" \
                    "jupyter-matplotlib" \
                    "jupyterlab-drawio" \
                )

pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cpu
for ext in "${jupyter_extensions[@]}"; do jupyter labextension install "$ext" --no-build; done

for ext in "${pip_extensions[@]}"; do pip install "$ext"; done

pip install --upgrade jupyterlab jupyterlab-git
jupyter lab build
jupyter lab clean
jlpm cache clean



#npm cache clean --force
#rm -rf $HOME/.node-gyp
#rm -rf $HOME/.local
#fix-permissions $CONDA_DIR $HOME
