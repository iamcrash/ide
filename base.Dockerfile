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
  BUILD_HOSTNAME

# Set the locale
RUN apt-get update \
  && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
  # && sed --in-place '/en_US.UTF-8/s/^#//' \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen ${BUILD_LANG}  \
  && update-locale LANG=${BUILD_LANG}

ENV \
  LANGUAGE=${BUILD_LANGUAGE} \
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
  tree \
  xclip \
  tmux \
  rsync

RUN \
  # Create user \
  addgroup --gid ${BUILD_GROUP_ID} ${BUILD_GROUPNAME} \
  && adduser \
  --quiet \
  --disabled-password \
  --shell ${BUILD_SHELL} \
  --home /home/${BUILD_USERNAME} \
  --uid ${BUILD_USER_ID} \
  --gid ${BUILD_GROUP_ID} \
  --gecos ' ' \
  ${BUILD_USERNAME} \
  && echo "${BUILD_USERNAME}:${BUILD_PASSWORD}" | chpasswd \
  && usermod -aG sudo ${BUILD_USERNAME}

ENV \
  USERNAME=${BUILD_USERNAME}

CMD ["zsh"]
