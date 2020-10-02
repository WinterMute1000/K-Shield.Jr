#!/bin/bash
RESULT_FILE="cron_file_check_in_`date +%Y_%M_%d_%H:%M`.txt"
ALLOW_FILE="/etc/cron.allow"
DENY_FILE="/etc/cron.deny"
echo "Check cron allow and deny file."
is_safe=1
if [ -f "/etc/cron.allow" ]; then
	allow_file_own=`stat -c '%U' "$ALLOW_FILE"`

	if [ $allow_file_own -eq "root" ]; then
		allow_file_perm=`stat -c '%a' "$ALLOW_FILE"`
		allow_file_own_perm=`echo "$allow_file_perm" | awk '{ print substr($0,1,1) }'`
		allow_file_group_perm=`echo "$allow_file_perm" | awk '{ print substr($0,2,1) }'`
		allow_file_other_perm=`echo "$allow_file_perm" | awk '{ print substr($0,3,1) }'`
		
	        if [ $allow_file_own_perm -gt 6 ] || [ $allow_file_group_perm -gt 4 ] || [ $allow_file_other -gt 0 ]; then
			echo "Allow file permission have problem." >> $RESULT_FILE 2>&1
			is_safe=0
	        else
			echo "Allow file is safe." >> $RESULT_FILE 2>&1
	        fi
	else
		echo "Allow file owner doesn't root ($allow_file_own)" >> $RESULT_FILE 2>&1
		is_safe=0
	fi
else
	echo "Allow file doesn't exist." >> $RESULT_FILE 2>&1
	is_safe=0
fi

		
if [ -f "/etc/cron.deny" ]; then
	deny_file_own=`stat -c '%U' "$DENY_FILE"`

	if [ $deny_file_own -eq "root" ]; then
		deny_file_perm=`stat -c '%a' "$DENY_FILE"`
		deny_file_own_perm=`echo "$deny_file_perm" | awk '{ print substr($0,1,1) }'`
		deny_file_group_perm=`echo "$deny_file_perm" | awk '{ print substr($0,2,1) }'`
		deny_file_other_perm=`echo "$deny_file_perm" | awk '{ print substr($0,3,1) }'`
		
	        if [ $deny_file_own_perm -gt 6 ] || [ $deny_file_group_perm -gt 4 ] || [ $deny_file_other -gt 0 ]; then
			echo "Deny file permission have problem." >> $RESULT_FILE 2>&1
			is_safe=0
	        else
			echo "Deny file is safe." >> $RESULT_FILE 2>&1
	        fi
	else
		echo "Deny file owner doesn't root ($deny_file_own)" >> $RESULT_FILE 2>&1
		is_safe=0
	fi
else
	echo "Deny file doesn't exist." >> $RESULT_FILE 2>&1
fi

if [ $is_safe -eq 1 ]; then
	echo "Your computer is pass cron file check." >> $RESULT_FILE 2>&1
else
	echo "Your computer isn't pass cron file check." >> $RESULT_FILE 2>&1
fi

unset ALLOW_FILE
unset DENY_FILE
unset is_safe



		



