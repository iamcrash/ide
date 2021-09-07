from ide-bootstrap:latest

# ENV \
#    LUNARVIM_CONFIG_DIR="${XDG_CONFIG_HOME}/lvim" \
#    LUNARVIM_RUNTIME_DIR="${XDG_DATA_HOME}/lunarvim" 

RUN \ 
  # Install Neovim \
  wget https://github.com/neovim/neovim/releases/download/v${NEOVIM_VER}/nvim.appimage -P ${NEOVIM_DIR} \
  && chmod u+x ${NEOVIM_DIR}/nvim.appimage \
  && cd ${NEOVIM_DIR} \
  && ./nvim.appimage --appimage-extract \
  && ln -s ${NEOVIM_DIR}/squashfs-root/usr/bin/nvim ${XDG_BIN_HOME}/nvim

RUN \
  # Install lunarvim \
  wget https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh \
  && chmod +x install.sh \
  && yes | ./install.sh \
  && rm install.sh


# RUN \
#   git clone https://github.com/iamcrash/dotfiles \
#   && cp -r dotfiles/zsh $XDG_CONFIG_HOME \
#   && cp .zshrc $XDG_CONFIG_HOME/zsh/build/zshrc \
#   && env > $XDG_CONFIG_HOME/zsh/build/env \
#   && cp $XDG_CONFIG_HOME/zsh/zshrc .zshrc \
#   && cp -r dotfiles/iterm2 $XDG_CONFIG_HOME \
#   && cp dotfiles/lvim/config.lua $LUNARVIM_CONFIG_DIR

## TODO: Install formatters
# RUN \
  # Intall Lua formatter \
  # cargo install stylua

## Install solidity
# RUN \
#   npm -i -g prettier prettier-plugin-solidity

## TODO: Install linters
# RUN \
#  # Install javascript linter
#  npm -ig eslint

WORKDIR $HOME/workspace

VOLUME $HOME/workspace

CMD ["zsh"]

