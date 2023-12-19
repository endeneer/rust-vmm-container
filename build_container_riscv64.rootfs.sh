#!/usr/bin/env bash
set -ex

apt-get -y update
apt-get -y upgrade
apt-get -y install systemd init ifupdown busybox udev
