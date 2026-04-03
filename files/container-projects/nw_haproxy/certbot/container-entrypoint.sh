#!/bin/sh
# We are PID 1 so lets behave responsibly
# - set up TERM signal handlers and take care of all processes we started
# - run programs in the background because shell does not process signals 
#   if a foreground process is running 
# - check in the main loop if we need to exit

_set_dt() {
	DT="$(date '+%Y-%m-%d_%H%M')"
}

_term() {

  TERM_RECEIVED="Y"
  date
  
  echo "ENTRYPOINT: starting process shutdown" 
  ps a
  killall -TERM sleep 2>/dev/null
  killall -TERM certbot 2>/dev/null
  
  echo "ENTRYPOINT: signals sent, waiting for subprocesses to exit"
  wait
  
  echo "ENTRYPOINT: all processes have finished"
}

trap _term HUP INT QUIT TERM

###############################################################################

echo 
echo "ENTRYPOINT: starting up"

TERM_RECEIVED="N"

if [ ! -f /bin/sleep ];
then
    echo "ENTRYPOINT: error, sleep command not found, exiting"
    exit 1;
fi;

while true;
do
  _set_dt

	if [ "${TERM_RECEIVED}" = "Y" ]; then
	  echo "ENTRYPOINT: termination request received in main loop at ${DT}, exiting"
	  exit 0
	fi
	
  { certbot certonly --standalone \
    --agree-tos --non-interactive \
    --email "${CERTBOT_EMAIL}" \
    --domains "${CERTBOT_DOMAIN}" || exit 1; } &
  wait $!
    
  { sleep 24h || exit 1; } &
  wait $!
done;

