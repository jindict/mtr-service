#!/bin/bash
# by Julia 2023-06-14

SNT=$1
TARGET=$2
RESULT="$2.mtr.txt"
MAIL_LIST="xxx@xxx"

# 持續運行，這裡使用了無窮迴圈
while true; do
    # 取得目前的日期時間，美東時間
    TZ='America/New_York' date +"%F_%T_%Z" > ${RESULT}

    # 執行 mtr 命令並將輸出存入變數中
   mtr -w --report --report-cycles=${SNT} ${TARGET} | tee -a ${RESULT} >> /home/ldap_users/ginn_lai/mtr/mtr-${TARGET}.log
    #tail -f mtr-${TARGET}.log
    
    # 取得最後1跳的SNT
    LOSS_RATIO=$(tail -n 1 ${RESULT} | awk '{print $3}')
    LAST_SNT=$(tail -n 1 ${RESULT} | awk '{print $4}')


    # 檢查SNT第一跳不等於最後一跳，則寄信通知
     if [[ ${LAST_SNT} != ${SNT} ]]; then
       cat ${RESULT} | mail \
       -s "mtr ${TARGET} ${LOSS_RATIO}" \
       -r "xxx@gmail.com" \
       -a ${RESULT} \
       ${MAIL_LIST}
     fi

    # 在每次迴圈後等待一段時間，這裡暫停5秒
    sleep 5
done