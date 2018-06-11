import sys
import os
from selenium import webdriver
from urlparse import urlparse
from termcolor import colored, cprint

from selenium.webdriver.common.keys import Keys  
from selenium.webdriver.chrome.options import Options

cprint("""
 _                     __ __ _           _
| |                   /  ___| |         | |   
| |     __ _ _____   _\ `--.| |__   ___ | |_  
| |    / _` |_  / | | |`--. \ '_ \ / _ \| __| 
| |___| (_| |/ /| |_| /\__/ / | | | (_) | |_  
\_____/\__,_/___|\__, \____/|_| |_|\___/ \__| 
                  __/ |                     
                 |___/   By: Mukesh Dhama & Sahil Ahamad
---------------------------------------------------------                     
\n\n""", 'green')



OUTPUT = 'outputs'
INPUT_FILE = sys.argv[1]

try:
   file = open(INPUT_FILE, "r")
except IOError:
   cprint ("ERROR: There was an error reading file.\n", 'red')
   sys.exit()

if len(sys.argv) > 3:
    if len(sys.argv) < 4:
        cprint("ERROR: Missing folder name. eg: --out <folder_name>\n", 'red')
        sys.exit()
    else:
        OUTPUT = sys.argv[3]


fileData = tuple(file.readlines())
file.close()

if len(fileData) <= 0:
    cprint ("ERROR: File is empty! Please data into the file\n", 'red')
    sys.exit()


def urlParser(url):
    o = urlparse(url)
    if len(o.scheme) == 'http' or len(o.scheme) == 'https':
        return url
    elif len(o.path) <= 0:
        return False
    else:
        return 'http://' + o.path


def takeScreeshot(url):
    if len(url) == 0:
        return False
    else:
        u = urlParser(url.strip())
        if u:
            if not os.path.exists(OUTPUT):
                os.makedirs(OUTPUT)
            
            chrome_options = Options()
            chrome_options.add_argument("--headless") 
            driver = webdriver.Chrome(executable_path=os.path.abspath("chromedriver"), chrome_options=chrome_options)
            driver.set_window_size(1280, 1024) 
            driver.get(u)
            driver.save_screenshot(os.getcwd() + '/' +OUTPUT + '/screenshot-' + urlparse(url).path + '.png')  
            return True
        else:
            return False

if len(fileData) > 0:
    for url in fileData:
        result = takeScreeshot(url)
        if result:
            cprint(url.strip() + ' is ready.', 'green')
sys.exit()
    
    



    
