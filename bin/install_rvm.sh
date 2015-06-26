#!/bin/bash

#update system repository
sudo apt-get update &&

# This installs curl tool for download RVM
sudo apt-get install curl &&

# Installing RVM
sudo \curl -L https://get.rvm.io | bash -s stable &&


# Set up RVM requirements 
source ~/.rvm/scripts/rvm &&
rvm requirements