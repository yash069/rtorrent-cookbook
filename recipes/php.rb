node[:php][:packages].each |package_name| do
	apt_package package_name do
		action :install
	end
end

service "php5-fpm" do

end
