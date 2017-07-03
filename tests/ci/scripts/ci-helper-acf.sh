#!/bin/bash
# WORK_DIR and BUILD_DIR must be set!

CONTROL_SCRIPT='coldfusion10/cfusion/bin/coldfusion'

MY_DIR=`dirname $0`
source $MY_DIR/ci-helper-base.sh $1 $2

case $1 in
	install)
		mv mxunit* coldfusion10/cfusion/wwwroot/mxunit

		echo "Fixing ACF install directory..."
		grep -rl "/opt/coldfusion10/" . | xargs -n 1 sed -i "s#/opt/coldfusion10/#$WORK_DIR/coldfusion10/#g"

		ln -s $BUILD_DIR coldfusion10/cfusion/wwwroot/$2

		sed -i "s/8500/$SERVER_PORT/g" coldfusion10/cfusion/runtime/conf/server.xml
		;;
	start|stop)
		;;
	*)
		echo "Usage: $0 {install|start|stop}"
		exit 1
		;;
esac

exit 0