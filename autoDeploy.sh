#!/bin/sh

#====================================================================
# autoDeploy.sh
#
# Copyright (c) 2013, jiaozhu <gitview@gmail.com>
# All rights reserved.
# Distributed under the GNU General Public License, version 3.0.
#
# See: http://jiaozhu.org/archives/15/
#
# V 0.1, Date: 2013-04-26
#
#====================================================================


WL_HOME="/root/bea"

TMP_URL=`/sbin/ifconfig | grep "inet addr" | grep -v "127.0.0.1" | awk '{print $2}' | cut -d: -f 2 | head -1`


getApp(){

	echo "Please enter your application file name:"
	read -p "(Default : jstl.ear ):" APP_FILE
	
	TMP_FILE="jslt.ear"
	
	if [ -z $APP_FILE ]; then
		APP_FILE=$TMP_FILE
	fi
}

def_target(){
	
	echo "Please enter your target where you want to deploy."
	read -p "(Default : MyCluster):" TARGET
	
	TMP_ARGET="MyCluster"
	
	if [ -z $TARGET ];then
		TARGET=$TMP_ARGET
	fi
	
}

if [ ! -f "${WL_HOME}/weblogic81/server/lib/weblogic.jar" ]; then
	echo 
	echo "The WebLogic Server wasn't found in directory ${WL_HOME}/weblogic81."
	echo "Please edit the startDeploy.sh script so that the WL_HOME"
	echo "variable points to the WebLogic installation directory."
	echo 
	exit
fi


usage()
{
  echo "Need to set deploy method [deploy,undeploy] ,admin URL and application name"
  echo "them in command line:"
  echo 'Usage: ./autoDeploy.sh [Method] [ADMIN_URL] [APP_NAME]'
  echo "for example:"
  echo "$0 deploy t3://${TMP_URL}:3001 jstl"
  exit 1
}


if [ ${#} = 0 ]; then
  if [ "x${METHOD_NAME}" = "x" -o "x${ADMIN_URL}" = "x" -o "x${APP_NAME}" = "x" ]; then
    usage
  fi
elif [ ${#} = 1 ]; then
  METHOD_NAME=${1}
  if [ "x${ADMIN_URL}" = "x" -o "x${APP_NAME}" = "x" ]; then
    usage
  fi
elif [ ${#} = 2 ]; then
  METHOD_NAME=${1}
  ADMIN_URL=${2}
  if [ "x${APP_NAME}" = "x" ]; then
	usage
  fi
elif [ ${#} = 3 ]; then
	METHOD_NAME=${1}
	ADMIN_URL=${2}
	APP_NAME=${3}
else
    usage
fi


deploy(){
	# echo `java weblogic.Deployer -version`
	. "${WL_HOME}/weblogic81/server/bin/setWLSEnv.sh"
	echo
	echo
	echo "start deploy application : ${APP_NAME} "
	echo
	echo `java ${MEM_ARGS} weblogic.Deployer -adminurl ${ADMIN_URL} -userconfigfile userconfig -userkeyfile userkey -name ${APP_NAME} -targets ${TARGET} -nostage -deploy ${APP_FILE}`
	echo
	echo "completed! please check your domain!"
}

undeploy(){
	. "${WL_HOME}/weblogic81/server/bin/setWLSEnv.sh"
	echo 
	echo
	echo "start undeploy application : ${APP_NAME} "
	echo
	echo `java ${MEM_ARGS} weblogic.Deployer -adminurl ${ADMIN_URL} -userconfigfile userconfig -userkeyfile userkey -name ${APP_NAME} -undeploy`
	echo
	echo "completed! please check your domain!"
}



if [ "${METHOD_NAME}" = "deploy" ]; then
	getApp
	def_target
	deploy
elif [ "${METHOD_NAME}" = "undeploy" ]; then
	undeploy
else
	usage $0
	exit
fi
