default['tomcat']['user'] = 'tomcat'
default['tomcat']['group'] = 'tomcat'
default['tomcat']['owner'] = 'tomcat'
default['tomcat']['home_dir'] = '/opt/tomcat'
default['tomcat']['port'] = 8080

default['tomcat']['template_srcfile'] = 'tomcat.service.erb'
default['tomcat']['users-file'] = 'tomcat-users.xml'

default['tomcat']['java_v'] = 'java-1.7.0-openjdk-devel'
default['tomcat']['ap-tom-v'] = ''