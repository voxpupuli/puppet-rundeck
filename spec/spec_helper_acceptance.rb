require 'voxpupuli/acceptance/spec_helper_acceptance'

configure_beaker do |host|
  install_module_from_forge_on(host, 'puppetlabs-java', '>= 2.1.0 < 7.0.0')
  install_module_from_forge_on(host, 'puppetlabs-apt', '>= 4.1.0 < 8.0.0')
end
