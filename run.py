from selenium import webdriver
from selenium.webdriver.chrome.options import Options

chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
d = webdriver.Chrome('/usr/bin/chromedriver',chrome_options=chrome_options)
d.get("https://google.com/")
print(d.title)