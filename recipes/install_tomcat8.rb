# wget http://mirror.sdunix.com/apache/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz
remote_file 'apache-tomcat-8.0.32.tar.gz' do
	source 'http://mirror.23media.de/apache/tomcat/tomcat-8/v8.0.32/bin/apache-tomcat-8.0.32.tar.gz'
	user node['tomcat']['user']
	group node['tomcat']['user']
	action :create_if_missing
end

directory node['tomcat']['home_dir'] do
	user node['tomcat']['user']
	group node['tomcat']['group']
	notifies :run, "execute[tar xvf apache-tomcat-8*tar.gz -C #{node['tomcat']['home_dir']} --strip-components=1]", :immediately
end

# x 	extract files from archive
# v 	verbosely list files which are processed
# f 	following file is the archive name file
execute "tar xvf apache-tomcat-8*tar.gz -C #{node['tomcat']['home_dir']} --strip-components=1" do
	action :nothing
end

# NDS
directory "#{node['tomcat']['home_dir']}/conf" do
	mode '0070'
end

#execute "chgrp -R tomcat #{node['tomcat']['home_dir']}/conf/*"
#execute "chmod g+r #{node['tomcat']['home_dir']}/conf/*"
directory "#{node['tomcat']['home_dir']}/conf/*" do
	group node['tomcat']['group']
	owner node['tomcat']['owner']
	mode '0444'
	recursive true
end

# execute 'sudo chown -R tomcat webapps/ work/ temp/ logs/'
%w{ webapps work temp logs }.each do |dir|
	directory "/#{dir}/" do
   		user node['tomcat']['user']
   		path node['tomcat']['home_dir']
		action :create
	end
end

