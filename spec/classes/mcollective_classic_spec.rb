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
      it { should contain_mcollective__plugins__plugin('registration') }
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
      it { should contain_file('server_config').with_content(/Basic stuff/) }
    end

    context 'set' do
      let(:params) { { :server_config => 'I like pie' } }
      it { should contain_file('server_config').with_content('I like pie') }
    end
  end

  context '#server_config_file' do
    context 'default (unset)' do
      it { should contain_file('server_config').with_path('/etc/mcollective/server.cfg') }
    end

    context 'set' do
      let(:params) { { :server_config_file => '/etc/mco/server.cfg' } }
      it { should contain_file('server_config').with_path('/etc/mco/server.cfg') }
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
      it { should contain_file('client_config').with_content(/Basic stuff/) }
    end
      
    context 'set' do
      let(:params) { { :client => true, :client_config => 'mmm, donuts' } }
      it { should contain_file('client_config').with_content('mmm, donuts') }
    end
  end

  context '#client_config_file' do
    context 'default (unset)' do
      let(:params) { { :client => true } }
      it { should contain_file('client_config').with_path('/etc/mcollective/client.cfg') }
    end
      
    context 'set' do
      let(:params) { { :client => true, :client_config_file => '/etc/mco/donuts.cfg' } }
      it { should contain_file('client_config').with_path('/etc/mco/donuts.cfg') }
    end
  end

  context '#main_collective' do
    context 'default (mcollective)' do
      it { should contain_file('server_config').with_content(/^main_collective\s+=\s+mcollective$/m) }
    end

    context 'set' do
      let(:params) { { :main_collective => 'pies' } }
      it { should contain_file('server_config').with_content(/^main_collective\s+=\s+pies$/m) }
    end
  end

  context '#collectives' do
    context 'default (mcollective)' do
      it { should contain_file('server_config').with_content(/collectives\s+=\s+mcollective$/m) }
    end

    context 'set' do
      let(:params) { { :collectives => 'pies' } }
      it { should contain_file('server_config').with_content(/^collectives\s+=\s+pies$/m) }
    end
  end

  context '#connector' do
    context 'default (stomp)' do
      it { should contain_file('server_config').with_content(/^connector\s+=\s+stomp$/m) }
    end

    context 'set' do
      let(:params) { { :connector => 'activemq' } }
      it { should contain_file('server_config').with_content(/^connector\s+=\s+activemq$/m) }
    end
  end

  context '#classesfile' do
    context 'default (/var/lib/puppet/state/classes.txt)' do
      it { should contain_file('server_config').with_content(/^classesfile\s+=\s+\/var\/lib\/puppet\/state\/classes.txt$/m) }
    end

    context 'set' do
      let(:params) { { :classesfile => 'pies' } }
      it { should contain_file('server_config').with_content(/^classesfile\s+=\s+pies$/m) }
    end
  end

  context '#stomp_pool' do
    # The parameter is horrible, and heavily tied to the deprecated stomp
    # connector.  Kill.
    let(:params) { { :stomp_pool => { 'pool1' => { 'host1' => 'pies' } } } }
    it { should contain_file('server_config').with_content(/^plugin.stomp.pool.host1\s+=\s+pies$/m) }
  end

  context '#stomp_server' do
    context 'default (stomp)' do
      it { should contain_file('server_config').with_content(/^plugin.stomp.pool.host1\s+=\s+stomp$/m) }
    end

    context 'set' do
      let(:params) { { :stomp_server => 'pies' } }
      it { should contain_file('server_config').with_content(/^plugin.stomp.pool.host1\s+=\s+pies$/m) }
    end
  end

  context '#stomp_user' do
    context 'default (mcollective)' do
      it { should contain_file('server_config').with_content(/^plugin.stomp.pool.user1\s+=\s+mcollective$/m) }
    end

    context 'set' do
      let(:params) { { :stomp_user => 'pies' } }
      it { should contain_file('server_config').with_content(/^plugin.stomp.pool.user1\s+=\s+pies$/m) }
    end
  end

  context '#stomp_passwd' do
    context 'default (marionette)' do
      it { should contain_file('server_config').with_content(/^plugin.stomp.pool.password1\s+=\s+marionette$/m) }
    end

    context 'set' do
      let(:params) { { :stomp_passwd => 'pies' } }
      it { should contain_file('server_config').with_content(/^plugin.stomp.pool.password1\s+=\s+pies$/m) }
    end
  end

  context '#mc_security_provider' do
    context 'default (psk)' do
      it { should contain_file('server_config').with_content(/^securityprovider\s+=\s+psk$/m) }
    end

    context 'set' do
      let(:params) { { :mc_security_provider => 'pies' } }
      it { should contain_file('server_config').with_content(/^securityprovider\s+=\s+pies$/m) }
    end
  end

  context '#mc_security_psk' do
    context 'default (changemeplease)' do
      it { should contain_file('server_config').with_content(/^plugin.psk\s+=\s+changemeplease$/m) }
    end

    context 'set' do
      let(:params) { { :mc_security_psk => 'pies' } }
      it { should contain_file('server_config').with_content(/^plugin.psk\s+=\s+pies$/m) }
    end
  end

  context '#fact_source' do
    context 'default (facter)' do
      it { should contain_file('server_config').with_content(/^factsource\s+=\s+facter$/m) }
    end

    context 'set' do
      let(:params) { { :fact_source => 'yaml' } }
      it { should contain_file('server_config').with_content(/^factsource\s+=\s+yaml$/m) }
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
