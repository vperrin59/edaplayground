from selenium import webdriver
from selenium.webdriver.chrome.options import Options

from selenium.webdriver.support.ui import WebDriverWait
import os
import json
import time

webdriver_path = "/usr/bin/chromedriver"

chrome_options = Options()
chrome_options.add_argument('--headless')
chrome_options.add_argument('--no-sandbox')
chrome_options.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome(webdriver_path, options=chrome_options)

driver.get('https://www.edaplayground.com/login')

print(driver.title)

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

design = """
module event_race2 ();

  logic clk;
  logic [1:0] data;
  logic [1:0] nb_data;
  event b_start_ev;
  event nb_start_ev;

  // There is a race between always 1 and always 2 block.
  // If always 1 executes before always 2 -> test will finish at 5
  // If always 2 executes before always 1 -> test will finish at 10

  // In order to avoid this race you can use non blocking event triggering (->>)
  // instead of blocking event trigger (->)

  // Another way to avoid the race condition is on the event catch (persistent trigger).
  // Using wait(ev.triggered) will allow an event to persist throughout the time step in which the event is triggered

  initial begin
    data = 0;
    nb_data <= 0;
    clk = 0;

    #5ns;

    data = 1;
    // nb_data <= 1;
    clk = 1;
    data = 2;
    // nb_data <= 2;

    #5ns;

    $finish;
  end

  always @(posedge clk) begin
    nb_data <= 2;
  end

  always @(posedge clk)
  begin
    $display($time,,"posedge clk trigger");
    // Blocking event trigger
    ->b_start_ev;
    // Non blocking event trigger
    ->>nb_start_ev;
  end

  always @(b_start_ev)
  begin
    $display($time,,"sampled d in blocking: %d", data);
    $display($time,,"sampled nb_d in blocking: %d", nb_data);
  end

  always @(nb_start_ev)
  begin
    $display($time,,"sampled d in non-blocking: %d", data);
    $display($time,,"sampled nb_d in non-blocking: %d", nb_data);
  end

  always @(b_start_ev)
  begin
    #0;
    $display($time,,"sampled d in #0 blocking: %d", data);
    $display($time,,"sampled nb_d #0 in blocking: %d", nb_data);
  end

endmodule

  """

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

cwd = os.getcwd()

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
