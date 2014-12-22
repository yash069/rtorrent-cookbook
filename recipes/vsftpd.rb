apt_package "vsftpd" do
	action :install
end

service "vsftpd" do
	provider Chef::Provider::Service::Upstart
	supports :reload => true, :restart => true, :status => true
	action [ :enable, :start ]
end

bash "get_public_ip" do
	user 'root'
	code <<-EOH
	curl "http://whatismyip.akamai.com/" > "/tmp/myip"
	EOH
end

ruby_block "set_attribute" do
  block do
    node.normal['public_ip'] = `head -1 /tmp/myip`
  end
  action :create
end

template "/etc/vsftpd.conf" do
	source "vsftpd.conf.erb"
	owner 'root'
	group 'root'
	mode '0644'

	notifies :restart, "service[vsftpd]", :delayed
end
