#!/bin/bash
DATE=$(date +'%F %H:%M:%S')
DIR=/var/log/
echo "Bashrc Load date and time: $DATE" #> $DIR/clearSM.log

####### FOR D2B_CommunityMgr  ########################################################

D2B_CommunityMgr_PidList=( $(ps -aux | grep D2B_CommunityMgr | grep -v grep | awk -F ' ' '{print $2}') )
for list in "${D2B_CommunityMgr_PidList[@]}"
do
    for item in $list
    do
        kill -9 $item
	      all=( $(ipcs -mp | grep $item | grep -v grep |awk {'printf ("%5s\t%s\n", $1, $3)'}|grep $item |awk -F ' ' '{print $1}') )
    done
done


####### FOR DSS_LocalCtrl  ########################################################

DSS_LocalCtrl_PidList=( $(ps -aux |grep DSS_LocalCtrl | grep -v grep | awk -F ' ' '{print $2}') )
for list in "${DSS_LocalCtrl_PidList[@]}"
do
    for item in $list
    do
	      kill -9 $item
        all+=( $(ipcs -mp | grep $item | grep -v grep | awk {'printf ("%5s\t%s\n", $1, $3)'}|grep $item |awk -F ' ' '{print $1}') )
    done
done

####### FOR application32 #########################################################

application32_PidList=( $(ps -aux | grep application32 | grep -v grep | awk -F ' ' '{print $2}') )
for list in "${application32_PidList[@]}"
do
    for item in $list
    do
        kill -9 $item
	      all+=( $(ipcs -mp | grep $item | grep -v grep | awk {'printf ("%5s\t%s\n", $1, $3)'}| grep $item | awk -F ' ' '{print $1}') )
    done
done

####### FOR ALL PIDS DELETE ->  Remove the shared memory segment ####################

for i in ${all[@]}; do ipcrm shm $i; done

