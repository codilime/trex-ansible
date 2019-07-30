#!/bin/bash
set -e

if [ ! -f /etc/trex_cfg.yaml ]; then

  if [ -z "$DPDK_INTERFACES" ]; then
    echo " * Giving up. No DPDK_INTERFACES variable defined. Cannot generate configuration."
    exit 1
  fi

  echo " * No /etc/trex_cfg.yaml present, generating configuration..."
  INTERFACES=`for i in $DPDK_INTERFACES; do echo -n "$i "; done`
  /opt/trex/dpdk_setup_ports.py -c $INTERFACES -o /etc/trex_cfg.yaml

fi

exec "$@"
