#!/bin/bash
#
# Common bash helper functions that makes life easier :)
#

function log {
  local readonly level="$1"
  local readonly message="$2"
  local readonly timestamp=$(date +"%Y-%m-%d %H:%M:%S")
  >&2 echo -e "${timestamp} [${level}] ${message}"
}

function log_info {
  local readonly message="$1"
  log "INFO" "$message"
}

function log_warn {
  local readonly message="$1"
  log "WARN" "$message"
}

function log_error {
  local readonly message="$1"
  log "ERROR" "$message"
}

function assert_not_empty {
  local readonly arg_name="$1"
  local readonly arg_value="$2"

  if [[ -z "$arg_value" ]]; then
    log_error "The value for '$arg_name' cannot be empty"
    exit 1
  fi
}

function assert_either_or {
  local readonly arg1_name="$1"
  local readonly arg1_value="$2"
  local readonly arg2_name="$3"
  local readonly arg2_value="$4"

  if [[ -z "$arg1_value" && -z "$arg2_value" ]]; then
    log_error "Either the value for '$arg1_name' or '$arg2_name' must be passed, both cannot be empty"
    exit 1
  fi
}

function user_exists {
  local readonly username="$1"
  id "$username" >/dev/null 2>&1
}

# S3 bucket in AWS China region as a file mirror,
# which works around network connectivity issue caused by the GFW
function http_download {
  local readonly url="$1"
  local readonly local_path="$2"
  local readonly az=$(ec2metadata --availability-zone)
  if [[ $az != cn-* ]]; then
    curl -o "$local_path" "$url" --location --silent --fail --show-error
  else
    local readonly s3_uri="s3://dl.seasungames.com/${url#https://}"
    aws s3 cp "$s3_uri" "$local_path" --region cn-north-1
  fi
}
