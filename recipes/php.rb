node[:php][:packages].each do |package_name|
	apt_package package_name do
		action :install
	end
end

service "php5-fpm" do
	provider Chef::Provider::Service::Upstart
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

cookbook_file "/etc/php5/fpm/php.ini" do
	source "php.ini"
	owner 'root'
	group 'root'
	mode '0644'
	notifies :reload, "service[php5-fpm]", :immediately
end
