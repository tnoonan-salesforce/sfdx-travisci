#!/usr/bin/env bash

set +x

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

if ! [ -x "node" ]; then 
    echo "node is not installed"
    exit 1
fi 

node --version
uname -a

if ! [ -x "bunyan" ]; then 
    echo "Bunyan not installed. Installing ...."
    npm install -g bunyan    
fi

if [ -x "openssl" ]; then 
    openssl aes-256-cbc -K $encrypted_444a0b982a79_key -iv $encrypted_444a0b982a79_iv -in assets/server.key.enc -out assets/server.key -d
else
    echo "Please install openssl"
fi


export SFDX_AUTOUPDATE_DISABLE=true
export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
export SFDX_DOMAIN_RETRY=300

wget -qO- $URL | tar xJf -
"./sfdx/install"

export PATH=./sfdx/$(pwd):$PATH
sfdx update
sfdx --version
sfdx plugins --core