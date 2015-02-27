#
# Cookbook Name:: solr
# Recipe:: default
#

Chef::Log.info('Starting drupical::solr')

node.override['java']['jdk_version'] = '7'
node.override['java']['install_flavor'] = 'oracle'
node.override['java']['oracle']['accept_oracle_download_terms'] = true
node.override['java']['jdk']['7']['x86_64']['url'] = "http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/jdk-7u76-linux-x64.tar.gz"

node.override['jetty']['port'] = 8390
node.override['jetty']['version'] = '9.2.9.v20150224'
node.override['jetty']['link'] = 'http://download.eclipse.org/jetty/stable-9/dist/jetty-distribution-9.2.9.v20150224.tar.gz'
node.override['jetty']['checksum'] = 'd565cb0abe9c265f573a16c5dfd9ae36e769c908'

node.override['solr']["version"] = node['config']['solr']['solr_version']
node.override['solr']["checksum"] = node['config']['solr']['solr_checksum']

include_recipe "java"

include_recipe "hipsnip-jetty"

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

  link "/usr/share/solr/#{server_name}" do
    to "/home/vagrant/drupical/build/config/solr"
    not_if { File.symlink?("/usr/share/solr/#{server_name}") }
  end

  ruby_block "adding-multicore-#{server_name}" do
    block do
      fe = Chef::Util::FileEdit.new("/usr/share/solr/solr.xml")
      fe.insert_line_after_match(/<cores/, "<core name=\"#{server_name}\" instanceDir=\"#{server_name}\" />")
      fe.write_file
    end
  end

end
