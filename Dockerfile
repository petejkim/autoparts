FROM ubuntu:12.04

RUN echo "deb http://archive.ubuntu.com/ubuntu precise main universe" > /etc/apt/sources.list

RUN apt-get update; apt-get install -y \
  automake \
  autotools-dev \
  base-files \
  base-passwd \
  binutils \
  build-essential \
  bzip2 \
  cmake \
  curl \
  dnsutils \
  gdb \
  git \
  git-core \
  gnupg \
  imagemagick \
  libarchive-dev \
  libarchive12 \
  libbz2-1.0 \
  libbz2-dev \
  libc6 \
  libcurl3 \
  libcurl3-gnutls \
  libcurl4-openssl-dev \
  libdb5.1 \
  libdb5.1-dev \
  libevent-1.4-2 \
  libevent-core-1.4-2 \
  libevent-dev \
  libevent-extra-1.4-2 \
  libffi-dev \
  libgdbm-dev \
  libglib2.0-dev \
  libglib2.0-dev \
  libldap-2.4-2 \
  libldap2-dev \
  libltdl-dev \
  libltdl7 \
  liblzma-dev \
  liblzma-doc \
  liblzma5 \
  libmagickcore-dev \
  libmagickwand-dev \
  libmysqlclient-dev \
  libncap-dev \
  libncap44 \
  libncurses5-dev \
  libncurses5-dev \
  libncursesw5 \
  libncursesw5-dev \
  libncursesw5-dev \
  libpam0g-dev \
  libpng12-0 \
  libpng12-dev \
  libpq-dev \
  libqt4-dev \
  libreadline6-dev \
  libsndfile1-dev \
  libsqlite3-dev \
  libssl0.9.8 \
  libxml2 \
  libxml2-dev \
  libxslt1-dev \
  libxt-dev \
  libxt6 \
  libyaml-dev \
  openssl \
  psmisc \
  ruby1.9.3 \
  s3cmd \
  sqlite3 \
  tsconf \
  unzip \
  util-linux \
  wget \
  whiptail \
  xz-utils \
  zlib1g \
  zlib1g-dev

RUN adduser --disabled-password action
RUN mkdir -p /home/action/.parts
RUN git clone https://github.com/nitrous-io/autoparts.git /home/action/.parts/autoparts
RUN chown -R action:action /home/action

ENV PATH /home/action/.parts/autoparts/bin:${PATH}
ENV AUTOPARTS_DEV true
ENV HOME /home/action
WORKDIR /home/action
