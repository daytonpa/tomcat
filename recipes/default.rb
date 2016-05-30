#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# yum install java-1.7.0-openjdk-devel
package node['tomcat']['java_v']

include_recipe 'tomcat::user'
include_recipe 'tomcat::install_tomcat8'
include_recipe 'tomcat::install_systemd'