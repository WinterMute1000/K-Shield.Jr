#!/bin/bash
RESULT_FILE="rhosts_use_check_in_`date +%Y_%m_%d_%H:%M`.txt"
HOSTS_EQUIV="/etc/hosts.equiv"
echo "check rhosts service(login,shell,exec)"
process_check=0
RHOSTS="/.rhosts"
IS_SAFE=1

if [ -z '`ps -ef | grep -v "grep "| egrep "login|shell|exec"`' ] && 
   [ -z '`systemctl status | egrep [512-514]`' ] && 
   [ -z '`ss -ano | egrep [512-514]`' ]; then
	process_check=1
else
	if [ -f "/etc/xinetd.d/rlogin" ] && [ '`cat /etc/xinetd.d/rlogin | grep -v '^#'` | grep -i disable | grep -i no' ]; then
		process_check=1
	fi
	if [ -f "/etc/xinetd.d/rsh" ] && [ '`cat /etc/xinetd.d/rsh | grep -v '^#'` | grep -i disable | grep -i no' ]; then
		process_check=1
	fi
	if [ -f "/etc/xinetd.d/rexec" ] && [ '`cat /etc/xinetd.d/rexec | grep -v '^#'` | grep -i disable | grep -i no' ]; then
		process_check=1
	fi
fi

if [ $process_check -eq 1 ]; then	
       	echo "You are use login or shell or exec process." >> $RESULT_FILE 2>&1
	IS_SAFE=0
else
	echo "login or shell or exec process not execute." >> $RESULT_FILE 2>&1
fi

if [ -f $HOSTS_EQUIV ]; then
	if [ '`stat -c '%U' "$HOSTS_EQUIV"`' !="root" ]; then
		echo "$HOSTS_EQUIV\'s owner isn't root." >> $RESULT_FILE 2>&1
		IS_SAFE=0
	fi

	hosts_equiv_perm=`stat -c '%a' "$HOSTS_EQUIV"`
	host_equiv_owner_perm=`echo "$hosts_equiv_perm" | 
		awk '{ print substr($0,1,1) }'`
	host_equiv_group_perm=`echo "$hosts_equiv_perm" | 
		awk '{ print substr($0,2,1) }'`
	host_equiv_other_perm=`echo "$hosts_equiv_perm" | 
		awk '{ print substr($0,2,1) }'`

	if [ "$host_equiv_owner_perm" -le 6 ] && [ "$host_equiv_group_perm" -le 0] && [ "$host_equiv_other_perm" -le 0]; then
		echo "$HOSTS_EQUIV\'s permition is safe." >> $RESULT_FILE 2>&1
	else
		echo "$HOSTS_EQUIV\'s permition isn't safe." >> $RESULT_FILE 2>&1
	        IS_SAFE=0	
       	fi
else
	echo "$HOSTS_EQUIV isn't exist." >> $RESULT_FILE 2>&1
fi

while read user
do
	user_id="`echo $user | awk -F":" '{ print $1}'`"
	user_rhosts="`echo $user | awk -F":" '{ print $6}'`$RHOSTS"
        if [ -f $user_rhosts ]; then
	    if [ '`stat -c '%U' "$user_rhosts"`' !="$user_id" ]; then
		echo "$user_rhosts\'s owner isn't $user_id." >> $RESULT_FILE 2>&1
		IS_SAFE=0
	fi

	    rhosts_perm=`stat -c '%a' "$user_rhosts"`
	    rhosts_owner_perm=`echo "$rhosts_perm" | 
	  	    awk '{ print substr($0,1,1) }'`
	    rhosts_group_perm=`echo "$rhosts_perm" | 
		    awk '{ print substr($0,2,1) }'`
	    rhosts_other_perm=`echo "$rhosts_perm" | 
		    awk '{ print substr($0,2,1) }'`

	    if [ "$rhosts_owner_perm" -le 6 ] && [ "$rhosts_group_perm" -le 0] && [ "$rhosts_other_perm" -le 0]; then
		    echo "$user_rhosts\'s permition is safe." >> $RESULT_FILE 2>&1
	    else
		    echo "$user_rhosts\'s permition isn't safe." >> $RESULT_FILE 2>&1
	            IS_SAFE=0	    
       	    fi
    else
	    echo "$user_rhosts isn't exist." >> $RESULT_FILE 2>&1
    fi
done < /etc/passwd

echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1
echo " " >> $RESULT_FILE 2>&1

if [ "$IS_SAFE" -eq 1 ]; then
	echo "Your computer pass rhosts test." >> $RESULT_FILE 2>&1

else
	echo "Your computer fail to rhosts test. Please check in." >> $RESULT_FILE 2>&1
fi

unset RESULT_FILE
unset HOSTS_EQUIV
unset IS_SAFE
