require 'rspec-system/spec_helper'
require 'rspec-system-puppet/helpers'

include RSpecSystemPuppet::Helpers

RSpec.configure do |c|
  # Project root for the firewall code
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Enable colour in Jenkins
  c.tty = true

  c.include RSpecSystemPuppet::Helpers

  # This is where we 'setup' the nodes before running our tests
  c.before :suite do
    # Install puppet
    puppet_install
    puppet_master_install

    # Replace mymodule with your module name
    puppet_module_install(:source => proj_root, :module_name => 'mcollective')
    # XXX would be better if puppet_module_install parsed this out of the
    # Modulefile
    shell "puppet module install cprice404/inifile"
  end
end
