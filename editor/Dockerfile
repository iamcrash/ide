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
  GIT_EMAIL=${GIT_EMAIL}

ARG \
  EDITOR=${EDITOR} \
  TZ=${TZ} \
  LANGUAGE=${LANGUAGE} \
  LANG=${LANG} \
  LC_ALL=${LC_ALL} \
  SHELL=${SHELL} \
  TERM=${TERM} \
  NODE_VER=${NODE_VER} \
  NEOVIM_VER=${NEOVIM_VER} \
  GOLANG_VER=${GOLANG_VER} \
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
  ZSHRCFILE=${ZDOTDIR}/.zshrc \
  NODE_ENVIRONMENT=${NODE_ENVIRONMENT}} \
  NEOVIM_DIR=${NEOVIM_DIR} \
  CARGO_HOME=${CARGO_HOME} \
  NVM_DIR=${NVM_DIR} \
  RUSTUP_HOME=${RUSTUP_HOME} \
  GOROOT=${GOROOT} \
  GOPATH=${GOPATH} \
  BOOTSTRAP_FILE=${BOOTSTRAP_FILE} \
  EXPORTS_FILE=${EXPORTS_FILE} \
  SHELL_SESSIONS_DISABLE=#{SHELL_SESSIONS_DISABLE}

ENV PATH=${XDG_BIN_HOME}:$PATH

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

COPY --chown=${USERNAME}:${GROUPNAME} dotfiles/ ${DOTFILES}
COPY --chown=${USERNAME}:${GROUPNAME} dotfiles/ ${HOME}

WORKDIR ${HOME}

RUN chown -R ${USERNAME}:${GROUPNAME} ${HOME} 

USER ${USERNAME}

SHELL ["/usr/bin/zsh", "-c"]

RUN ls -al && tree ~/.config && env && (env) && echo "file: ~/.config/zsh/.zshrc"&& cat ${ZSHRCFILE}

# RUN mkdir -p \
#   $XDG_BIN_HOME \
#   $XDG_CACHE_HOME \
#   $XDG_CONFIG_HOME \
#   $XDG_DATA_HOME \
#   $XDG_FONTS_HOME \
#   $XDG_RUNTIME_DIR \
#   $XDG_STATE_HOME \
#   $ZDOTDIR \
#   $ZSH_CUSTOM
# 
# # Install oh-my-zsh
# RUN curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true
# 
# RUN \
#   # Install Nerdfonts \
#   curl -o "${XDG_FONTS_HOME}/Droid Sans Mono for Powerline Nerd Font Complete.otf" -fL https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
# 
# RUN \
#   # Install Powerlevel10k theme \
#   git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH:-$ZSH}/themes/powerlevel10k
# 
# # Install NVM, Node, and yarn
# RUN \
#   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh \
#   && . ${NVM_DIR}/nvm.sh \
#   # Install Node \
#   && nvm install ${NODE_VER} \
#   && nvm use node \
#   && npm install --global yarn \
#   && yarn global add neovim 
# 
# # Install Rust
# RUN \
#   curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# 
# # Install Golang
# RUN \
#   wget https://golang.org/dl/go1.17.linux-amd64.tar.gz -P ${GOROOT}
# 
# # ENV \
# #    LUNARVIM_CONFIG_DIR="${XDG_CONFIG_HOME}/lvim" \
# #    LUNARVIM_RUNTIME_DIR="${XDG_DATA_HOME}/lunarvim" 
# 
# CMD ["zsh"]
