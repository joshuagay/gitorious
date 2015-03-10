#!/bin/sh

# Control script for the git_http daemon

PIDFILE=pids/git_http.pid
JRUBY="../jruby-1.6.0/bin/jruby"
SCRIPT="$JRUBY git_http_servlet.rb"

start() {
    echo "Starting..."
    $SCRIPT >> git_http.out 2>&1 &
}

stop() {
    kill `cat $PIDFILE`
    echo "Stopping"
}

case "$1" in
    start)
        start
        ;;
    stop)
        stop
        ;;
    restart)
        stop
        start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart}"
esac