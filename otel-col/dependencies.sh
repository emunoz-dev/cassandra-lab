#!/usr/bin/env bash

apt update
apt -y install wget
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v0.122.1/otelcol_0.122.1_linux_amd64.deb
dpkg -i otelcol_0.122.1_linux_amd64.deb

