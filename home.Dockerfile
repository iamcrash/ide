FROM ide-base:latest 

# USER - logs in to user, runs shell, and populates env
USER ${USERNAME}

SHELL ["zsh", "-c"]

WORKDIR /home/${USERNAME}

RUN \
  curl -L https://raw.githubusercontent.com/iamcrash/dotfiles/dev-advanced/install.zsh | zsh

# Dockerfile commands only map variables to args
# Not shell environment variables

# WORKDIR /home/${USERNAME}
# 
# ENV ZDOTDIR=/home/${USERNAME}/.config/zsh
# 
# RUN ZSH=${ZSH} curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | zsh || true

# Clone dotfiles
# RUN \
  # TODO: change branch to main
  # git clone --branch dev https://github.com/iamcrash/dotfiles
  # && cp -r dotfiles/zsh zsh \
  # && echo "source ~/.config/zsh/.zshenv" > ~/.zshenv

# USER ${BUILD_USERNAME}
# 
# SHELL ["zsh", "-c"]
# 
# WORKDIR $HOME/.config
# 

# Install ohmyzsh

# install zsh plugins

# WORKDIR $HOME

# ENV \
#   NODE_PATH="${NVM_DIR}/versions/node/v${NODE_VER}/bin"

# ENV PATH=${NODE_PATH}:${PATH}


CMD ["zsh"]
