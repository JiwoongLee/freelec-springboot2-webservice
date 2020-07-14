#!/bin/bash

REPOSITORY=/home/ec2-user/app/step2
PROJECT_NAME=freelec-springboot2-webservice

cd $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> confirm the current running application pid"

CURRENT_PID=$(pgrep -f1 freelec-springboot2-webservice | grep jar | awk '{print $1'})

echo "> current running application pid: $CURRENT_PID"

if [ -z "$CURRENT_PID" ]; then
  echo "> There is no currently running application, so it does not exit."
else
  echo "> kill -15 $CURRENT_PID"
  kill -15 $CURRENT_PID
  sleep 5
fi

echo "> deploy new application"

JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"

echo "> adding execute permission in $JAR_NAME"

chmod +x $JAR_NAME

echo "> Execute $JAR_NAME"

nohup java -jar \
  -Dspring.config.location=classpath:/application.properties,classpath:/application-real.properties,/home/ec2-user/app/application-oauth.properties,/home/ec2-user/app/application-real-db.properties \
  -Dspring.profiles.active=real \
  $JAR_NAME > $REPOSITORY/nohup.out 2>&1 &