#!/usr/bin/env sh

if [ -z "$CREATE_DB_IF_NOT_EXISTS" ]; then
  echo "CREATE_DB_IF_NOT_EXISTS variable is not set, skip creating database"
  exit 0
fi

if [ -z "$CREATE_DB_OWNER" ]; then
  echo "CREATE_DB_OWNER variable is not set, skip creating database"
  exit 0
fi

DBNAME=${CREATE_DB_IF_NOT_EXISTS}
DBOWNER=${CREATE_DB_OWNER}

echo "creating new database ${CREATE_DB_IF_NOT_EXISTS} owner ${CREATE_DB_OWNER}"

echo "SELECT 'CREATE DATABASE ${DBNAME} OWNER ${DBOWNER}' "\
 "WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${DBNAME}')\gexec" |
 psql
