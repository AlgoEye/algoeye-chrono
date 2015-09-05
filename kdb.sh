#!/bin/sh
export ROOTDIR=$( cd "$( dirname "$0" )" && pwd )
export QHOME=${ROOTDIR}/q
export TORQHOME=${ROOTDIR}/torq
export KDBCONFIG=${ROOTDIR}/config
export KDBCODE=${TORQHOME}/code
export KDBLOG=${ROOTDIR}/log
export KDBHTML=${TORQHOME}/html
export KDBLIB=${TORQHOME}/lib
export KDBHDB=${ROOTDIR}/hdb
export KDBBASEPORT=6000
export KDBSTACKID="-stackid ${KDBBASEPORT}"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$KDBLIB/l32
export PATH=$ROOTDIR:$QHOME/l32:/bin:/sbin:/usr/sbin:/bin:/usr/bin
Q=$QHOME/l32/q
PROCNAME=$2
DEFAULTPARAMS="-proctype $2 -procname ${PROCNAME}1 $KDBSTACKID -localtime -U config/passwords/default.txt"
APPLOG=$KDBLOG/$PROCNAME.log
PIDFILE=/tmp/kdb.$KDBBASEPORT.$PROCNAME.pid

#exec q "$@" $KDBSTACKID -localtime
#exec q "$@" $KDBSTACKID -U config/passwords/accesslist.txt -localtime

stop()
{
    if ps -p `cat $PIDFILE` >/dev/null 2>&1; then
       echo "Stopping $PROCNAME with pid: `cat $PIDFILE`\n" >> $APPLOG;
       if ! kill `cat $PIDFILE`; then
          echo "Terminating $PROCNAME with pid: `cat $PIDFILE`\n" >> $APPLOG;
          kill -9 `cat $PIDFILE`
       fi
    fi
}

restart()
{
    stop
    echo "Starting $PROCNAME with pid: $$\n" >> $APPLOG;
    cd $ROOTDIR
    echo $$ > $PIDFILE;
    case $PROCNAME in
        discovery)
            exec $Q torq/torq.q -load torq/code/processes/discovery.q $DEFAULTPARAMS 1>>$APPLOG 2>&1
        ;;
        tickerplant)
            exec $Q tick/tickerplant.q algoeye ./journal $DEFAULTPARAMS 1>>$APPLOG 2>&1
        ;;
        rdb)
            exec $Q torq/torq.q -load torq/code/processes/rdb.q -g 1 -T 30 $DEFAULTPARAMS 1>>$APPLOG 2>&1
        ;;
        hdb)
            exec $Q torq/torq.q -load $KDBHDB -g 1 -T 60 -w 4000 $DEFAULTPARAMS 1>>$APPLOG 2>&1
        ;;
        wdb)
            exec $Q torq/torq.q -load torq/code/processes/wdb.q $DEFAULTPARAMS 1>>$APPLOG 2>&1
        ;;
        monitor)
            exec $Q torq/torq.q -load torq/code/processes/monitor.q $DEFAULTPARAMS 1>>$APPLOG 2>&1
        ;;
        *)
        echo "unknown process name" ;;
    esac

}

case $1 in
     start)
       restart
       ;;
     stop)
       stop
       ;;
     *)
       echo "usage: algoeye.sh {start|stop}" ;;
esac

