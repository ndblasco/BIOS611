FROM rocker/verse:latest

RUN Rscript -e "install.packages(c('tidyverse', 'git2r', 'kableExtra', 'plotly', 'caret', 'pROC', 'MASS', 'gt', 'rmarkdown'))"

# Set working directory
WORKDIR /bios611-project

# Copy everything from your local folder into the container
COPY . /bios611-project


