from fabric.api import *
from fabric.operations import prompt
from fabric.state import env
import codecs, re, os

env.warn_only = True

def buildapi():
    print(f'********** current path {os.getcwd()}')
    api_path = f"{os.getcwd().replace('/tools', '')}/api/spdorm"
    with lcd(api_path):
        local('mvn -Dmaven.test.skip=true clean package')
        local('cp target/api.jar ../../spdormbuild/dist')
    print('********* end build api')


