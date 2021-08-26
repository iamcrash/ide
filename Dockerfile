FROM ubuntu:20.04

ARG \
  BUILD_HOME \
  BUILD_USER_ID \
  BUILD_GROUP_ID \
  BUILD_USERNAME \
  BUILD_GROUPNAME \
  BUILD_GIT_EMAIL \
  BUILD_GIT_USERNAME \
  BUILD_TZ \
  BUILD_EDITOR \
  BUILD_NODE_ENV \
  BUILD_TERM \
  BUILD_NVIM \
  BUILD_NODE \
  BUILD_NODE_VER \
  BUILD_NVM_DIR \
  BUILD_WORKSPACE \
  BUILD_SHELL \
  BUILD_LC_ALL \
  BUILD_LANG \
  BUILD_LANGUAGE

# Set the locale
RUN apt-get update \
  && apt-get -y install locales \
  && sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen \
  && locale-gen
ENV LANGUAGE=${BUILD_LANGUAGE} \
  LANG=${BUILD_LANG} \
  LC_ALL=${BUILD_LC_ALL}

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
  pkg-config 

RUN \
  # Create user \
  addgroup --gid ${BUILD_GROUP_ID} ${BUILD_GROUPNAME} \
  && adduser \
  --quiet \
  --disabled-password \
  --shell ${BUILD_SHELL} \
  --home ${BUILD_HOME} \
  --uid ${BUILD_USER_ID} \
  --gid ${BUILD_GROUP_ID} \
  --gecos ' ' \
  ${BUILD_USERNAME} \
  && echo "${BUILD_USERNAME}:password" | chpasswd \
  && usermod -aG sudo ${BUILD_USERNAME}

#
# HOME Config
#
ENV \
  HOME=${BUILD_HOME} \
  # XDG Directory paths \
  XDG_DATA_HOME=$HOME/.local/share \
  XDG_CONFIG_HOME=$HOME/.config \
  XDG_STATE_HOME=$HOME/.local/state \
  XDG_CACHE_HOME=$HOME/.cache 

RUN mkdir -p $XDG_DATA_HOME $XDG_CONFIG_HOME $XDG_STATE_HOME $XDG_CACHE_HOME

# Changeshell
# RUN chsh -s /usr/bin/zsh $USERNAME

WORKDIR ${XDG_DATA_HOME}

RUN \
  # Git config \
  git config --global user.name "${GIT_USERNAME}" \
  && git config --global user.email "${GIT_EMAIL}"

ENV ZSH="$XDG_DATA_HOME/oh-my-zsh"

RUN \
  # Install Oh-my-zsh \
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true 

# Copy files from github
RUN \
  git clone https://github.com/iamcrash/dotfiles \
  COPY --chown=$USERNAME:$USERNAME ~/dotfiles/.config ${BUILD_HOME}/.config/
# COPY --chown=$USERNAME:$USERNAME ~/dotfiles/.oh-my-zsh/custom ${BUILDHOME}/.oh-my-zsh/custom/
# COPY --chown=$USERNAME:$USERNAME ~/dotfiles/.p10* ${BUILD_HOME}/
# COPY --chown=$USERNAME:$USERNAME dotfiles/.iterm2* $HOME/

USER ${BUILD_USERNAME}

# Double quotes executes without shell
# Single quotes executes with shell
ENTRYPOINT ["zsh"] 

# STOP---
# RUN \
#   # Nerdfonts \
#   mkdir -p ${HOME}/.local/share/fonts \
#   && cd ${HOME}/.local/share/fonts \
#   && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf \
#   && cd ${HOME} \
#   # Powerlevel10k theme \
#   && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k \
#   # Change varialble ZSH_THEME in .zshrc \
#   && ZTHEME="\"powerlevel10k\/powerlevel10k\"" \
#   && sed -i -r "s/^(ZSH_THEME=).*/\1${ZTHEME}/" $HOME/.zshrc
# 
# WORKDIR $HOME
# 
# RUN \
#   # NVM \
#   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
#   && . ${XDG_CONFIG_HOME}/nvm/nvm.sh \
#   # Node \
#   && nvm install "${NODE_VER}" \
#   && nvm use node \
#   && npm install --global yarn \
#   && yarn global add neovim
# 
# RUN \ 
#   # Neovim \
#   mkdir -p ${HOME}/neovim \
#   && cd ${HOME}/neovim \
#   && wget https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage \
#   && chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract \
#   && cd ${HOME}
# 
# RUN \
#   # Change $HOME ownership to user \
#   chown -R "${USERNAME}:${GROUPNAME}" ${HOME}
# 
# USER $USERNAME
# 
# # ENV \
# #   USER_ID=${BUILD_USER_ID} \
# #   GROUP_ID=${BUILD_GROUP_ID} \
# #   USERNAME=${BUILD_USERNAME} \
# #   GROUPNAME=${BUILD_GROUPNAME} \
# #   GIT_USERNAME=${BUILD_GIT_USERNAME} \
# #   GIT_EMAIL=${BUILD_GIT_EMAIL} \
# #   HOME=${BUILD_HOME} 
# 
# 
# # ENV \
# #   TZ=${BUILD_TZ} \
# #   EDITOR=${BUILD_EDITOR} \
# #   NODE_ENV=${BUILD_NODE_ENV} \
# #   TERM=${BUILD_TERM} \
# #   XDG_CONFIG_HOME=${BUILD_XDG_CONFIG_HOME} \
# #   XDG_STATE_HOME=${BUILD_XDG_STATE_HOME} \
# #   XDG_DATA_HOME=${BUILD_XDG_DATA_HOME} \
# #   XDG_CACHE_HOME=${BUILD_XDG_CACHE_HOME} \
# #   XDG_RUNTIME_DIR=${BUILD_XDG_RUNTIME_DIR} \
# #   NVIM=${BUILD_NVIM} \
# #   NODE_VER=${BUILD_NODE_VER} \
# #   NODE=${BUILD_NODE} \
# #   WORKSPACE=${BUILD_WORKSPACE} \
# #   SHELL=${BUILD_SHELL} \
# #   PATH=${BUILD_NVIM}:${BUILD_NODE}:${PATH}
# 
