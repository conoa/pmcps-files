#!/bin/bash

apt-get update
apt-get install apt-offline

apt-get -y install \
    python3 \
    python3-venv \
    ansible \
    git vim nano curl wget unzip jq \
    openssh-client


 dpkg --get-selections > pre-installed-packages.txt
    3  cat pre-installed-packages.txt
    4  apt-get -y install     python3     python3-venv     ansible     git vim nano curl wget unzip jq     openssh-client
    5  apt update
    6  apt-get -y install     python3     python3-venv     ansible     git vim nano curl wget unzip jq     openssh-client
    7  dpkg --get-selections > post-installed-packages.txt
    8  diff pre-installed-packages.txt post-installed-packages.txt > installed-diff.txt

