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
	user 'root'
	cmd '/etc/lighttpd/ssl'
	code <<-EOH
	openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=IN/ST=Maharastra/L=Pune/O=SeedboxDesi/CN=#{node['fqdn']}" -keyout server.pem -out server.pem
	EOH
end

file "/etc/lighttpd/ssl/server.pem"
	mode '0600'
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
