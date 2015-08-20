#!/bin/bash

# Fail fast, including pipelines
set -e -o pipefail

LOGSTASH_SRC_DIR='/opt/logstash'
LOGSTASH_BINARY="${LOGSTASH_SRC_DIR}/logstash/bin/logstash"

LOGSTASH_CONFIG_DIR="${LOGSTASH_SRC_DIR}/conf.d"
LOGSTASH_LOG_DIR='/var/log/logstash'
LOGSTASH_LOG_FILE="${LOGSTASH_LOG_DIR}/logstash.log"

function logstash_start_agent() {
    local binary="$LOGSTASH_BINARY"
    local config_path="$LOGSTASH_CONFIG_DIR/logstash.conf"
    local log_file="$LOGSTASH_LOG_FILE"
 
    case "$1" in
    # run just the agent
    'agent')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --
        ;;
    # test the logstash configuration
    'configtest')
        exec "$binary" \
             agent \
             --config "$config_path" \
             --log "$log_file" \
             --configtest \
             --
        ;;
    esac
}

logstash_start_agent agent
