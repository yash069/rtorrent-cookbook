apt_package "vsftpd" do
	action :install
end

service "vsftpd" do
	provider Chef::Provider::Service::Upstart
	supports :reload => true, :restart => true, :status => true
	action [ :enable, :start ]
end

template "/etc/vsftpd.conf" do
	source "vsftpd.conf.erb"
	owner 'root'
	group 'root'
	mode '0644'

	notifies :restart, "service[vsftpd]", :delayed
end
