maintainer       "Gilles Cornu"
maintainer_email "git@gilles.cornu.name"
license          "Apache 2.0"
description      "Installs typesafe-stack for Scala, Akka and Play projects (sbt, g8)"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.0"

%w{ debian ubuntu centos redhat fedora scientific suse amazon }.each do |os|
    supports os
end

depends 'yum'
depends 'apt', '>= 1.4.0' # needed to install the apt-repository public key bundled in cookbook. See [COOK-921] 
depends 'java'

recipe "typesafe-stack", "Setup typesafe.com repository (apt or yum) and install meta-package 'typesafe-stack'" 
