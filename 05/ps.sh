#!/bin/bash

for i in $(ls -d /proc/* | grep -Eo "[0-9]{1,4}" | uniq | sort -V)
do
    if [ -f /proc/$i/cmdline ]; then
       if [ "`awk 'END { print (NR > 0 && NF > 0) ? "1" : "0"}' /proc/$i/cmdline`" == "1" ]; then
          echo -n $i ' ''(PID)'==' '
          echo -n $(cat /proc/$i/cmdline | tr "\0" "\n" | sed '1!'D);
       else
          echo -n $i ==' '
          echo -n $(cat /proc/$i/comm | tr "\0" "\n" | sed '1!'D);
       fi
    echo -n ' '==' '
    echo -n $(cat /proc/$i/status | tr "\0" "\n" | awk '/State/{print $2}');
    echo -n ' ''(State)' ' '==' '
    echo -n $(cat /proc/$i/status | tr "\0" "\n" | awk '/VmRSS/{print $2}');
    echo ' ''(VmRSS)'

    qqq=`awk '/Uid/{print $2}' /proc/$i/status`
    if [[ qqq -eq 0 ]]
       then
       user='root'
    else
       user=`grep x:$qqq /etc/passwd | awk -F ":" '{print $1}'`
    fi

    echo -n $user ==' '
    fi
done
