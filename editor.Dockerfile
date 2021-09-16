FROM ide-local:latest

ARG \
  NEOVIM_DIR \
  NEOVIM_VER

ENV \
  NEOVIM_DIR=${NEOVIM_DIR} \
  NEOVIM_VER=${NEOVIM_VER}

SHELL ["zsh", "-c"]

USER $USERNAME

RUN \ 
  source ~/.zshrc \
  # Install Neovim \
  && wget https://github.com/neovim/neovim/releases/download/v${NEOVIM_VER}/nvim.appimage -P ${NEOVIM_DIR} \
  && chmod u+x ${NEOVIM_DIR}/nvim.appimage \
  && cd ${NEOVIM_DIR} \
  && ./nvim.appimage --appimage-extract \
  && ln -s ${NEOVIM_DIR}/squashfs-root/usr/bin/nvim ${XDG_BIN_HOME}/nvim

# RUN nvm -v && nvim -v
#   # # Install lunarvim \
#   # && wget https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh \
#   # && chmod +x install.sh \
#   # && yes | ./install.sh \
#   # && rm install.sh

# LSP

# Linters

# Formatters

CMD ["zsh"]
