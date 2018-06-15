#!/usr/bin/env python
# encoding: utf-8
from __future__ import print_function
from httplib2 import Http
import os
import json
import sys
from apiclient import discovery
from oauth2client import client
from oauth2client.service_account import ServiceAccountCredentials
from oauth2client import tools
from oauth2client.file import Storage
try:
    flags = None
except ImportError:
    flags = None
# If modifying these scopes, delete your previously saved credentials
# at ~/.credentials/admin-directory_v1-python-quickstart.json
SCOPES = ['https://www.googleapis.com/auth/admin.directory.user.readonly',\
         'https://www.googleapis.com/auth/admin.directory.domain.readonly',\
         'https://www.googleapis.com/auth/admin.directory.orgunit.readonly']
def get_credentials():
    credentials = ServiceAccountCredentials.from_json_keyfile_name('/Applications/zz_GoogleJAMFsync.app/jamf.json',scopes=SCOPES)
    delegated_credentials = credentials.create_delegated('wireland@doctorondemand.com')
    return delegated_credentials

def main():
    credentials = get_credentials()
    creds = credentials.authorize(Http())
    service = discovery.build('admin', 'directory_v1', http=creds)
    email = sys.argv[1]
    results = service.users().list(domain="doctorondemand.com",projection="full",query='email={0}'.format(email)).execute()
    print(results["users"][0]["name"])
    print(results["users"][0]["orgUnitPath"])

if __name__ == '__main__':
    main()