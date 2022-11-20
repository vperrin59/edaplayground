from selenium import webdriver
# from selenium.webdriver.chrome.options import Options

from selenium.webdriver.support.ui import WebDriverWait

from zipfile import ZipFile

import os
import json
import time

webdriver_path = "/usr/bin/chromedriver"

chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')

prefs = {"profile.default_content_settings.popups": 0, "download.default_directory": os.getcwd()}
chrome_options.add_experimental_option("prefs", prefs)

driver = webdriver.Chrome(webdriver_path, options=chrome_options)

driver.get('https://www.edaplayground.com/login')

print(driver.title)

cwd = os.getcwd()

for _ in range(2):

    username_input = driver.find_element_by_name("j_username")
    username_input.send_keys(os.environ["EDA_LOGIN"])

    password_input = driver.find_element_by_name("j_password")
    password_input.send_keys(os.environ["EDA_TOKEN"])

    time.sleep(1)

    # login_form = driver.find_element_by_name("loginForm")
    # login_form.submit()

    login_form = driver.find_element_by_name("submit")
    login_form.click()

    WebDriverWait(driver=driver, timeout=10).until(
        lambda x: x.execute_script("return document.readyState === 'complete'")
    )

    time.sleep(1)

design_fnames = [
    os.path.join(cwd, "src/15_process_synch/event_race.sv"),
    os.path.join(cwd, "src/13_task_function/automatic_lifetime.sv"),
    os.path.join(cwd, "src/9_processes/always_comb_diff.sv"),
]

for design_fname in design_fnames:

    try:
        os.remove("result.zip")
    except:
        pass

    design = open(design_fname, "r").read()

    testbench = ""

    design = json.dumps(design)
    testbench = json.dumps(testbench)

    simulators = {
        "Aldec": 1204,
        "Xcelium": 1501,
        "Questa": 1701,
        "VCS": 1301,
    }

         # $('#vcsCompileOptions').val("-timescale=1ns/1ns +vcs+flush+all +warn=all -sverilog");

    script = r"""
         $('#testbenchLanguage').val('SystemVerilog/Verilog');
         $('#methodologyLibrary').val('701'); // UVM 1.2
         $('#otherLibrary').val('');
         $('#resultZip').click();
         $('#simulator').val({});
         var designEditor = designTabs.getActiveEditor();
         designEditor.setValue({});

         var testbenchEditor = testbenchTabs.getActiveEditor();
         testbenchEditor.setValue({});

         $('#runButton').click();

         """.format(simulators["Xcelium"], design, testbench).strip()


    driver.execute_script(script)

    wait = WebDriverWait(driver, timeout=120, poll_frequency=0.5)

    def download_complete(driver, path="{}/result.zip".format(cwd)):
        size = 0
        last_size = -1

        while size != last_size:
            if os.path.isfile(path):
                size = os.path.getsize(path)
                last_size = size
            time.sleep(1)
        return True

    wait.until(download_complete, "download timed-out")

    # os.rename("result.zip", f"")
    results = ZipFile("result.zip", "r").read("xrun.log").decode("utf-8")

    log = design_fname.replace(".sv", "_run.log")

    print(f"Generating {log}")
    # with open(os.path.join(os.path.dirname(design_fname), "xrun.log"), "w") as f:
    with open(log, "w") as f:
        f.write(results)