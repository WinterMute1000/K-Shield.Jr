#!/bin/bash
RESULT_FILE="home_dir_own_and_permission_check_in_`date +%Y_%M_%d_%H:%M`.txt"
user_home_directory=`cat /etc/passwd`
is_safe=1
echo "Check home directory exist,owner and permisson."
for user in $users;
do
   user_id="`echo $user | awk -F ":" '{ print $1}'`"
   user_home_directory="`echo $user | awk -F ":" '{ print $6}'`" 
   if [ -d $user_home_directory ]; then
       home_directory_own="`stat -c '%U' "$user_home_directory"`"

       if [ $user_id -ne $home_directory_own ]; then
	       echo "$user_id's Home Directory($user_home_directory) owner doesn't $user_id" >> $RESULT_FILE 2>&1
	       is_safe=0
       fi

       home_directory_perm=`stat -c '%a' "$user_rhosts"`
       home_directory_group_perm=`echo "$rhosts_perm" | awk '{ print substr($0,2,1) }'`
       home_directory_other_perm=`echo "$rhosts_perm" | awk '{ print substr($0,3,1) }'`

       if [ $home_directory_group_perm & 2 -ge 1 ] || [ $home_directory_other_perm & 2 -ge 1]; then
	       echo "$user_id's Home Directory($user_home_directory) permission has problem." >> $RESULT_FILE 2>&1
	       is_safe=0
       fi
   else
	   echo "$user_id's Home Directory($user_home_directory) doesn'texist."
	   is_safe=0
   fi
done

if [ "$is_safe" -eq 1 ]; then
	echo "Your computer pass home directory test." >> $RESULT_FILE 2>&1
else
	echo "Your computer fail to home directory test." >> $RESULT_FILE 2>&1
fi

unset RESULT_FILE
unset is_safe
