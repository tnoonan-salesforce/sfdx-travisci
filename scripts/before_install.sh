#!/usr/bin/env bash

set -x

echo $TRAVIS_OS_NAME

if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
    sudo apt-get -qq update
    sudo apt-get install -y wget
elif [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    sudo brew update
    sudo brew install wget
else
    echo "Unsupported OS: $TRAVIS_OS_NAME"
    exit 1
fi

node --version
uname -a

npm install -g bunyan

export SFDX_AUTOUPDATE_DISABLE=true
export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
export SFDX_DOMAIN_RETRY=300
export SFDX_NPM_REGISTRY=http://ec2-52-207-137-64.compute-1.amazonaws.com:4873/
mkdir -p $HOME/.config/sfdx/
echo "[\"salesforce-alm\"]" >> $HOME/.config/sfdx/unsignedPluginWhiteList.json

wget -qO- https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz | tar -xz - -C sfdx --strip-components=1
"./sfdx/install"
export PATH=./sfdx/$(pwd):$PATH
sfdx --version
echo 'y' > input
sfdx plugins:install salesforce-alm < input
sfdx plugins
