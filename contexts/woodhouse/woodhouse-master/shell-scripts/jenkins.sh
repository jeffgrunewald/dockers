#!/bin/bash
if [ "${LOG_LEVEL}" != "INFO" ]; then
  sed -i "s/INFO/${LOG_LEVEL}/g" ${JENKINS_HOME}/log.properties
fi

JENKINS_ROOT=/usr/share/jenkins
JENKINS_WAR=/usr/share/jenkins/jenkins.war

current_path=$(dirname ${BASH_SOURCE[0]})

[ -r ${current_path}/config ] && . ${current_path}/config

find "${JENKINS_HOME}" -xdev -user 0 | xargs chown woodhouse
gosu woodhouse:woodhouse java ${JAVA_ARGS} -jar ${JENKINS_WAR} ${JENKINS_ARGS}
