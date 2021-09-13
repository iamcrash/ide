FROM ide-base:latest

########
# ide-base creeates user and setsup home
#
#
########

ARG \
  USERNAME=user \
  PASSWORD=password \
  HOME=/home/user \
  USER_ID=1000 \
  GROUP_ID=1000 \
  GROUPNAME=mygroup \
  HOSTNAME=machine \
  GIT_USERNAME \
  GIT_EMAIL

ARG \
  EDITOR=nvim \
  TZ=UTC \
  LANGUAGE=en \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  TERM=xterm-256color \
  SHELL=/usr/bin/zsh \
  NODE_VER=14.17.15 \
  NEOVIM_VER=0.5.0 \
  GOLANG_VER=1.17 \
  DOTFILES=${HOME}/.config/dotfiles \
  WORKSPACE=${HOME}/workspace \
  XDG_CONFIG_HOME=${HOME}/.config \
  XDG_CACHE_HOME=${HOME}/.cache \
  XDG_DATA_HOME=${HOME}/.local/share \
  XDG_RUNTIME_DIR=${HOME}/.xdg \
  XDG_STATE_HOME=${HOME}/.local/state \
  XDG_BIN_HOME=${HOME}/.local/bin \
  XDG_FONTS_HOME=${HOME}/.local/fonts \
  SHELL_SESSIONS_DISABLE=1

ARG \
  ZDOTDIR=${XDG_CONFIG_HOME}/zsh \
  ZSH=${XDG_DATA_HOME}/oh-my-zsh \
  ZSH_CUSTOM=${ZDOTDIR}/custom \
  KEEP_ZSHRC=yes \
  NODE_ENVIRONMENT=development \
  NEOVIM_DIR=${XDG_DATA_HOME}/neovim \
  CARGO_HOME=${HOME}/.cargo \
  NVM_DIR=${XDG_CONFIG_HOME}/nvm \
  RUSTUP_HOME=${XDG_DATA_HOME}/rustup \
  GOROOT=${XDG_DATA_HOME}/go \
  GOPATH=${HOME}/go \
  EXPORTS_FILE=${ZDOTDIR}/exports.env

ENV \
  USERNAME=${USERNAME} \
  GROUPNAME=${GROUPNAME} \
  HOME=${HOME} \
  HOSTNAME=${HOSTNAME} \
  EDITOR=${EDITOR} \
  TZ=${TZ} \
  LANGUAGE=${LANGUAGE} \
  LANG=${LANG} \
  LC_ALL=${LC_ALL} \
  SHELL=${SHELL} \
  TERM=${TERM} \
  DOTFILES=${DOTFILES} \
  WORKSPACE=${WORKSPACE}} \
  XDG_CONFIG_HOME=${XDG_CONFIG_HOME} \
  XDG_CACHE_HOME=${XDG_CACHE_HOME} \
  XDG_DATA_HOME=${XDG_DATA_HOME} \
  XDG_RUNTIME_DIR=${XDG_RUNTIME_DIR} \
  XDG_STATE_HOME=${XDG_STATE_HOME} \
  XDG_BIN_HOME=${XDG_BIN_HOME} \
  XDG_FONTS_HOME=${XDG_FONTS_HOME} \
  ZDOTDIR=${ZDOTDIR} \
  ZSH=${ZSH} \
  ZSH_CUSTOM=${ZSH_CUSTOM} \
  ZSHRC=${ZDOTDIR}/.zshrc \
  NODE_ENVIRONMENT=${NODE_ENVIRONMENT}} \
  NEOVIM_DIR=${NEOVIM_DIR} \
  CARGO_HOME=${CARGO_HOME} \
  NVM_DIR=${NVM_DIR} \
  RUSTUP_HOME=${RUSTUP_HOME} \
  GOROOT=${GOROOT} \
  GOPATH=${GOPATH} \
  EXPORTS_FILE=${EXPORTS_FILE} \
  SHELL_SESSIONS_DISABLE=${SHELL_SESSIONS_DISABLE}

RUN \
  # Create user \
  addgroup --gid ${GROUP_ID} ${GROUPNAME} \
  && adduser \
  --quiet \
  --disabled-password \
  --shell ${SHELL} \
  --home ${HOME} \
  --uid ${USER_ID} \
  --gid ${GROUP_ID} \
  --gecos ' ' \
  ${USERNAME} \
  && echo "${USERNAME}:${PASSWORD}" | chpasswd \
  && usermod -aG sudo ${USERNAME} \
  && unset ${PASSWORD}

COPY --chown=${USERNAME}:${GROUPNAME} dotfiles/ ${DOTFILES}
COPY --chown=${USERNAME}:${GROUPNAME} dotfiles/ ${HOME}

WORKDIR ${HOME}

RUN chown -R ${USERNAME}:${GROUPNAME} ${HOME} 

USER ${USERNAME}

RUN echo "source ${ZSHRC}" > ~/.zshrc

SHELL ["/usr/bin/zsh", "-c"]

RUN mkdir -p \
  $XDG_BIN_HOME \
  $XDG_CACHE_HOME \
  $XDG_CONFIG_HOME \
  $XDG_DATA_HOME \
  $XDG_FONTS_HOME \
  $XDG_RUNTIME_DIR \
  $XDG_STATE_HOME \
  $ZDOTDIR \
  $ZSH_CUSTOM

# Install oh-my-zsh
# IF KEEP_ZSHRC=yes then keep existing .zshrc, else KEEP_ZSHRC=no then replaces or creates new .zshrc
RUN \
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

RUN \
  # Install Nerdfonts \
  curl -o "${XDG_FONTS_HOME}/Droid Sans Mono for Powerline Nerd Font Complete.otf" -fL https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

RUN \
  # Install Powerlevel10k theme \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH:-$ZSH}/themes/powerlevel10k

# Install NVM, Node, and yarn
RUN \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh \
  && . ${NVM_DIR}/nvm.sh \
  # Install Node \
  && nvm install ${NODE_VER} \
  && nvm use node \
  && npm install --global yarn \
  && yarn global add neovim 

# Install Rust
RUN \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install Golang
RUN \
  wget https://golang.org/dl/go1.17.linux-amd64.tar.gz -P ${GOROOT}

# ENV \
#    LUNARVIM_CONFIG_DIR="${XDG_CONFIG_HOME}/lvim" \
#    LUNARVIM_RUNTIME_DIR="${XDG_DATA_HOME}/lunarvim" 

RUN . ~/.zshrc

RUN nvm

CMD ["zsh"]
