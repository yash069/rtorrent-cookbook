apt_package "lighttpd" do
	action :install
end

service "lighttpd" do
	provider Chef::Provider::Service::Upstart
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

cookbook_file "/var/www/index.html" do
	source "index.html"
	owner 'www-data'
	group 'www-data'
	mode '0644'
end

cookbook_file "/etc/lighttpd/conf-available/15-fastcgi-php.conf" do
	source "15-fastcgi-php.conf"
	owner 'root'
	group 'root'
	mode '0644'
end

directory "/etc/lighttpd/ssl"
	action :create
	owner 'root'
	group 'root'
	mode '0755'
end

bash "genrate_certi" do

end

template "/etc/lighttpd/lighttpd.conf" do
	source "lighttpd.conf.erb"
	owner 'root'
	group 'root'
	mode '0644'
	notifies :restart, resources(:service => "lighttpd"), :delayed
end

lighttpd_module "auth"
lighttpd_module "fastcgi"
lighttpd_module "fastcgi-php"
