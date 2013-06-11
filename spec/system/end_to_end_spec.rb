require 'spec_helper_system'

describe 'single node setup:' do
  pp = <<-EOS
    class { 'mcollective':
      activemq_hosts => [ $::fqdn ],
    }
    class { 'mcollective::activemq': } ->
    class { 'mcollective::server': }
    class { 'mcollective::client': }
  EOS

  context puppet_apply(pp) do
    its(:exit_code) { should be_zero }
  end

  context shell('mco ping') do
    its(:stdout) { should =~ /main.foo.vm/ }
  end
end
