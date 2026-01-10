#!/bin/bash
# Usage: ./wait_nodes.sh host1 host2 host3

set -u

TOTAL_TIMEOUT=300   # 5 minutes
PING_INTERVAL=2     # seconds between retries

if (( $# == 0 )); then
  echo "Usage: $0 host1 host2 ..."
  exit 2
fi

start=$SECONDS
pending=("$@")

while (( ${#pending[@]} > 0 )); do
  if (( SECONDS - start >= TOTAL_TIMEOUT )); then
    echo "Timeout reached (${TOTAL_TIMEOUT}s). Unreachable hosts:"
    printf '  %s\n' "${pending[@]}"
    exit 1
  fi

  next_pending=()
  for host in "${pending[@]}"; do
    if ping -c 1 -W 1 "$host" &>/dev/null; then
      echo "Host reachable: $host"
    else
      next_pending+=("$host")
    fi
  done

  pending=("${next_pending[@]}")
  sleep "$PING_INTERVAL"
done

echo "All hosts reachable within ${TOTAL_TIMEOUT}s."
exit 0
