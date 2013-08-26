require 'spec_helper'

describe 'mcollective' do
  let(:facts) { { :osfamily => 'RedHat' } }

  context '#version' do
    context "default" do
      it { should contain_package('mcollective').with_ensure('present') }
    end

    context "set" do
      let(:params) { { :version => '1.21' } }
      it { should contain_package('mcollective').with_ensure('1.21') }
    end
  end

  context '#enterprise' do
    context "default (false)" do
      it { should contain_service('mcollective').with_name('mcollective') }
    end

    context 'true' do
      let(:params) { { :enterprise => true } }
      it { should contain_service('mcollective').with_name('pe-mcollective') }
    end
  end

  context '#manage_packages' do
    context "default (true)" do
      it { should contain_package('mcollective') }
    end

    context "false" do
      let(:params) { { :manage_packages => false } }
      it { should_not contain_package('mcollective') }
    end
  end

  context '#manage_plugins' do
    context "default (false)" do
      it { should_not contain_mcollective__plugins__plugin('registration') }
    end

    context "true" do
      let(:params) { { :manage_plugins => true } }
      it {
        pending "mcollective::plugins::plugin didn't get translated"
        should contain_mcollective__plugins__plugin('registration')
      }
    end
  end

  context '#server' do
    context 'default (true)' do
      it { should contain_package('mcollective') }
    end

    context 'false' do
      let(:params) { { :server => false } }
      it { should_not contain_package('mcollective') }
    end
  end

  context '#server_config' do
    context 'default (unset)' do
      it { should contain_file('mcollective::server').with_content(/To be replaced/) }
    end

    context 'set' do
      let(:params) { { :server_config => 'I like pie' } }
      it { should contain_file('mcollective::server').with_content('I like pie') }
    end
  end

  context '#server_config_file' do
    context 'default (unset)' do
      it { should contain_file('mcollective::server').with_path('/etc/mcollective/server.cfg') }
    end

    context 'set' do
      let(:params) { { :server_config_file => '/etc/mco/server.cfg' } }
      it { should contain_file('mcollective::server').with_path('/etc/mco/server.cfg') }
    end
  end

  context '#client' do
    context 'default (false)' do
      it { should_not contain_package('mcollective-client') }
    end

    context 'true' do
      let(:params) { { :client => true } }
      it { should contain_package('mcollective-client') }
    end
  end

  context '#client_config' do
    context 'default (unset)' do
      let(:params) { { :client => true } }
      it { should contain_file('mcollective::client').with_content(/To be replaced/) }
    end
      
    context 'set' do
      let(:params) { { :client => true, :client_config => 'mmm, donuts' } }
      it { should contain_file('mcollective::client').with_content('mmm, donuts') }
    end
  end

  context '#client_config_file' do
    context 'default (unset)' do
      let(:params) { { :client => true } }
      it { should contain_file('mcollective::client').with_path('/etc/mcollective/client.cfg') }
    end
      
    context 'set' do
      let(:params) { { :client => true, :client_config_file => '/etc/mco/donuts.cfg' } }
      it { should contain_file('mcollective::client').with_path('/etc/mco/donuts.cfg') }
    end
  end

  context '#main_collective' do
    context 'default (mcollective)' do
      it { should contain_mcollective__common__setting('main_collective').with_value('mcollective') }
    end

    context 'set' do
      let(:params) { { :main_collective => 'pies' } }
      it { should contain_mcollective__common__setting('main_collective').with_value('pies') }
    end
  end

  context '#collectives' do
    context 'default (mcollective)' do
      it { should contain_mcollective__common__setting('collectives').with_value('mcollective') }
    end

    context 'set' do
      let(:params) { { :collectives => 'pies' } }
      it { should contain_mcollective__common__setting('collectives').with_value('pies') }
    end
  end

  context '#connector' do
    context 'default (stomp)' do
      it {
        pending "default is now activemq.  deprecate/alert how?"
        should contain_mcollective__common__setting('connector').with_value('stomp')
      }
    end

    context 'set' do
      let(:params) { { :connector => 'activemq_too' } }
      it { should contain_mcollective__common__setting('connector').with_value('activemq_too') }
    end
  end

  context '#classesfile' do
    context 'default (/var/lib/puppet/state/classes.txt)' do
      it { should contain_mcollective__server__setting('classesfile').with_value('/var/lib/puppet/state/classes.txt') }
    end

    context 'set' do
      let(:params) { { :classesfile => 'pies' } }
      it { should contain_mcollective__server__setting('classesfile').with_value('pies') }
    end
  end

  context '#stomp_pool' do
    # The parameter is horrible, and heavily tied to the deprecated stomp
    # connector.  Kill.
    let(:params) { { :stomp_pool => { 'pool1' => { 'host1' => 'pies' } } } }
    it "should fail when used" do
      expect { should contain_file('server_config').with_content(/^plugin.stomp.pool.host1\s+=\s+pies$/m) }.to raise_error(/Use of deprecated parameter `stomp_hosts`./)
    end
  end

  context '#stomp_server' do
    context 'default (stomp)' do
      it {
        pending "rethink the default"
        # New module defaults to [], old defaults to 'stomp'.  Calling a box
        # 'stomp' is weird but people probably did it
        should contain_mcollective__common__setting('plugin.activemq.pool.1.host').with_value('stomp')
      }
    end

    context 'set' do
      let(:params) { { :stomp_server => 'pies' } }
      it { should contain_mcollective__common__setting('plugin.activemq.pool.1.host').with_value('pies') }
    end
  end

  context '#stomp_user' do
    context 'default (mcollective)' do
      let(:params) { { :stomp_server => 'padding' } }
      it { should contain_mcollective__common__setting('plugin.activemq.pool.1.user').with_value('mcollective') }
    end

    context 'set' do
      let(:params) { { :stomp_server => 'padding', :stomp_user => 'pies' } }
      it { should contain_mcollective__common__setting('plugin.activemq.pool.1.user').with_value('pies') }
    end
  end

  context '#stomp_passwd' do
    context 'default (marionette)' do
      let(:params) { { :stomp_server => 'padding' } }
      it { should contain_mcollective__common__setting('plugin.activemq.pool.1.password').with_value('marionette') }
    end

    context 'set' do
      let(:params) { { :stomp_server => 'padding', :stomp_passwd => 'pies' } }
      it { should contain_mcollective__common__setting('plugin.activemq.pool.1.password').with_value('pies') }
    end
  end

  context '#mc_security_provider' do
    context 'default (ssl)' do
      it { should contain_mcollective__common__setting('securityprovider').with_value('ssl') }
    end

    context 'set' do
      let(:params) { { :mc_security_provider => 'pies' } }
      it { should contain_mcollective__common__setting('securityprovider').with_value('pies') }
    end
  end

  context '#mc_security_psk' do
    context 'default (changemeplease)' do
      let(:params) { { :securityprovider => 'psk' } }
      it { should contain_mcollective__common__setting('plugin.psk').with_value('changemeplease') }
    end

    context 'set' do
      let(:params) { { :securityprovider => 'psk', :mc_security_psk => 'pies' } }
      it { should contain_mcollective__common__setting('plugin.psk').with_value('pies') }
    end
  end

  context '#fact_source' do
    context 'default (facter)' do
      it {
        pending "the old default is silly"
        should contain_mcollective__server__setting('factsource').with_value('facter')
      }
    end

    context 'set' do
      let(:params) { { :fact_source => 'yaml' } }
      it { should contain_mcollective__server__setting('factsource').with_value('yaml') }
    end
  end

  context '#yaml_facter_source' do
    context 'default (/etc/mcollective/facts.yaml)' do
      let(:params) { { :fact_source => 'yaml' } }
      it { should contain_file('server_config').with_content(/^plugin.yaml\s+=\s+\/etc\/mcollective\/facts.yaml$/m) }
    end

    context 'set' do
      let(:params) { { :fact_source => 'yaml', :yaml_facter_source => 'pies' } }
      it { should contain_file('server_config').with_content(/^plugin.yaml\s+=\s+pies$/m) }
    end
  end

  context '#plugin_params' do
    let(:params) { { :plugin_params => { 'foo' => 'bar' } } }
    it { should contain_file('server_config').with_content(/^plugin.foo\s+=\s+bar$/m) }
  end
end
