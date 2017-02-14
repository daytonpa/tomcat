#
# Cookbook Name:: tomcat
# Spec:: default
# Author:: Patrick Dayton  daytonpa@gmail.com
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'tomcat::default' do
  { 'ubuntu' => '16.04',
    'centos' => '7.2.1511'
  }.each do |os, v|
    context "When all attributes are default, on #{os.capitalize} #{v}" do
      let(:chef_run) do
        ChefSpec::SoloRunner.new(platform: os, version: v).converge(described_recipe)
      end

      it 'converges successfully' do
        expect { chef_run }.to_not raise_error
      end

      it "includes the 'user', 'install_systemd', and 'install_tomcat8' recipes" do
        %w(user install_systemd install_tomcat8).each do |recipe|
          expect(chef_run).to include_recipe("tomcat::#{recipe}")
        end
      end
    end
  end
end
