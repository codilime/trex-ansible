#!/bin/bash
set -e

# this is in very quick and simple form for now, configuration
# will be probably expanded soon.

if [ -z "$DPDK_INTERFACES" ]; then
  echo " * Giving up. No DPDK_INTERFACES variable defined."
  exit 1
fi

INTERFACES=`for i in $DPDK_INTERFACES; do echo -n "$i "; done`

/opt/trex/dpdk_setup_ports.py -c $INTERFACES -o /etc/trex_cfg.yaml

exec "$@"
