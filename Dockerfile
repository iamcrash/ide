FROM ubuntu:20.04

ARG \
  USERNAME=${USERNAME} \
  PASSWORD=${PASSWORD} \
  HOME=${HOME} \
  USER_ID=${USER_ID} \
  GROUP_ID=${GROUP_ID} \
  GROUPNAME=${GROUPNAME} \
  HOSTNAME=${HOSTNAME} \
  GIT_USERNAME=${GIT_USERNAME} \
  GIT_EMAIL=${GIT_EMAIL} \
  EDITOR=${EDITOR} \
  TZ=${TZ} \
  LANGUAGE=${LANGUAGE} \
  LANG=${LANG} \
  LC_ALL=${LC_ALL} \
  SHELL=${SHELL} \
  TERM=${TERM} \
  NODE_VER=${NODE_VER} \
  NEOVIM_VER=${NEOVIM_VER} \
  GOLANG_VER=${GOLANG_VER}

ARG \
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
  NODE_ENVIRONMENT=development \
  NEOVIM_DIR=${XDG_DATA_HOME}/neovim \
  CARGO_HOME=${HOME}/.cargo \
  NVM_DIR=${XDG_CONFIG_HOME}/nvm \
  RUSTUP_HOME=${XDG_DATA_HOME}/rustup \
  GOROOT=${XDG_DATA_HOME}/go \
  GOPATH=${HOME}/go \
  BOOTSTRAP_FILE=${DOTFILES}/main.sh \
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
  TERM=${TERM}

RUN apt-get update -y && apt-get upgrade -y

# Set the locale
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get install -y locales \
  # && sed --in-place '/en_US.UTF-8/s/^#//' \
  # && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
  && locale-gen ${LANG}  \
  && update-locale LANG=${LANG}

RUN \
  DEBIAN_FRONTEND=noninteractive \
  TZ=${TZ} \
  apt-get install -y \
  build-essential \
  software-properties-common \
  fzf \
  silversearcher-ag \
  pwgen \
  ripgrep \
  python3 \
  exuberant-ctags \
  sudo \
  python3-pip \
  python3-venv \
  python3-dev \
  gnupg-agent \
  apt-transport-https \
  openssl \
  curl \
  wget \
  cmake \
  make \
  pkg-config \
  libtool \
  automake \
  unzip \
  git \
  python3-pip \
  zsh \
  less \
  man \
  openssh-client \
  git \
  ninja-build \
  gettext \
  libtool-bin \
  autoconf \
  g++ \
  locales \
  locales-all \
  ca-certificates \
  pkg-config \
  fonts-powerline \
  tree \
  xclip \
  tmux \
  rsync

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
  && usermod -aG sudo ${USERNAME}

######
#
######

WORKDIR ${HOME}

RUN chown -R ${USERNAME}:${GROUPNAME} ${HOME}

USER ${USERNAME}

SHELL ["/usr/bin/zsh", "-c"]

# TODO: Set env to args

ARG \
  NODE_VER=${NODE_VER} \
  NEOVIM_VER=${NEOVIM_VER} \
  GOLANG_VER=${GOLANG_VER}

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

COPY --chown=${USERNAME}:${GROUPNAME} dotfiles/ ${DOTFILES}
COPY --chown=${USERNAME}:${GROUPNAME} dotfiles/ ${HOME}

RUN mkdir -p \
  $XDG_BIN_HOME \
  $XDG_CACHE_HOME \
  $XDG_CONFIG_HOME \
  $XDG_DATA_HOME \
  $XDG_FONTS_HOME \
  $XDG_RUNTIME_DIR \
  $XDG_STATE_HOME \
  $ZSH \
  $ZDOTDIR \
  $ZSH_CUSTOM

# Install oh-my-zsh
RUN curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

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

RUN \ 
  # Install Neovim \
  wget https://github.com/neovim/neovim/releases/download/v${NEOVIM_VER}/nvim.appimage -P ${NEOVIM_DIR} \
  && chmod u+x ${NEOVIM_DIR}/nvim.appimage \
  && cd ${NEOVIM_DIR} \
  && ./nvim.appimage --appimage-extract \
  && ln -s ${NEOVIM_DIR}/squashfs-root/usr/bin/nvim ${XDG_BIN_HOME}/nvim

RUN \
  . ${NVM_DIR}/nvm.sh \
  # Install lunarvim \
  && wget https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh \
  && chmod +x install.sh \
  && yes | ./install.sh \
  && rm install.sh

CMD ["zsh"]
