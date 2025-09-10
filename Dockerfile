FROM rocker/rstudio

# Update and install packages for man pages
RUN apt update && \
    apt install -y yes man-db && \
    rm -rf /var/lib/apt/lists/*

# Restore full documentation support
RUN yes | unminimize
