FROM ubuntu:20.04

###
#
# Root
# Install and setup base packages and config
#
###

SHELL ["/bin/bash","-c"]

# Get and set args
ARG \
  TZ=America/Chicago \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  TERM=xterm-256color \
  LANGUAGE=en \
  XDG_DATA_HOME=/usr/local/bin \
  XDG_CONFIG_HOME=/usr/local/etc \
  GOLANG_VER=1.17.1

RUN apt-get update -y && apt-get upgrade -y

# Set the locale
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get install -y locales \
  # && sed --in-place '/en_US.UTF-8/s/^#//' \
  # && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
  && locale-gen ${LANG}  \
  && update-locale LANG=${LANG}

# Set locale environment vars
ENV \
  LANG=${LANG} \
  LANGUAGE=${LANGUAGE} \
  LC_ALL=${LC_ALL} \
  TZ=${TZ}

# Install packages
RUN \
  DEBIAN_FRONTEND=noninteractive \
  TZ=${TZ} \
  apt-get install -y \
  build-essential \
  software-properties-common \
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
  pwgen \
  rsync \
  fzf \
  silversearcher-ag \
  ripgrep \
  fd-find

# Rustlang
# Install cargo
# For script: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# For apt-get: RUN apt-get install -y cargo
ENV CARGO_HOME=${XDG_DATA_HOME}/cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Golang
# Install golang
# wget https://golang.org/dl/go1.17.linux-amd64.tar.gz -P ${GOROOT}
ENV GOROOT=${XDG_DATA_HOME}/go \
RUN \
  wget https://golang.org/dl/go${GOLANG_VER}.linux-amd64.tar.gz \
  && rm -rf /usr/local/go && tar -C /usr/local -xzf go${GOLANG_VER}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/go /usr/local/bin/go \
  && ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# fd command
# Override default fd with fd-find
# Use command fd as fd-find by placing binary in local bin
RUN ln -s $(which fdfind) /usr/local/bin/fd

# Setup rg
# ARG \
#  RIPGREP_CONFIG_PATH=${HOME}/.ripgrepc \
#  RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "

# Setup fzf
# FZF
# Example: FZF_DEFAULT_COMMAND='fd --type f'
# ARG \
#  FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border' \
#  INITIAL_QUERY="" \
# FZF_DEFAULT_COMMAND="$RG_PREFIX '$INITIAL_QUERY'" \
#  fzf --bind "change:reload:$RG_PREFIX {q} || true" \
#      --ansi --disabled --query "$INITIAL_QUERY" \
#      --height=50% --layout=reverse

# Neovim
# Set the apt repository and install
# RUN \
  # add-apt-repository ppa:neovim-ppa/unstable \
  # && sudo apt-get update \
  # && sudo apt-get install neovim python3-neovim python-neovim

CMD ["/bin/bash"]
