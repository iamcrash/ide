FROM ide-base:latest 

WORKDIR ${HOME}

RUN chown -R ${USERNAME}:${GROUPNAME} ${HOME}

USER ${USERNAME}

SHELL ["/usr/bin/zsh", "-c"]

ARG \
  NODE_VER=14.17.5 \
  NEOVIM_VER=0.5.0 \
  GOLANG_VER=1.17

# Paths to dotfiles and workspace
ENV \
  DOTFILES=${HOME}/.config/dotfiles \
  WORKSPACE=${HOME}/workspace

# Set XDG dirs
ENV \
  XDG_CONFIG_HOME=${HOME}/.config \
  XDG_CACHE_HOME=${HOME}/.cache \
  XDG_DATA_HOME=${HOME}/.local/share \
  XDG_RUNTIME_DIR=${HOME}/.xdg \
  XDG_STATE_HOME=${HOME}/.local/state \
  XDG_BIN_HOME=${HOME}/.local/bin \
  XDG_FONTS_HOME=${HOME}/.local/fonts

# Update path
ENV PATH=$XDG_BIN_HOME:$PATH

ENV SHELL_SESSIONS_DISABLE=1

# Set ZSH
ENV ZDOTDIR=${XDG_CONFIG_HOME}/zsh
ENV \
  ZSH=${XDG_DATA_HOME}/oh-my-zsh \
  ZSH_CUSTOM=${ZDOTDIR}/custom

# User config
ENV \
  NODE_ENVIRONMENT=development \
  NEOVIM_DIR=${XDG_DATA_HOME}/neovim \
  CARGO_HOME=${HOME}/.cargo \
  NVM_DIR=${XDG_CONFIG_HOME}/nvm \
  RUSTUP_HOME=${XDG_DATA_HOME}/rustup \
  GOROOT=${XDG_DATA_HOME}/go \
  GOPATH=${HOME}/go

ENV \
  BOOTSTRAP_FILE=${DOTFILES}/main.sh \
  EXPORTS_FILE=${ZDOTDIR}/exports.env

RUN mkdir -p \
  $XDG_BIN_HOME \
  $XDG_CACHE_HOME \
  $XDG_CONFIG_HOME \
  $XDG_DATA_HOME \
  $XDG_FONTS_HOME \
  $XDG_RUNTIME_DIR \
  $XDG_STATE_HOME

COPY --chown=${USERNAME}:${GROUPNAME} dotfiles ${DOTFILES}
COPY --chown=${USERNAME}:${GROUPNAME} dotfiles/zsh ${ZDOTDIR}

RUN \
  touch ${EXPORTS_FILE} \
  && chmod +x ${BOOTSTRAP_FILE} \
  && . ${BOOTSTRAP_FILE} \
  && cat ${EXPORTS_FILE}

# Install oh-my-zsh
RUN curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

# Install Rust
RUN \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Golang
RUN \
  wget https://golang.org/dl/go1.17.linux-amd64.tar.gz -P ${GOROOT}

# Install NVM, Node, and yarn
RUN \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh \
  && . ${NVM_DIR}/nvm.sh \
  # Install Node \
  && nvm install ${NODE_VER} \
  && nvm use node \
  && npm install --global yarn \
  && yarn global add neovim 

RUN \
  # Install Nerdfonts \
  curl -o "${XDG_FONTS_HOME}/Droid Sans Mono for Powerline Nerd Font Complete.otf" -fL https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

RUN \
  # Install Powerlevel10k theme \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH:-$ZSH}/themes/powerlevel10k

CMD ["zsh"]
