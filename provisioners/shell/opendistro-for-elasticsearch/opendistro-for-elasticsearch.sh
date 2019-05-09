#!/bin/bash
set -x

source "$BASH_HELPERS"

function install {
    # for Open Distro for Elasticsearch 
    # see https://opendistro.github.io/for-elasticsearch-docs/docs/install/deb/
    wget -qO - https://d3g5vo6xdbdb9a.cloudfront.net/GPG-KEY-opendistroforelasticsearch | sudo apt-key add -
    echo "deb https://d3g5vo6xdbdb9a.cloudfront.net/apt stable main" | sudo tee -a   /etc/apt/sources.list.d/opendistroforelasticsearch.list

    local readonly download_url="https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-oss-6.7.1.deb"
    local readonly download_path="/tmp/$(basename "$download_url")"
    http_download "$download_url" "$download_path"
    sudo dpkg  -i "$download_path"
    sudo apt-get update -y

    echo "Installing opendistroforelasticsearch"
    sudo apt-get install -y opendistroforelasticsearch
    sudo systemctl start  elasticsearch.service
    sudo systemctl status  elasticsearch.service

    echo "Installing kibana"
    sudo apt-get install -y opendistroforelasticsearch-kibana
    sudo systemctl start kibana.service
    sudo systemctl status kibana.service
}

install