#!/usr/bin/env bash

apt update
apt install wget unzip python3-pip -y

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

dpkg -i google-chrome-stable_current_amd64.deb
apt-get install -f -y
dpkg -i google-chrome-stable_current_amd64.deb

google-chrome --version

wget https://chromedriver.storage.googleapis.com/107.0.5304.62/chromedriver_linux64.zip

unzip ./chromedriver_linux64.zip

mv chromedriver /usr/bin/

chmod +x /usr/bin/chromedriver

pip install selenium==3.14.1
# apt-get install glib2.0 libnss3 -y

chromedriver --url-base=/wd/hub --whitelisted-ips= &

bash