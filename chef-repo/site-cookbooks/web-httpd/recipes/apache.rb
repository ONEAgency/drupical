#
# Cookbook Name:: web
# Recipe:: apache
#

#
include_recipe 'web-httpd::apache_repo'

#
include_recipe 'apache2'

#
service 'apache2' do
  service_name 'apache2'
  supports status: true, restart: true, reload: true
  action [:enable, :start]
end


#
execute "Enabling necessary apache2 modules" do
  command 'a2enmod actions'
  action :run
end

#
execute "Enabling necessary apache2 modules" do
  command 'a2enmod alias'
  action :run
end

#
execute "Enabling necessary apache2 modules" do
  command 'a2enmod rewrite'
  action :run
end



#
apache_module "ssl" do
  enable true
end


directory "/etc/apache2/ssl" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end
