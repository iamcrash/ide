FROM ubuntu:20.04

ARG \
  BUILD_USERNAME \
  BUILD_PASSWORD \
  BUILD_USER_ID \
  BUILD_GROUP_ID \
  BUILD_GROUPNAME \
  BUILD_GIT_USERNAME \
  BUILD_GIT_EMAIL \
  BUILD_TZ \
  BUILD_TERM \
  BUILD_LANGUAGE \
  BUILD_LANG \
  BUILD_LC_ALL \
  BUILD_SHELL \
  BUILD_EDITOR \
  BUILD_NODE_ENV \
  BUILD_NODE_VER \
  BUILD_NEOVIM_VER

# Set the locale
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
  # && sed --in-place '/en_US.UTF-8/s/^#//' \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen ${BUILD_LANG}  \
  && update-locale LANG=${BUILD_LANG}

ENV LANGUAGE=${BUILD_LANGUAGE} \
  LANG=${BUILD_LANG} \
  LC_ALL=${BUILD_LC_ALL} \
  TERM=${BUILD_TERM} 

RUN \
  apt-get update \
  && DEBIAN_FRONTEND=noninteractive \
  TZ=${BUILD_TZ} \
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
  tree

ENV \
  USERNAME=${BUILD_USERNAME} \
  HOME=/home/${BUILD_USERNAME} \
  USER_SHELL=${BUILD_SHELL}

RUN \
  # Create user \
  addgroup --gid ${BUILD_GROUP_ID} ${BUILD_GROUPNAME} \
  && adduser \
  --quiet \
  --disabled-password \
  --shell ${BUILD_SHELL} \
  --home ${HOME} \
  --uid ${BUILD_USER_ID} \
  --gid ${BUILD_GROUP_ID} \
  --gecos ' ' \
  ${BUILD_USERNAME} \
  && echo "${BUILD_USERNAME}:${BUILD_PASSWORD}" | chpasswd \
  && usermod -aG sudo ${BUILD_USERNAME}


ENV \
  XDG_DATA_HOME=${HOME}/.local/share \
  XDG_CONFIG_HOME=${HOME}/.config \
  XDG_STATE_HOME=${HOME}/.local/state \
  XDG_CACHE_HOME=${HOME}/.cache \
  XDG_FONTS_HOME=${HOME}/.local/share/fonts \
  LOCAL_BIN=${HOME}/.local/bin \
  WORKSPACE=${HOME}/workspace \
  NODE_VER=${BUILD_NODE_VER}

ENV \
  ZSH="${XDG_DATA_HOME}/oh-my-zsh" \
  ZSH_CUSTOM="${XDG_CONFIG_HOME}/zsh/custom" \
  ZSH_THEME="\"powerlevel10k\/powerlevel10k\"" \
  NEOVIM_DIR="${XDG_DATA_HOME}/neovim" \
  NEOVIM_VER="${BUILD_NEOVIM_VER}" \
  NVM_DIR="${XDG_CONFIG_HOME}/nvm"

ENV \
  NODE_PATH="${NVM_DIR}/versions/node/v${NODE_VER}/bin"

ENV PATH=${LOCAL_BIN}:${NODE_PATH}:${PATH}

CMD ["/usr/bin/zsh"]
