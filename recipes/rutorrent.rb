remote_file "/tmp/rutorrent-#{node[:rutorrent][:version]}.tar.gz" do
	source node[:rutorrent][:source]
	backup false
	action :create_if_missing
end

remote_file "/tmp/plugins-#{node[:rutorrent][:version]}.tar.gz" do
        source node[:rutorrent][:plugins]
        backup false
        action :create_if_missing
end

remote_file "/tmp/rar.tar.gz" do
	source "http://www.rarlab.com/rar/rarlinux-x64-5.2.0.tar.gz"
	backup false
	action :create_if_missing
end

apt_package "mediainfo" do
	action :install
end

apt_package "libav-tools" do
	action :install
end

apt_package "zip" do
        action :install
end

apt_package "unzip" do
	action :install
end

apt_package "subversion" do
	action :install
end

bash "rutorrent data" do
	user 'root'
	cwd "/var/www/"
	code <<-EOH
	tar xf "/tmp/rutorrent-#{node[:rutorrent][:version]}.tar.gz"
	rm -rf rutorrent/plugins
	tar xf "/tmp/rar.tar.gz"
	mv "rar/rar" "/usr/bin/rar"
	mv "rar/unrar" "/usr/bin/unrar"
	rm -rf "rar/"
	cd rutorrent
	tar xf "/tmp/plugins-#{node[:rutorrent][:version]}.tar.gz"
	svn co http://svn.rutorrent.org/svn/filemanager/trunk/filemanager plugins/filemanager
	chown -R www-data:www-data "/var/www/rutorrent"
	ln -s "/usr/bin/avconv" "/usr/bin/ffmpeg"
	EOH
end

cookbook_file "/var/www/rutorrent/plugins/filemanger/conf.php"
	source filemanager.conf.php
	user 'www-data'
	group 'www-data'
	mode '0755'
end

apt_package "subversion" do
        action :remove
end
