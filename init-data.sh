#!/bin/bash
set -e

if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
	psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
		CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
		GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
		GRANT CREATE ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
	EOSQL
	echo "SETUP 1 DONE"
else
	echo "SETUP 1: No Environment variables given!"
fi

echo "POSTGRES_JIRA_DB=${POSTGRES_JIRA_DB}"
if [ -n "${POSTGRES_JIRA_DB:-}" ]; then
	DB_EXISTS=$(psql -U "$POSTGRES_USER" --dbname "$POSTGRES_DB" -tAc "SELECT 1 FROM pg_database WHERE datname='${POSTGRES_JIRA_DB}'")
	if [ "$DB_EXISTS" != "1" ]; then
		psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
			CREATE DATABASE "${POSTGRES_JIRA_DB}";
		EOSQL
		echo "SETUP 2 DONE"
	else
		echo "SETUP 2: Database ${POSTGRES_JIRA_DB} already exists."
	fi
else
	echo "SETUP 2: POSTGRES_JIRA_DB is not set!"
fi
