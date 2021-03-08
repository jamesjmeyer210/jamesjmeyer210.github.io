#!/bin/bash

function get_pid() {
  port=$1
  netstat -nlp \
    | grep "$port" \
    | awk '{ print $7 }' \
    | sed 's|/simple-http||'
}

port=8000
printf "netstat warning: "
pid="$(get_pid $port)"
if [ "$pid" != '' ] ;
  then
    echo "PID $pid detected on port $port."
    echo "Killing process with PID $pid..."
    kill "$pid"
fi

# look for our static file server
if [ "$(whereis simple-http-server)" != "simple-http-server:\n" ] ; then
  simple-http-server --ip 127.0.0.1 \
  	--port $port \
  	--nocache 
else
  # it cannot be found so recommend installing it
	println "%s\n%s\n" \
		"Error: simple-http-server not installed." \
		"Run $ cargo install simple-http-server"
fi

printf "netstat warning: "
pid="$(get_pid $port)"
echo "PID: $pid"