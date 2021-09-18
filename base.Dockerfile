FROM ubuntu:20.04

SHELL ["/bin/bash","-c"]

ARG \
  HOME=/root \
  TZ=America/Chicago \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  TERM=xterm-256 \
  LANGUAGE=en

ARG \
  XDG_CONFIG_HOME=${HOME}/.config \
  XDG_CACHE_HOME=${HOME}/.cache \
  XDG_DATA_HOME=${HOME}/.local/share \
  XDG_STATE_HOME=${HOME}/.local/.state \
  XDG_BIN_HOME=${HOME}/.local/bin \
  XDG_FONTS_HOME=${HOME}/.local/fonts \
  GOLANG_VER=1.17.1 \
  NODE_VER=14.17.5 \
  NODE_ENVIRONMENT=development \
  GOPATH=${HOME}/go \
  CARGO_HOME=${HOME}/.cargo 


ENV PATH=${XDG_BIN_HOME}:${PATH}
  
RUN apt-get update -y && apt-get upgrade -y

# Set the locale
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get install -y locales \
  # && sed --in-place '/en_US.UTF-8/s/^#//' \
  # && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && sed -i 's/^# *\(en_US.UTF-8\)/\1/' /etc/locale.gen \
  && locale-gen ${LANG}  \
  && update-locale LANG=${LANG}

ENV \
  LANG=${LANG} \
  LANGUAGE=${LANGUAGE} \
  LC_ALL=${LC_ALL} \
  TZ=${TZ}

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

# Install cargo
# For script: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
RUN apt-get install -y cargo

# Install golang
# wget https://golang.org/dl/go1.17.linux-amd64.tar.gz -P ${GOROOT}
RUN \
  wget https://golang.org/dl/go1.17.linux-amd64.tar.gz


# Setup fd-find
# Use command fd as fd-find by placing binary in local bin
# RUN ln -s $(which fdfind) ${XDG_BIN_HOME}/fd

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

# Editor Neovim
# RUN \
  # add-apt-repository ppa:neovim-ppa/unstable \
  # && sudo apt-get update \
  # && sudo apt-get install neovim python3-neovim python-neovim

CMD ["/bin/bash"]
