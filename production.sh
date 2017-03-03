#!/bin/bash

echo "-----Start bootstrap for production-----"
sudo apt-get update
sudo apt-get -y install git-core curl vim openssl libtool bison imagemagick autoconf libncurses5-dev\
  build-essential libc6-dev libreadline6 libreadline6-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libffi-dev\
  libxml2-dev libxslt-dev libmagickwand-dev libpcre3-dev

echo "-----Install nodejs-----"
sudo apt-get -y install python-software-properties python g++ make
sudo add-apt-repository ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get -y install nodejs

echo "Well you need to install Nginx?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install nginx
  sudo service nginx start
fi

echo "-----Install Database-----"
echo "Well you need to install mysql-server?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install mysql-server libmysqlclient-dev
fi

echo "Well you need to install postgresql-server?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install postgresql libpq-dev
fi

echo "Well you need to install postgresql-client?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install postgresql-client libpq-dev
fi

echo "-----Install Others-----"
echo "Well you need the gem of curb?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install libcurl3 libcurl3-gnutls libcurl4-openssl-dev
fi

echo "Well you need the phantomjs?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get -y install phamtomjs
fi

echo "Well you need the ntpdate and sync time?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo apt-get install ntpdate
  sudo ntpdate us.pool.ntp.org
  sudo hwclock --systohc
fi

echo "-----Install ruby by rbenv-----"
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
git clone https://github.com/rbenv/rbenv-gem-rehash.git ~/.rbenv/plugins/rbenv-gem-rehash
git clone https://github.com/rkh/rbenv-update.git ~/.rbenv/plugins/rbenv-update
printf 'export PATH="$HOME/.rbenv/bin:$PATH"\n' >> ~/.bashrc
printf 'eval "$(rbenv init - --no-rehash)"\n' >> ~/.bashrc
source ~/.bashrc
~/.rbenv/bin/rbenv init

ruby_version="$(curl -sSL https://raw.githubusercontent.com/caok/server-bootstrap/master/versions/ruby)"
printf "Installing Ruby $ruby_version ...\n"
rbenv install -s "$ruby_version"
rbenv global "$ruby_version"
rbenv rehash

gem update --system
gem install bundler rake --no-document
rbenv rehash

echo "Well you need the reboot your system?(Y/N) (default: N) __"
read dorm
dorm=${dorm:=N}
if [ $dorm = Y ]; then
  sudo reboot
fi
