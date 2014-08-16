#
# Cookbook Name:: 
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#


bash 'timezone change' do
  user 'root'
  code <<-EOF
    rm -f /etc/localtime
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOF
end

bash 'yum update' do
  user 'root'
  code <<-EOF
  yum update -y
  EOF
end

bash 'install webtatic.repo' do
  user 'root'
  code <<-EOF
    rpm -vhi http://mirror.webtatic.com/yum/el6/latest.rpm
  EOF
  not_if { ::File.exists?('/etc/yum.repos.d/webtatic.repo') }
end

%w{vim-enhanced screen autoconf automake readline readline-devel git gcc-c++ flex bison  kernel-devel  zlib zlib-devel openssl-devel make bzip2 unzip libssh2 libssh2-devel }.each do |pkg|
  package pkg do
    action :upgrade
  end
end

bash 'remove iptables' do
  user 'root'
  code <<-EOF
    chkconfig iptables off
    service iptables stop
  EOF
end

