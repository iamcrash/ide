FROM ubuntu:20.04

# User args
ARG \
  USERNAME=dev \
  PASSWORD=dev \
  USER_ID=1000 \
  GROUP_ID=1000 \
  GROUPNAME=dev \
  HOSTNAME=machine \
  GIT_USERNAME=iamcrash \
  GIT_EMAIL=crash.machine@icloud.com

ENV \
  HOME=/home/${USERNAME} \
  USERNAME=${USERNAME} \
  GROUPNAME=${GROUPNAME} \
  EDITOR=lvim \
  TZ=America/Chicago \
  LANGUAGE=en \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  SHELL=/usr/bin/zsh \
  TERM=xterm-256color 

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

CMD ["zsh"]
