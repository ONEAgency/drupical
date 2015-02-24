# -*- mode: ruby -*-
# vi: set ft=ruby :

def vagrant_check_requirements

  if !Vagrant.has_plugin?("vagrant-triggers") || !Vagrant.has_plugin?("vagrant-hostsupdater") || !Vagrant.has_plugin?("vagrant-cachier") || !Vagrant.has_plugin?("vagrant-vbguest") || !Vagrant.has_plugin?("vagrant-persistent-storage") || !Vagrant.has_plugin?("vagrant-hostmanager")

    puts "#"
    puts "Vagrant needs extra plugin(s)"
    puts "You can install them as follow:"
    puts "#"

    if !Vagrant.has_plugin?("vagrant-triggers")
      puts "vagrant plugin install vagrant-triggers"
    end

    if !Vagrant.has_plugin?("vagrant-hostsupdater")
      puts "vagrant plugin install vagrant-hostsupdater"
    end

    if !Vagrant.has_plugin?("vagrant-cachier")
      puts "vagrant plugin install vagrant-cachier"
    end

    if !Vagrant.has_plugin?("vagrant-vbguest")
      puts "vagrant plugin install vagrant-vbguest"
    end

    if !Vagrant.has_plugin?("vagrant-omnibus")
      puts "vagrant plugin install vagrant-omnibus"
    end

    if !Vagrant.has_plugin?("vagrant-persistent-storage")
      puts "vagrant plugin install vagrant-persistent-storage"
    end

    if !Vagrant.has_plugin?("vagrant-hostmanager")
      puts "vagrant plugin install vagrant-hostmanager"
    end

    puts "#"

    raise SystemExit

  end

end


def vagrant_get_config()

  vconfig_global = false

  settings_dir = File.expand_path('./build/vagrant/')

  local_settings_dir = File.expand_path('./build/')

  if File.exists? (settings_dir + "/default.vagrant.settings.json")

    vconfig_global = JSON.parse(File.read(settings_dir + "/default.vagrant.settings.json"))

    if File.exists? (local_settings_dir + "/local.vagrant.settings.json")

      puts "Found local.settings.json."

      vconfig_local = JSON.parse(File.read(local_settings_dir + "/local.vagrant.settings.json"))

      vconfig_global["config"].each do |gkey, gvalue|

        temp = vconfig_local['config'].select { |key, value| key == gkey }

        if temp.length > 0

          vconfig_global['config'].delete(gkey)

        end

      end

      vconfig_global['config'].merge!(vconfig_local['config'])

    else

      puts "#"
      puts "Couldn't find local.vagrant.settings.json in " + local_settings_dir + "."
      puts "Using default values from default.vagrant.settings.json"
      puts "#"

    end

  else

    puts "#"
    puts "Couldn't find default.vagrant.settings.json in " + settings_dir + "."
    puts "#"

    raise SystemExit

  end

  return vconfig_global

end

def vagrant_get_alias(vconfig)

  #
  aliases = Array.new

  #
  vhosts = vconfig['config']['vhosts']
  vhosts.each do |key, vhost|

    aliases.push(vhost.fetch('server_name'))

    _aliases = vhost.fetch('aliases')
    _aliases.each do |key, _alias|
      aliases.push(_alias)
    end

  end

  #
  web_tools = vconfig['config']['drupical']['web_tools']['tools']
  web_tools.each do |key, web_tool|

    if web_tool['install']
      url_base = vconfig['config']['drupical']['web_tools']['url_base']
      tool_alias = web_tool.fetch('alias')
      aliases.push("#{tool_alias}.#{url_base}")
    end

  end

  return aliases

end

$logger = Log4r::Logger.new('vagrantfile')
def read_ip_address(machine)
  command = "LANG=en ifconfig  | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1 }'"
  result  = ""

  $logger.info "Processing #{ machine.name } ... "

  begin
    # sudo is needed for ifconfig
    machine.communicate.sudo(command) do |type, data|
      result << data if type == :stdout
    end
    $logger.info "Processing #{ machine.name } ... success"
  rescue
    result = "# NOT-UP"
    $logger.info "Processing #{ machine.name } ... not running"
  end

  # the second inet is more accurate
  result.chomp.split("\n").last
end