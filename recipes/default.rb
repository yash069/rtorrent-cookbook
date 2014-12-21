#
# Cookbook Name:: rtorrent
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rtorrent::apt"
include_recipe "rtorrent::php"
include_recipe "rtorrent::lighttpd"
include_recipe "rtorrent::rutorrent"
include_recipe "rtorrent::vsftpd"

cookbook_file "/tmp/#{node['rtorrent']['libtorrent']['debfile']}" do
	source node['rtorrent']['libtorrent']['debfile']
	mode '0644'
end

dpkg_package "libtorrent" do
	source "/tmp/#{node['rtorrent']['libtorrent']['debfile']}"
	action :install
end

cookbook_file "/tmp/#{node['rtorrent']['debfile']}" do
        source node['rtorrent']['debfile']
        mode '0644'
end

dpkg_package "rtorrent" do
        source "/tmp/#{node['rtorrent']['debfile']}"
        action :install
end

cookbook_file "/tmp/#{node['rtorrent']['xmlrpc']['debfile']}" do                    
        source node['rtorrent']['xmlrpc']['debfile']          
        mode '0644'
end

dpkg_package "xmlrpc-c" do
        source "/tmp/#{node['rtorrent']['xmlrpc']['debfile']}"
        action :install
end

bash "ldconfig" do
	user "root"
	code "ldconfig"
end
