#!/bin/sh

##########################
# Setup the Firewall rules
##########################
fw_setup() {
  # First we added a new chain called 'REDSOCKS' to the 'nat' table.
  iptables -t nat -N REDSOCKS

  # Next we used "-j RETURN" rules for the networks we don’t want to use a proxy.
  while read item; do
      iptables -t nat -A REDSOCKS -d $item -j RETURN
  done < /etc/whitelist.txt

  iptables -t nat -A REDSOCKS -p tcp -j REDIRECT --to-ports 59999

  # Finally we tell iptables to use the ‘REDSOCKS’ chain for all outgoing connection in the network interface ‘$DOCKER_NET′.
  IPTABLE_ARGS=${IPTABLE_ARGS:-'-i docker0'}
  iptables -t nat -A PREROUTING $IPTABLE_ARGS -p tcp -j REDSOCKS
}

##########################
# Clear the Firewall rules
##########################
fw_clear() {
  iptables-save | grep -v REDSOCKS | iptables-restore
  #iptables -L -t nat --line-numbers
  #iptables -t nat -D PREROUTING 2
}

case "$1" in
    start)
        echo -n "Setting REDSOCKS firewall rules..."
        fw_clear
        fw_setup
        echo "done."
        ;;
    stop)
        echo -n "Cleaning REDSOCKS firewall rules..."
        fw_clear
        echo "done."
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac
exit 0

