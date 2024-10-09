#!/usr/bin/env sh
sudo apt --assume-yes install \
  composer \
  dos2unix \
  ffmpegthumbnailer \
  google-cloud-cli \
  helix \
  libcurl4-openssl-dev \
  libluajit-5.1-dev \
  libpq-dev \
  libsqlite3-dev \
  libxcb-render0-dev \
  libxcb-shape0-dev \
  libxcb-xfixes0-dev \
  lua5.4 \
  luarocks \
  make \
  moreutils \
  mosh \
  mosquitto-clients \
  msmtp-mta \
  pass \
  poppler-utils \
  ncat \
  ntpdate \
  parallel \
  php-bcmath \
  php-curl \
  php-gmp \
  sqlite3 \
  stripe \
  trash-cli \
  unar \
  zsh

. /etc/lsb-release

if [ "${DISTRIB_RELEASE}" = '22.04' ]; then
  sudo apt --assume-yes install libgit2-1.1
  sudo ln -fs /usr/lib/*/libgit2.so.1.1 /usr/local/lib/libgit2.so
  sudo ldconfig
fi

if [ "${DISTRIB_RELEASE}" = '24.04' ]; then
  sudo apt --assume-yes install libgit2-1.7
fi
