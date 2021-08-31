FROM ubuntu:20.04

ARG \
  BUILD_USERNAME \
  BUILD_USER_ID \
  BUILD_GROUP_ID \
  BUILD_GROUPNAME \
  BUILD_GIT_EMAIL \
  BUILD_GIT_USERNAME \
  BUILD_TZ \
  BUILD_EDITOR \
  BUILD_NODE_ENV \
  BUILD_TERM \
  BUILD_SHELL \
  BUILD_LC_ALL \
  BUILD_LANG \
  BUILD_LANGUAGE \
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
  pkg-config

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

ENV \
  HOME=/home/${BUILD_USERNAME} \
  USERNAME=${BUILD_USERNAME} \
  GIT_USERNAME=${BUILD_GIT_USERNAME} \
  GIT_EMAIL=${BUILD_GIT_EMAIL}

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
  ${USERNAME} \
  && echo "${USERNAME}:password" | chpasswd \
  && usermod -aG sudo ${USERNAME}

USER ${USERNAME}

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
  ZSH_CUSTOM="${XDG_CONFIG_HOME}/oh-my-zsh" \
  ZSH_THEME="\"powerlevel10k\/powerlevel10k\"" \
  NEOVIM_DIR="${XDG_DATA_HOME}/neovim" \
  NEOVIM_VER=${BUILD_NEOVIM_VER} \
  NVM_DIR="${XDG_CONFIG_HOME}/nvm"

ENV \
  NODE_PATH="${NVM_DIR}/versions/node/v${NODE_VER}/bin" \
  LUNARVIM_CONFIG_DIR="${XDG_CONFIG_HOME}/lvim" \
  LUNARVIM_RUNTIME_DIR="${XDG_DATA_HOME}/lunarvim" 

RUN mkdir -p \
  $XDG_DATA_HOME \
  $XDG_CONFIG_HOME \
  $XDG_STATE_HOME \
  $XDG_CACHE_HOME \
  $XDG_FONTS_HOME \
  $LOCAL_BIN \
  $NVM_DIR \
  $ZSH_CUSTOM \
  $NEOVIM_DIR

ENV PATH=${LOCAL_BIN}:${NODE_PATH}:${PATH}

WORKDIR ${XDG_CONFIG_HOME}

# TODO: Env in oh-my-zsh custom should have environment variables?
RUN \
  # Install Oh-my-zsh \
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

RUN \
  # Install NVM \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
  && . ${XDG_CONFIG_HOME}/nvm/nvm.sh \
  # Install Node \
  && nvm install ${NODE_VER} \
  && nvm use node \
  && npm install --global yarn \
  && yarn global add neovim 

# TODO: create soft links and add to path?

RUN \
  # Nerdfonts \
  curl -o "${XDG_FONTS_HOME}/Droid Sans Mono for Powerline Nerd Font Complete.otf" -fL https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf \
  # Powerlevel10k theme \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$ZSH_CUSTOM}/themes/powerlevel10k \
  # Change varialble ZSH_THEME in .zshrc \
  # && ZTHEME="\"powerlevel10k\/powerlevel10k\"" \
  && sed -i -r "s/^(ZSH_THEME=).*/\1${ZSH_THEME}/" $HOME/.zshrc

# Changeshell
# RUN chsh -s /usr/bin/zsh $USERNAME
# SHELL ["zsh", "-c" ]

RUN \
  # Git config \
  git config --global user.name "${GIT_USERNAME}" \
  && git config --global user.email "${GIT_EMAIL}"

RUN \ 
  # Install Neovim \
  wget https://github.com/neovim/neovim/releases/download/v${NEOVIM_VER}/nvim.appimage -P ${NEOVIM_DIR} \
  && ls -al ${NEOVIM_DIR} \
  && chmod u+x ${NEOVIM_DIR}/nvim.appimage \
  && cd ${NEOVIM_DIR} \
  && ./nvim.appimage --appimage-extract \
  && ln -s ${NEOVIM_DIR}/squashfs-root/usr/bin/nvim ${LOCAL_BIN}/nvim

# . command is source, and \. is to not use alias for source if there is one
# RUN \. ${NVM_DIR}/nvm.sh \

USER root

SHELL ["zsh", "-c"]

RUN \
  # Install lunarvim \
  echo "installing luarvim.." \
  && curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh | bash

# RUN \
#   # Change $HOME ownership to user \
#   chown -R "${USERNAME}:${GROUPNAME}" ${HOME}

# Copy dotfiles as last command to avoid errors
RUN \
  # Clone dotfiles repo and copy to disk \
  git clone https://github.com/iamcrash/dotfiles \
  && cp -r dotfiles/.config/* . 

# COPY --chown=$USERNAME:$USERNAME ~/dotfiles/.config ${BUILD_HOME}/.config/
# COPY --chown=$USERNAME:$USERNAME ~/dotfiles/.oh-my-zsh/custom ${BUILDHOME}/.oh-my-zsh/custom/
# COPY --chown=$USERNAME:$USERNAME ~/dotfiles/.p10* ${BUILD_HOME}/
# COPY --chown=$USERNAME:$USERNAME dotfiles/.iterm2* $HOME/

# Double quotes executes without shell
# Single quotes executes with shell
USER ${USERNAME}
WORKDIR $HOME
ENTRYPOINT ["zsh"] 
