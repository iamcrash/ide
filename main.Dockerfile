FROM ide-base:latest

USER ${USERNAME}

SHELL [ "/usr/bin/zsh","-c" ]

WORKDIR ${HOME}

# Create directories if doesn't exist
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

RUN \
  # Clone dotfiles
  git clone --branch dev https://github.com/iamcrash/dotfiles

RUN \
  # Install Oh-my-zsh \
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

# Rust environment variables
# ENV 
#   RUSTUP_HOME=${XDG_DATA_HOME}/rustup \
#   CARGO_HOME=${XDG_DATA_HOME}/cargo
RUN \
  # Install Rust \
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

RUN \
  # Install NVM \
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | zsh \
  && . ${NVM_DIR}/nvm.sh \
  # Install Node \
  && nvm install ${NODE_VER} \
  && nvm use node \
  && npm install --global yarn \
  && yarn global add neovim 

RUN \
  # Install Nerdfonts \
  curl -o "${XDG_FONTS_HOME}/Droid Sans Mono for Powerline Nerd Font Complete.otf" -fL https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf \
  # Install Powerlevel10k theme \
  && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH:-$ZSH}/themes/powerlevel10k

# RUN \  
  ## Change varialble ZSH_THEME in .zshrc \
  # ZTHEME="\"powerlevel10k\/powerlevel10k\"" \
  # && sed -i -r "s/^(ZSH_THEME=).*/\1${ZSH_THEME}/" $HOME/.zshrc

RUN \ 
  # Install Neovim \
  wget https://github.com/neovim/neovim/releases/download/v${NEOVIM_VER}/nvim.appimage -P ${NEOVIM_DIR} \
  && chmod u+x ${NEOVIM_DIR}/nvim.appimage \
  && cd ${NEOVIM_DIR} \
  && ./nvim.appimage --appimage-extract \
  && ln -s ${NEOVIM_DIR}/squashfs-root/usr/bin/nvim ${LOCAL_BIN}/nvim

# ENV \
#   LUNARVIM_CONFIG_DIR="${XDG_CONFIG_HOME}/lvim" \
#   LUNARVIM_RUNTIME_DIR="${XDG_DATA_HOME}/lunarvim" 
RUN \
  # Install lunarvim \
  wget https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh \
  && chmod +x install.sh \
  && yes | ./install.sh \
  && rm install.sh

WORKDIR $HOME

RUN \
  cp -r dotfiles/zsh $XDG_CONFIG_HOME \
  && cp .zshrc $XDG_CONFIG_HOME/zsh/build/zshrc \
  && env > $XDG_CONFIG_HOME/zsh/build/env \
  && cp $XDG_CONFIG_HOME/zsh/zshrc .zshrc \
  && cp -r dotfiles/iterm2 $XDG_CONFIG_HOME

# Double quotes executes without shell
# Single quotes executes with shell
ENTRYPOINT ["/usr/bin/zsh"] 
