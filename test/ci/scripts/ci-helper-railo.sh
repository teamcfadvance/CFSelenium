#!/bin/bash
case $1 in
	start)
		CONTROL_SCRIPT='railo/start'
		;;
	stop)
		CONTROL_SCRIPT='railo/stop'
		;;
esac

MY_DIR=`dirname $0`
source $MY_DIR/ci-helper-base.sh $1 $2

case $1 in
	install)
		mv railo-express* railo
		mv mxunit* railo/webapps/www/mxunit

		ln -s $BUILD_DIR railo/webapps/www/$2
		
		chmod a+x railo/start
		chmod a+x railo/stop

		sed -i "s/jetty.port=8888/jetty.port=$SERVER_PORT/g" railo/start
		sed -i "s/STOP.PORT=8887/STOP.PORT=$STOP_PORT/g" railo/start
		sed -i "s/STOP.PORT=8887/STOP.PORT=$STOP_PORT/g" railo/stop
		;;
	start|stop)
		;;
	*)
		echo "Usage: $0 {install|start|stop}"
		exit 1
		;;
esac

exit 0