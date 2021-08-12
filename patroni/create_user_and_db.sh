#!/usr/bin/env sh

echo "$@"

# if POSTGRES_USER and
if [ ! -z "${POSTGRES_USER}" ] && [ ! -z "${POSTGRES_PASSWORD}" ]; then

echo "creating new role ${POSTGRES_USER}"

echo "SELECT 'CREATE ROLE ${POSTGRES_USER} "\
 "WITH PASSWORD ''${POSTGRES_PASSWORD}'' NOSUPERUSER CREATEDB NOCREATEROLE INHERIT LOGIN;' "\
 "WHERE NOT EXISTS (SELECT FROM pg_user WHERE usename = '${POSTGRES_USER}')\gexec" | psql

fi


# if POSTGRES_DB and POSTGRES_USER then create database
if [ ! -z "${POSTGRES_DB}" ] && [ ! -z "${POSTGRES_USER}" ]; then

echo "creating new database ${POSTGRES_DB} owner ${CREATE_DB_OWNER}"

echo "SELECT 'CREATE DATABASE ${POSTGRES_DB} OWNER ${POSTGRES_USER}' "\
 "WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = '${POSTGRES_USER}')\gexec" |
 psql

fi

