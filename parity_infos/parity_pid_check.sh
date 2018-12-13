#!/bin/sh

dt=`date '+%d/%m/%Y %H:%M:%S'`

echo "===== date: ${dt} process check start =====" >> logs_parity_check.txt

if pgrep -x "parity" > /dev/null
then
    # 실행 중
    echo "===== date: ${dt} runing =====" >> logs_parity_check.txt
else
    # 실행중이지 않음 -> 재시작 
    echo "===== date: ${dt} restarting =====" >> logs_parity_check.txt
    ./start.sh
fi

echo "===== date: ${dt} end =====" >> logs_parity_check.txt