#
# Cookbook Name:: tomcat
# Spec:: install_systemd
# Author:: Patrick Dayton  daytonpa@gmail.com
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'tomcat::install_systemd' do
  { 'ubuntu' => '16.04',
    'centos' => '7.2.1511'
  }.each do |os, v|
    context "When all attributes are default, on #{os.capitalize} #{v}" do

      let(:user) { 'tomcat' }
      let(:template) { chef_run.template('/etc/systemd/system/tomcat.service') }
      let(:users_file) { '/opt/tomcat/conf/tomcat-users.xml' }

      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: os, version: v).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'creates the tomcat.service file from template, and notifies the execute resource' do
        expect(chef_run).to create_template('/etc/systemd/system/tomcat.service')
      end

      it "does not use the execute 'systemctl daemon-reload' resource, unless notified" do
        expect(chef_run).to_not run_execute('systemctl daemon-reload')
        expect(template).to notify('execute[systemctl daemon-reload]').immediately
      end

      it 'starts and enables the Tomcat service' do
        expect(chef_run).to start_service('tomcat')
        expect(chef_run).to enable_service('tomcat')
      end

      it 'creates the tomcat-users.xml file' do
        expect(chef_run).to create_file(users_file).with(
          user: user,
          owner: user,
          mode: '0744'
        )
      end

      it 'restarts the tomcat service when completed' do
        expect(chef_run).to run_execute('systemctl restart tomcat')
      end
    end
  end
end
