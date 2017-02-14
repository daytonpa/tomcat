#
# Cookbook Name:: tomcat
# Spec:: install_tomcat8
# Author:: Patrick Dayton  daytonpa@gmail.com
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'tomcat::install_tomcat8' do
  { 'ubuntu' => '16.04',
    'centos' => '7.2.1511'
  }.each do |os, v|
    context "When all attributes are default, on #{os.capitalize} #{v}" do
      let(:user) { 'tomcat' }
      let(:group) { 'tomcat' }
      let(:home_dir) { '/opt/tomcat' }
      let(:home_dir_resource) { chef_run.directory(home_dir) }
      let(:execute_tar_file) { chef_run.execute('tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1') }

      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: os, version: v) do |node|
          # Some default attributes
          node.normal['tomcat']['user'] = user
          node.normal['tomcat']['group'] = group
          node.normal['tomcat']['home_dir'] = home_dir
        end.converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it 'downloads apache-tomcat-8 tarfile' do
        expect(chef_run).to create_remote_file_if_missing('apache-tomcat-8.0.32.tar.gz').with(
          user: 'tomcat',
          group: 'tomcat'
        )
      end

      it 'creates the Tomcat home directory, and notifies the execute[tar xvf apache-tomcat-8] resource' do
        expect(chef_run).to create_directory(home_dir).with(
          user: user,
          group: group
        )
        expect(home_dir_resource).to notify('execute[tar xvf apache-tomcat-8*tar.gz -C /opt/tomcat --strip-components=1]').to(:run).immediately
      end

      it 'does not execute the apache-tomcat-8 tarfile, unless otherwise specified' do
        expect(chef_run).to_not run_execute(execute_tar_file)
      end

      it 'create the Tomcat configuration directory' do
        expect(chef_run).to create_directory("#{home_dir}/conf").with(
          mode: '0070'
        )
      end

      it 'changes the user and group permissions for the configuration directories' do
        expect(chef_run).to create_directory("#{home_dir}/conf/*").with(
          owner: user,
          group: group,
          mode: '0444'
        )
      end

      it 'creates the /webapps, /work, /temp, and /logs directories' do
        %w(webapps work temp logs).each do |dir|
          expect(chef_run).to create_directory("/#{dir}/").with(
            user: user,
            path: home_dir
          )
        end
      end
    end
  end
end
