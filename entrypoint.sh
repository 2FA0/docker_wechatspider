#!/bin/bash

LOG_DIR=/tmp/wechat-spider/
APP_DIR=/home/wechat-spider/
RUNTIME_LOG=${LOG_DIR}runtime.log
SCHEDULER_LOG=${LOG_DIR}scheduler.log
DOWNLOADER_LOG=${LOG_DIR}downloader.log
EXTRACTOR_LOG=${LOG_DIR}extractor.log
PROCESSOR_LOG=${LOG_DIR}processor.log

if [[ ! -d $LOG_DIR ]];then
    mkdir -p $LOG_DIR
fi

touch $RUNTIME_LOG
touch $SCHEDULER_LOG
touch $DOWNLOADER_LOG
touch $EXTRACTOR_LOG
touch $PROCESSOR_LOG
echo `ls -la`
echo `pwd`
echo `find / -name "crontab" `
echo `find / -name "manage.py" `
echo `find / -name "downloader.py" `

# python manage.py createsuperuser --username=root --email=init_password

nohup python ${APP_DIR}manage.py migrate >1.txt 2>&1 &

#启动worker进程
nohup python ${APP_DIR}bin/scheduler.py >/dev/null 2>$SCHEDULER_LOG &
nohup python ${APP_DIR}bin/downloader.py >/dev/null 2>$DOWNLOADER_LOG &
nohup python ${APP_DIR}bin/extractor.py >/dev/null 2>$EXTRACTOR_LOG &
nohup python ${APP_DIR}bin/processor.py >/dev/null 2>$PROCESSOR_LOG &

python ${APP_DIR}manage.py runserver 0.0.0.0:8001