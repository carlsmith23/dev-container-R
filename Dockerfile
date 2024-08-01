# Use debian:12-slim as the base image
FROM debian:12-slim

# Prevent interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Update package lists and install necessary packages
RUN apt-get update && apt-get install -y \
    zsh \
    git \
    python3 \
    python3-pip \
    python3-venv \
    r-base \
    pandoc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

RUN apt-get update && apt-get install -y \    
    curl \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* 

RUN apt-get update && apt-get install -y \
    texlive-full \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


# Install oh-my-zsh for a better zsh experience
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended


# Install necessary R packages
RUN R -e "install.packages(c('rmarkdown', 'knitr', 'languageserver', 'lintr', 'styler', 'tidyverse', 'reticulate', 'haven', 'Statamarkdown', 'fixest', 'broom', 'pander', 'modelsummary', 'kableExtra', 'corrplot'), repos='http://cran.rstudio.com/')"

# Set zsh as the default shell
RUN chsh -s $(which zsh)

# Create a custom .zshrc with alias
RUN echo 'alias r="radian"' >> /root/.zshrc

# Set the working directory
WORKDIR /home/project

# Expose port for RStudio Server (if you plan to run it)
EXPOSE 8787

# Set the default command to run zsh
CMD ["zsh"]