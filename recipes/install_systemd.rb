template '/etc/systemd/system/tomcat.service' do
	source node['tomcat']['template_srcfile']
	notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

execute 'systemctl daemon-reload' do
	action :nothing
end

# execute 'sudo systemctl start tomcat'
# execute 'sudo systemctl enable tomcat'
service node['tomcat']['user'] do
	action [:start, :enable]
end

# vi is an editor
# execute "vi #{node['tomcat']['home_dir']}/conf/tomcat-users.xml"
file "#{node['tomcat']['home_dir']}/conf/#{node['tomcat']['users-file']}" do
	user node['tomcat']['user']
	owner node['tomcat']['owner']
	mode '0744'
	action :create
end

execute 'systemctl restart tomcat'