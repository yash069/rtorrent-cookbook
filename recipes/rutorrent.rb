remote_file "#{Chef::Config[:file_cache_path]}/rutorrent-#{node['rutorrent']['version']}.tar.gz" do
	source node['rutorrent']['source']
	backup false
	action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/plugins-#{node['rutorrent']['version']}.tar.gz" do
        source node['rutorrent']['plugins']
        backup false
        action :create_if_missing
end

remote_file "#{Chef::Config[:file_cache_path]}/rar.tar.gz" do
	source "http://www.rarlab.com/rar/rarlinux-x64-5.2.0.tar.gz"
	backup false
	action :create_if_missing
end

%w{mediainfo libav-tools zip unzip subversion}.each do |pkg|
  apt_package pkg do
    action :install
  end
end

bash "rutorrent data" do
	user 'root'
	cwd "/var/www/"
	code <<-EOH
	tar xf "#{Chef::Config[:file_cache_path]}/rutorrent-#{node['rutorrent']['version']}.tar.gz"
	rm -rf rutorrent/plugins
	tar xf "#{Chef::Config[:file_cache_path]}/rar.tar.gz"
	mv "rar/rar" "/usr/bin/rar"
	mv "rar/unrar" "/usr/bin/unrar"
	rm -rf "rar/"
	cd "rutorrent/"
	tar xf "#{Chef::Config[:file_cache_path]}/plugins-#{node['rutorrent']['version']}.tar.gz"
	svn co http://svn.rutorrent.org/svn/filemanager/trunk/filemanager plugins/filemanager
	chown -R www-data:www-data "/var/www/rutorrent"
	ln -s "/usr/bin/avconv" "/usr/bin/ffmpeg"
	EOH
end

cookbook_file "/var/www/rutorrent/plugins/filemanager/conf.php" do
	source "filemanager.conf.php"
	user 'www-data'
	group 'www-data'
	mode '0755'
end

apt_package "subversion" do
        action :remove
end
