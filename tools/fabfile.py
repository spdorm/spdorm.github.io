from fabric.api import *
from fabric.operations import prompt
from fabric.state import env
import codecs, re, os

env.warn_only = True

base_dir = f"{os.getcwd().replace('/tools', '')}"

def cleartemp():
    with lcd(base_dir):
        local('rm -rf temp')
        local('mkdir temp') 

def buildapi():
    print(f'********** current path {os.getcwd()}')
    cleartemp()
    with lcd(base_dir):
        local(f"cp -rf api temp/")
        
    api_path = f"{base_dir}/temp/api/spdorm"
    with lcd(api_path):
        local('mvn -Dmaven.test.skip=true clean package')
        local(f'cp target/api.jar {base_dir}/spdormbuild/dist')
    print('********* end build api')


