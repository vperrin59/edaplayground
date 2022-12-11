#!/usr/bin/env bash

apt update
apt install wget unzip python3-pip chromium-chromedriver -y
pip3 install selenium==3.14.1

echo '''
from selenium import webdriver
opts = webdriver.ChromeOptions()
opts.add_argument("--headless")
browser = webdriver.Chrome("/usr/bin/chromedriver", chrome_options=opts)
browser.get("https://gist.github.com/")
print(browser.title)
''' > selenium_test.py

python3 selenium_test.py