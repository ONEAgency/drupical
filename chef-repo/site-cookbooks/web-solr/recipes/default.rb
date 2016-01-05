#
# Cookbook Name:: solr
# Recipe:: default
#

node.override['jetty']['version'] = '8.1.17.v20150415'
node.override['jetty']['link'] = 'http://eclipse.org/downloads/download.php?file=/jetty/8.1.17.v20150415/dist/jetty-distribution-8.1.17.v20150415.tar.gz&r=1'
node.override['jetty']['checksum'] = '8d69614dcc89c50ffc4b4f97f8013b425b12515b41a03396af1a7ee8d98692ba' # SHA256

node.override['solr']["version"] = node['config']['solr']['solr_version']
node.override['solr']["checksum"] = node['config']['solr']['solr_checksums'][node['config']['solr']['solr_version']]
node.override['solr']["link"] = node['config']['solr']['solr_links'][node['config']['solr']['solr_version']]

if /^(?:1\.4\.(?:0|1){1}|3\.[0-9]{1,}\.[0-9]{1,})/.match(node['solr']['version'])
  node.default['solr']['download'] = "#{node['solr']['directory']}/apache-solr-#{node['solr']['version']}.tgz"
  node.default['solr']['extracted'] = "#{node['solr']['directory']}/apache-solr-#{node['solr']['version']}"
  node.default['solr']['war'] = "apache-solr-#{node['solr']['version']}.war"
elsif /^4\.[0-9]{1,}\.[0-9]{1,}/.match(node['solr']['version'])
  node.default['solr']['download'] = "#{node['solr']['directory']}/solr-#{node['solr']['version']}.tgz"
  node.default['solr']['extracted'] = "#{node['solr']['directory']}/solr-#{node['solr']['version']}"
  node.default['solr']['war'] = "solr-#{node['solr']['version']}.war"
else
  # throw here!
end

#include_recipe "system-java"
include_recipe "hipsnip-solr"

if /^(?:1\.4\.(?:0|1){1}|3\.[0-9]{1,}\.[0-9]{1,})/.match(node['config']['solr']['solr_version'])
  solr_name = "apache-solr-#{node['config']['solr']['solr_version']}"
elsif /^4\.[0-9]{1,}\.[0-9]{1,}/.match(node['config']['solr']['solr_version'])
  solr_name = "solr-#{node['config']['solr']['solr_version']}"
else
  solr_name = ""
end

bash "configure-solr" do

  if (solr_name.length > 0)
    code <<-EOH
      (usermod -a -G jetty vagrant)
      (chown -R vagrant:vagrant /usr/local/src/#{solr_name})
      (rm -rf /usr/share/solr/*)
      (cp -R /usr/local/src/#{solr_name}/example/multicore/* /usr/share/solr/)
      (chmod -R 775 /usr/share/solr/)
      (chown -R jetty.jetty /usr/share/solr/)
    EOH
  end

end

vhosts = node['config']['vhosts']
vhosts.each do |key, vhost|

  server_name = vhost.fetch('server_name')

  # link "/usr/share/solr/#{server_name}" do
  #   to "/home/vagrant/drupical/build/config/solr"
  #   not_if { File.symlink?("/usr/share/solr/#{server_name}") }
  # end

  ruby_block "adding-multicore-#{server_name}" do
    block do
      fe = Chef::Util::FileEdit.new("/usr/share/solr/solr.xml")
      fe.insert_line_after_match(/<cores/, "<core name=\"#{server_name}\" instanceDir=\"#{server_name}\" />")
      fe.write_file
    end
  end

end
