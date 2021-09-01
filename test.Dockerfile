FROM ide-base:latest

USER ${USERNAME}

SHELL [ "/usr/bin/zsh","-c" ]

ENV SHELL ${USER_SHELL}

WORKDIR ${HOME}

RUN mkdir -p \
  $XDG_DATA_HOME \
  $XDG_CONFIG_HOME \
  $XDG_STATE_HOME \
  $XDG_CACHE_HOME \
  $XDG_FONTS_HOME \
  $LOCAL_BIN \
  $NVM_DIR \
  $ZSH_CUSTOM \
  $NEOVIM_DIR 

RUN \
  # Install Oh-my-zsh \
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true \
  # Install Rust \
  && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | zsh -s -- -y \
  # && echo 'source $HOME/.cargo/env' >> $HOME/.zshrc \
  # Install NVM \
  && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh \
  && . ${XDG_CONFIG_HOME}/nvm/nvm.sh \
  # Install Node \
  && nvm install ${NODE_VER} \
  && nvm use node \
  && npm install --global yarn \
  && yarn global add neovim

# RUN \
#   git clone --branch dev https://github.com/iamcrash/dotfiles \
#   && cp dotfiles/zsh/.zshrc . \
#   && cp -r dotfiles/zsh $XDG_CONFIG_HOME/zsh

