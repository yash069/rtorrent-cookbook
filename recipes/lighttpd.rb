apt_package "lighttpd" do
	action :install
end

service "lighttpd" do
	provider Chef::Provider::Service::Upstart
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

cookbook_file "/var/www/index.html"
	source "index.html"
	owner 'www-data'
	group 'www-data'
	mode '0644'
end
