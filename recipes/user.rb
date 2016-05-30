# sudo groupadd tomcat
group node['tomcat']['group']

# sudo useradd -M -s /bin/nologin -g tomcat -d /opt/tomcat tomcat
user node['tomcat']['user'] do
	manage_home false # -M
	shell '/bin/nologin' # -s
	group node['tomcat']['group'] # -g
	home node['tomcat']['home_dir'] # -d
end