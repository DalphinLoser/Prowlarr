# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.19

# set version label
ARG VERSION
ARG ZIP_DOWNLOAD_LINK
LABEL maintainer="dalphinloser"
ARG BRANCH

# environment settings
ENV XDG_CONFIG_HOME="/config/xdg"

# Install necessary packages including Subversion for svn export and curl for downloading assets
RUN \
  echo "**** install packages ****" && \
  apk add -U --upgrade --no-cache \
    icu-libs \
    sqlite-libs \
    xmlstarlet \
    unzip \
    curl \
    git  
RUN \
    echo "**** install prowlarr ****"
RUN \    
    mkdir -p /app/prowlarr/bin
RUN \    
    curl -o /tmp/prowlarr.zip -L \
        -H "Authorization: Bearer $GITHUB_TOKEN" \
        -H "Accept: application/octet-stream" \
        ${ZIP_DOWNLOAD_LINK}
RUN \    
    unzip /tmp/prowlarr.zip -d /app/prowlarr/bin && \
    chmod 755 /app/prowlarr/bin/Prowlarr || true
RUN \
    echo -e "UpdateMethod=docker\nBranch=${BRANCH}\nPackageVersion=${VERSION}\nPackageAuthor=[linuxserver.io](https://www.linuxserver.io/), ${MAINTAINER}" > /app/prowlarr/package_info
RUN \
    echo "**** cleanup ****" && \
    rm -rf \
        /app/prowlarr/bin/Prowlarr.Update \
        /tmp/* \
      /var/tmp/*

# Expose port and volume
EXPOSE 9696
VOLUME /config
