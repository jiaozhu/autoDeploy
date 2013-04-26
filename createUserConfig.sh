#!/bin/sh

#====================================================================
# createUserConfig.sh
#
# Copyright (c) 2013, jiaozhu <gitview@gmail.com>
# All rights reserved.
# Distributed under the GNU General Public License, version 3.0.
#
#====================================================================

WL_HOME="/home/bea/bea"

if [ ! -f "${WL_HOME}/weblogic81/server/lib/weblogic.jar" ]; then
	echo 
	echo "The WebLogic Server wasn't found in directory ${WL_HOME}/server."
	echo "Please edit the createUserConfig.sh script so that the WL_HOME"
	echo "variable points to the WebLogic installation directory."
	echo 
	exit
fi

if [ -f "userconfig" ]; then
	echo
	echo "delete existing userconfig file "
	echo `rm -rf userconfig`
fi

if [ -f "userkey" ]; then
	echo
	echo "delete existing userconfig file "
	echo `rm -rf userkey`
fi


usage()
{
  echo "Need to set admin URL, username , password"
  echo "them in command line:"
  echo 'Usage: ./createUserConfig.sh [ADMIN_URL] [USERNAME] [PASSWORD]'
  echo "for example:"
  echo './createUserConfig.sh t3://127.0.0.1:7001 weblogic weblogic'
  exit 1
}


if [ ${#} = 0 ]; then
  if [ "x${ADMIN_URL}" = "x" -o "x${USERNAME}" = "x" -o "x${PASSWORD}" = "x" ]; then
    usage
  fi
elif [ ${#} = 1 ]; then
  ADMIN_URL=${1}
  if [ "x${USERNAME}" = "x" -o "x${PASSWORD}" = "x" ]; then
    usage
  fi
elif [ ${#} = 2 ]; then
  ADMIN_URL=${1}
  USERNAME=${2}
  if [ "x${PASSWORD}" = "x" ]; then
	usage
  fi
elif [ ${#} = 3 ]; then
	ADMIN_URL=${1}
	USERNAME=${2}
	PASSWORD=${3}
else
    usage
fi


create(){
	# echo `java weblogic.Deployer -version`
	. "${WL_HOME}/weblogic81/server/bin/setWLSEnv.sh"
	echo
	echo
	echo "start create user config"
	echo "y" > tmepfile
	echo
	echo `java weblogic.Admin -adminurl ${ADMIN_URL} -username ${USERNAME} -password ${PASSWORD} -userconfigfile userconfig -userkeyfile userkey -STOREUSERCONFIG < tmepfile` 
	echo
	echo `rm -rf tmepfile`
	echo "completed! please check your current directory!"
}

create