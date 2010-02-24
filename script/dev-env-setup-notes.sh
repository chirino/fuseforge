#!/bin/bash
# ===========================================================================
# Copyright (C) 2009, Progress Software Corporation and/or its 
# subsidiaries or affiliates.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===========================================================================
# @author Hiram Chirino
#
# These are my notes on the commands that I need to run to setup a dev env for
# this rails app.  It's highly specific to OS-X and a bit to my machine.
#

#
# MySQL Port Forwarding Setup
# ---------------------------
#
# I setup SSH port forwarding to a remote MySQL box instead of running MySQL locally:
#    . ~/sandbox/fuse/fuseinfra/bin/settings.sh --host vmware.fusesourcedev.com
#    ssh-command -N -f -L3306:127.0.0.1:3306

# Single Sign On Setup
# --------------------
#
# My local enviorment runs against the SSO instance at: http://fusesourcedev.com/crowd
# For the SSO cookie to propage to the local rails app.. you have to access it via fusesourcedev.com
# subdomain therefore add a line like this to /etc/hosts:
#
#    127.0.0.1   localhost localhost.fusesourcedev.com
#
# Then when you start rails via ./script/server access the app via
# http://localhost.fusesourcedev.com:3000/
#
# The SSO instance only accepts clients from white listed IP addresses. If you can't
# login and see something this in the rails logs:
#
#    HTTP post (193.4ms):  http://fusesourcedev.com/crowd/services/SecurityServer
#    Crowd Error: Client host is invalid: 71.67.123.243 / 71.67.123.243
#
# Then you need to login to http://fusesourcedev.com/crowd and whitelist that IP


# Gems Setup
# --------------------
#
# Use the following to get gems up to 1.3.4 :
#
#    gem install rubygems-update
#    update_rubygems

# To remove all previously installed gems:
#
#    rm -Rf ~/.gem /Library/Ruby/Gems/1.8/*  /System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8*

# Uncomment to disable installing the doco... makes for a faster install
#
#     GEMP_OPTS="--no-rdoc --no-ri"

function install-gem {
    gem=$1
    version=$2
    gem install ${gem} --version ${version} $GEMP_OPTS  
}

install-gem rake 0.8.3
install-gem rails 2.2.2
install-gem mongrel 1.1.5
install-gem mongrel_cluster 1.0.5
install-gem rspec 1.2.6
install-gem haml 2.0.9
install-gem friendly_id 2.1.1
install-gem paperclip 2.1.2
install-gem searchlogic 1.6.6
install-gem composite_primary_keys 2.2.2
install-gem net-ssh 2.0.11
install-gem soap4r 1.5.8

gem install ~/sandbox/fuse/fuseinfra/images/common/tmp/rubycrowd-0.0.10.gem $GEMP_OPTS 

# This gem install works with the mysql-5.1.37-osx10.5-x86_64 release:
#    http://dev.mysql.com/get/Downloads/MySQL-5.1/mysql-5.1.37-osx10.5-x86_64.tar.gz/from/http://mysql.mirror.redwire.net/
#
env ARCHFLAGS="-arch x86_64" gem install mysql --version 2.8.1 $GEMP_OPTS -- \
  --with-mysql-dir=/usr/local/mysql \
  --with-mysql-lib=/usr/local/mysql/lib \
  --with-mysql-include=/usr/local/mysql/include

