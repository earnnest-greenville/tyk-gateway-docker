#!/bin/bash

TYKCONF=/opt/tyk-gateway/tyk.conf

export TYK_GW_LISTENPORT="$PORT"
export TYK_GW_SECRET="$SECRET"
export TYK_GW_STORAGE_HOST="$REDISHOST"
export TYK_GW_STORAGE_PORT="$RPORT"
export TYK_GW_STORAGE_PASSWORD="$REDISPW"
export TYK_GW_SLAVEOPTIONS_RPCKEY="$ORGID"
export TYK_GW_SLAVEOPTIONS_APIKEY="$APIKEY"

# for backwards compatibility if TYKSECRET is not empty, then set TYK_GW_SECRET to TYKSECRET
if [[ -n "${TYKSECRET}" ]]; then
  export TYK_GW_SECRET="${TYKSECRET}"
fi

# If no TYK_GW_SECRET env set, we will attempt to set it from the "secret" value in tyk.conf
if [[ -z "${TYK_GW_SECRET}" ]]; then
  echo "**************************************************************************************************************"
  echo "*                                           WARNING                                                          *"
  echo "**               USING GATEWAY SECRET IN TYK.CONF BECAUSE NO ENV VARIABLE SET                               **"
  echo "*                                REFER TO IMAGE README FOR MORE INFO                                         *"
  echo "**************************************************************************************************************"
  echo ""
  export TYK_GW_SECRET=$(cat $TYKCONF | jq -r .secret)
fi

# If no secret found in tyk.conf, will use default license
if [[ -z "${TYK_GW_SECRET}" ]]; then
  export TYK_GW_SECRET=352d20ee67be67f6340b4c0605b044b7
fi

cd /opt/tyk-gateway/
./tyk --conf=${TYKCONF}