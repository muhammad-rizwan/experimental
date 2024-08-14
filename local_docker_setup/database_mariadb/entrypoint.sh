#!/usr/bin/env bash
set -Eeo pipefail

# Example using the functions of the MariaDB entrypoint to customize startup to always run files in /always-initdb.d/
# https://github.com/MariaDB/mariadb-docker/issues/284
# https://github.com/docker-library/postgres/pull/496

# following is docker-entrypoint.sh from mariadb official docker image
# https://github.com/MariaDB/mariadb-docker/blob/master/docker-entrypoint.sh

source "$(which docker-entrypoint.sh)"

initialize_db() {

    # Split the DATABASES string into an array, each , represents a new row of key:valye
    IFS=',' read -ra db_rows <<< "$DATABASES"

    # Iterate over each row
    for row in "${db_rows[@]}"; do
        # Trim leading whitespace
        row=$(echo "$row" | xargs)

        # Skip rows that start with '#'
        if [[ $row == \#* ]]; then
            continue
        fi

        # Split the row into key and value
        IFS=':' read -r key value <<< "$row"

        # Trim whitespace from key and value
        dbname=$(echo "$key" | xargs)
        sourcefile=$(echo "$value" | xargs)

        if [ ! -d "$DATADIR/$dbname" ]; then
            mysql_note "Creating/Updating database [[$dbname]]   Source File: [[$sourcefile]]"
            docker_process_sql <<< "CREATE DATABASE IF NOT EXISTS $dbname;"
            xzcat "/tmp/source/$sourcefile" | docker_process_sql --database=$dbname
        fi

    done
}

docker_setup_env "$@"
docker_create_db_directories

if [ "$(id -u)" = "0" ]; then
      mysql_note "Switching to dedicated user 'mysql'"
      exec gosu mysql "${BASH_SOURCE[0]}" "$@"
fi

if [ -z "$DATABASE_ALREADY_EXISTS" ]; then
        docker_verify_minimum_env
        docker_init_database_dir "$@"

        mysql_note "Starting temporary server"
        docker_temp_server_start "$@"
        mysql_note "Temporary server started."

        docker_setup_db
        initialize_db

        mysql_note "Stopping temporary server"
        docker_temp_server_stop
        mysql_note "Temporary server stopped"

        echo
        mysql_note "MySQL init process done. Ready for start up."
        echo
else

        docker_temp_server_start "$@"
        initialize_db
        docker_temp_server_stop
fi

exec mysqld --sql_mode="NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"
