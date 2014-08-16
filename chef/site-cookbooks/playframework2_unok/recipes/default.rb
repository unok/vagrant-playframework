#
# Cookbook Name:: playframework2_unok
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

%w{unzip}.each do |pkg|
  package pkg do
    action :install
  end
end

node['playframework2_unok']['versions'].each do |version|
  if ::Dir.exist?("#{node['playframework2_unok']['play_dir']}/play-#{version}")
    next
  end

  directory node['playframework2_unok']['play_dir'] do
    owner node['playframework2_unok']['user']
    group node['playframework2_unok']['group']
    mode "0775"
    action :create
  end

  version_data = version.split('.')
  cache_path = Chef::Config[:file_cache_path]
  zip_file_url = ''
  zip_file_name = "play-#{version}.zip"
  if version_data[0].to_i >= 2 && version_data[1].to_i >= 1
    zip_file_url = "http://downloads.typesafe.com/play/#{version}/#{zip_file_name}"
  else
    zip_file_url = "http://downloads.typesafe.com/releases/#{zip_file_name}"
  end

  execute "echo" do
    command "echo #{zip_file_url}"
  end

  remote_file "#{cache_path}/#{zip_file_name}" do
    source zip_file_url
    mode "0644"
  end

  bash "extract play zip" do
    cwd node['playframework2_unok']['play_dir']
    code <<-BASH
    unzip #{cache_path}/#{zip_file_name}
    chown -R #{node['playframework2_unok']['user']}:#{node['playframework2_unok']['group']} .
    BASH
  end


  template "#{node['playframework2_unok']['play_dir']}/play" do
    not_if do
      ::File.exist?("#{node['playframework2_unok']['play_dir']}/play")
    end
    source "play.erb"
    owner node['playframework2_unok']['user']
    group node['playframework2_unok']['group']
    mode "0775"
    variables(
        :current_version => version
    )
  end

  bash "add bash path" do
    not_if "which play"
    code <<-BASH
      echo "export PATH=#{node['playframework2_unok']['play_dir']}:$PATH" >> /etc/bashrc
    BASH
  end
end


node['playframework2_unok']['activator_versions'].each do |version|
  if ::Dir.exist?("#{node['playframework2_unok']['play_dir']}/activator-#{version}")
    next
  end

  directory node['playframework2_unok']['play_dir'] do
    owner node['playframework2_unok']['user']
    group node['playframework2_unok']['group']
    mode "0775"
    action :create
  end

  version_data = version.split('.')
  cache_path = Chef::Config[:file_cache_path]
  zip_file_url = ''
  zip_file_name = "typesafe-activator-#{version}.zip"
  zip_file_url = "http://downloads.typesafe.com/typesafe-activator/#{version}/typesafe-activator-#{version}.zip"

  execute "echo" do
    command "echo #{zip_file_url}"
  end

  remote_file "#{cache_path}/#{zip_file_name}" do
    source zip_file_url
    mode "0644"
  end

  bash "extract activator zip" do
    cwd node['playframework2_unok']['play_dir']
    code <<-BASH
    unzip #{cache_path}/#{zip_file_name}
    chown -R #{node['playframework2_unok']['user']}:#{node['playframework2_unok']['group']} .
    BASH
  end


  template "#{node['playframework2_unok']['play_dir']}/activator" do
    not_if do
      ::File.exist?("#{node['playframework2_unok']['play_dir']}/activator")
    end
    source "activator.erb"
    owner node['playframework2_unok']['user']
    group node['playframework2_unok']['group']
    mode "0775"
    variables(
        :current_version => version
    )
  end

  bash "add bash path" do
    not_if "which activator"
    code <<-BASH
      echo "export PATH=#{node['playframework2_unok']['play_dir']}:$PATH" >> /etc/bashrc
    BASH
  end
end

