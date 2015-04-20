name 'database'

maintainer 'Bart Arickx'
maintainer_email 'bart.arickx@one-agency.be'

license '(c) 2015 -- All rights reserved'

description 'Installs/Configures database'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

version '0.1.0'

%w{ ubuntu }.each do |os|
  supports os
end

%w{base mysql apt}.each do |dependancy|
  depends dependancy
end

recipe 'database::mysql', 'mysql'
recipe 'database::mariadb', 'mariadb'
recipe 'database::config', 'config'
recipe 'database::backup-db', 'backup-db'

