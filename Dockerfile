FROM rocker/verse:latest

RUN Rscript -e "install.packages(c('tidyverse', 'git2r'), repos='https://cloud.r-project.org')"

# Set working directory
WORKDIR /bios611-project

# Copy everything from your local folder into the container
COPY . /bios611-project

# Default command: run your Makefile
CMD ["make"]


