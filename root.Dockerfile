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
  LANGUAGE=en

# TODO: System wide approach according to linux specs?
# XDG_DATA_HOME=/usr/local/bin
# XDG_CONFIG_HOME=/usr/local/etc

# Update and upgrade
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

# TODO: System wide config?
# /etc/profile

# Home and xdg globals
ENV HOME=/root

# Set XDG globals
ENV \
  XDG_CONFIG_HOME=$HOME/.config \
  XDG_CACHE_HOME=$HOME/.cache \
  XDG_DATA_HOME=$HOME/.local/share \
  XDG_STATE_HOME=$HOME/.local/state \
  XDG_BIN_HOME=$HOME/.local/bin \
  XDG_FONTS_HOME=$HOME/.local/fonts \
  XDG_DOTFILES_HOME=$HOME/.dotfiles

# Append local executable directory 
ENV PATH=${XDG_BIN_HOME}:$PATH


# Make directories if they dont exist
RUN mkdir -p \
  $XDG_BIN_HOME \
  $XDG_CACHE_HOME \
  $XDG_CONFIG_HOME \
  $XDG_DATA_HOME \
  $XDG_FONTS_HOME \
  $XDG_STATE_HOME


###
# Setup ZSH
###
# Set the oh-my-zsh framework path
ENV ZSH=${XDG_DATA_HOME}/oh-my-zsh

# TODO: Set zshcustom directory
# ZSH_CUSTOM=${ZSH}/custom

# TODO: Set ZDOTDIR global?
# ENV ZDOTDIR=${XDG_CONFIG_HOME}/zsh

# TODO: Make zsh globals directories?
# RUN mkdir -p $ZDOTDIR $ZSH_CUSTOM

# TODO: Source to zdotdir?
# RUN echo "source ${ZDOTDIR}/.zshrc" > ~/.zshrc

# After setting up zsh globals, run zsh shell for every command
SHELL ["/usr/bin/zsh","-c"]

# Replace the default fd command
# TODO: Better if i put in local bin? RUN ln -s $(which fdfind) ${XDG_BIN_HOME}/fd
RUN ln -s $(which fdfind) /usr/local/bin/fd

###
# Install cargo
###
# For script: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# For apt-get: RUN apt-get install -y cargo
# TODO: Use arg? ARG CARGO_HOME=/usr/local/cargo
ENV CARGO_HOME=${XDG_DATA_HOME}/cargo

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

###
# Install Golang
###
ARG \
  GOLANG_VER=1.17.1

ENV GOROOT=${XDG_DATA_HOME}/go

RUN \
  # wget https://golang.org/dl/go1.17.linux-amd64.tar.gz -P ${GOROOT} \
  wget https://golang.org/dl/go${GOLANG_VER}.linux-amd64.tar.gz \
  && rm -rf /usr/local/go && tar -C /usr/local -xzf go${GOLANG_VER}.linux-amd64.tar.gz \
  && ln -s /usr/local/go/bin/go /usr/local/bin/go \
  && ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

###
# Install Nerdfonts
###
RUN \
  curl -o "${XDG_FONTS_HOME}/Droid Sans Mono for Powerline Nerd Font Complete.otf" -fL https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

###
# Install zsh framework oh-my-zsh
# Install oh-my-zsh Powerlevel10k theme
###
RUN \
  # IF KEEP_ZSHRC=yes then keep existing .zshrc, else KEEP_ZSHRC=no then replaces or creates new .zshrc \
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

RUN \
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH:-$ZSH}/themes/powerlevel10k

###
# Install NVM, Node, and yarn globally
###
ENV \
  NVM_DIR=${XDG_CONFIG_HOME}/nvm \
  NODE_VER=14.18.0

RUN \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh \
  && . ${NVM_DIR}/nvm.sh \
  # Install Node \
  && nvm install ${NODE_VER} \
  && nvm use node \
  && npm install --global yarn \
  && yarn global add neovim 

###
# Install unstable neovim editor 
###
RUN \
  add-apt-repository ppa:neovim-ppa/unstable \
  && sudo apt-get update \
  && sudo apt-get install -y neovim python3-neovim

###
# Install neovim flavor lunarvim
###
# RUN \
#   source ~/.zshrc \
#   && wget https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh \
#   && chmod +x install.sh \
#   && yes | ./install.sh \
#   && rm install.sh

# TODO: Set the default shell for root? RUN chsh -s /usr/bin/zsh root
# TODO: Dotfiles?
# TODO: .config/neovim

CMD ["zsh"]
