#
# Cookbook:: node
# Recipe:: default
#
# Copyright:: 2019, The Authors, All Rights Reserved.

apt_update "update_sources" do
  action :update
end

package 'nginx'
service 'nginx' do
  action [:enable, :start]
end

include_recipe 'apt'
include_recipe 'nodejs'
nodejs_npm 'pm2'

 package 'nodejs'
 service 'nodejs' do
   action [:enable, :start]
 end

 template '/etc/nginx/sites-available/proxy.conf' do
   source 'proxy.conf.erb'
   variables proxy_port: 3000
   notifies :restart, 'service[nginx]'
 end


link '/etc/nginx/sites-enabled/proxy.conf' do
  to '/etc/nginx/sites-available/proxy.conf'
end

 link '/etc/nginx/sites-enabled/default' do
   action :delete
   notifies :restart, "service[nginx]"
 end
