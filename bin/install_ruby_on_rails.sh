#!/bin/bash

# Installation of ruby 2.2.1
rvm install 2.2.1 &&

source ~/.rvm/scripts/rvm
# Set up just installed ruby as a default
rvm use ruby 2.2.1 --default &&

# Instalation of rubygems
rvm rubygems current &&

# Instalation of rails
gem install rails -v 4.2.0 