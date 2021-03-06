define :lighttpd_module, :enable => true do
	module_command = (params[:enable]) ? "lighttpd-enable-mod" : "lighttpd-disable-mod"
	bash "run_lighty_mod" do
		user "root"
		code <<-EOH
			#{module_command} #{params[:name]}
		EOH
		returns [0, 2]
		notifies :restart, "service[lighttpd]", :delayed
	end
end
