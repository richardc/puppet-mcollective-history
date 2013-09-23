require 'spec_helper'

describe 'mcollective' do
  it { should contain_class('mcollective') }
  it { should_not contain_class('mcollective::client') }
  it { should_not contain_class('mcollective::middleware') }

  describe '#server' do
    context 'default (true)' do
      it { should contain_class('mcollective::server') }
    end

    context 'false' do
      let(:params) { { :server => false } }
      it { should_not contain_class('mcollective::server') }
    end
  end

  describe 'installing a server' do
    describe '#manage_packages' do
      context 'true' do
        let(:params) { { :server => true, :manage_packages => true } }
        it { should contain_package('mcollective') }
      end

      context 'false' do
        let(:params) { { :server => true, :manage_packages => false } }
        it { should_not contain_package('mcollective') }
      end
    end

    describe '#version' do
      it 'should default to present' do
        should contain_package('mcollective').with_ensure('present')
      end

      context '42' do
        let(:params) { { :version => '42' } }
        it { should contain_package('mcollective').with_ensure('42') }
      end
    end

    describe '#factsource' do
      it 'should default to yaml' do
        should contain_mcollective__server__setting('factsource').with_value('yaml')
      end

      describe 'yaml' do
        let(:facts) { { :osfamily => 'RedHat', :number_of_cores => 42 } }
        it { should contain_file('/etc/mcollective/facts.yaml') }
        it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  osfamily: RedHat/) }
        it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores: 42/) }
        it 'should be alpha-sorted' do
          should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores:.*?^  osfamily:/m)
        end

        describe '#yaml_fact_path' do
          it 'should default to /etc/mcollective/facts.yaml' do
            should contain_mcollective__server__setting('plugin.yaml').with_value('/etc/mcollective/facts.yaml')
          end

          describe '/tmp/facts' do
            let(:params) { { :yaml_fact_path => '/tmp/facts' } }
            it { should contain_file('/tmp/facts') }
            it { should contain_mcollective__server__setting('plugin.yaml').with_value('/tmp/facts') }
          end
        end
      end

      describe 'facter' do
        let(:params) { { :server => true, :factsource => 'facter' } }
        it { should contain_mcollective__server__setting('factsource').with_value('facter') }
        it { should contain_package('mcollective-facter-facts') }
      end
    end

    describe '#connector' do
      it 'should default to activemq' do
        should contain_mcollective__common__setting('connector').with_value('activemq')
      end

      describe 'activemq' do
        describe '#middleware_hosts' do
          let(:params) { { :server => true, :middleware_hosts => %w{ foo bar } } }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.size').with_value(2) }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.1.host').with_value('foo') }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.1.port').with_value('61613') }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.2.host').with_value('bar') }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.2.port').with_value('61613') }
        end
      end
    end

    describe '#securityprovider' do
      it 'should default to psk' do
        should contain_mcollective__common__setting('securityprovider').with_value('psk')
      end

      describe 'ssl' do
        let(:params) { { :server => true, :securityprovider => 'ssl' } }
        it { should contain_mcollective__server__setting('plugin.ssl_server_public').with_value('/etc/mcollective/server_public.pem') }
        it { should contain_file('/etc/mcollective/server_public.pem') }
      end

      describe 'psk' do
        let(:params) { { :server => true, :securityprovider => 'psk' } }
        it { should contain_mcollective__common__setting('securityprovider').with_value('psk') }
        it { should contain_mcollective__common__setting('plugin.psk').with_value('changemeplease') }
      end
    end

    describe '#rpcauthprovider' do
      it 'should default to action_policy' do
        should contain_mcollective__server__setting('rpcauthprovider').with_value('action_policy')
      end

      describe 'action_policy' do
        let(:params) { { :server => true, :rpcauthprovider => 'action_policy' } }
        it { should contain_mcollective__server__setting('plugin.actionpolicy.allow_unconfigured').with_value('1') }
      end
    end

    describe '#rpcauditprovider' do
      it 'should default to logfile' do
        should contain_mcollective__server__setting('rpcauditprovider').with_value('logfile')
      end

      describe 'logfile' do
        let(:params) { { :server => true, :rpcauditprovider => 'logfile' } }
        it { should contain_mcollective__server__setting('plugin.rpcaudit.logfile').with_value('/var/log/mcollective-audit.log') }
      end
    end

    describe('#classesfile') do
      it 'should default to /var/lib/puppet/state/classes.txt' do
        should contain_mcollective__server__setting('classesfile').with_value('/var/lib/puppet/state/classes.txt')
      end

      describe '/tmp/classes.txt' do
        let(:params) { { :server => true, :classesfile => '/tmp/classes.txt' } }
        it { should contain_mcollective__server__setting('classesfile').with_value('/tmp/classes.txt') }
      end
    end
  end

  describe '#middleware' do
    context 'true' do
      let(:params) { { :middleware => true } }
      it { should contain_class('mcollective::middleware') }
    end

    context 'false' do
      let(:params) { { :middleware => false } }
      it { should_not contain_class('mcollective::middleware') }
    end
  end

  describe 'installing middleware' do
    let(:params) { { :server => false, :middleware => true } }
    it { should contain_class('mcollective::middleware') }

    context '#connector' do
      it 'should default to apache' do
        should contain_class('mcollective::middleware::activemq')
      end

      context 'activemq' do
        it { should contain_class('activemq') }
        it { should contain_class('activemq').with_instance('mcollective') }

        context '#middleware_ssl' do
          it 'should default to false' do
            should_not contain_java_ks('mcollective:truststore')
          end

          context 'true' do
            let(:params) { { :middleware => true, :middleware_ssl => true } }
            it { should contain_java_ks('mcollective:truststore').with_password('puppet') }
          end
        end

        context '#activemq_template' do
          context 'default (in-module)' do
            let(:params) { { :middleware => true } }
            it { should contain_file('activemq.xml').with_content(/middleware/) }
          end

          context 'set' do
            let(:params) { { :middleware => true, :activemq_template => 'site_mcollective/test_activemq.xml.erb' } }
            it { should contain_file('activemq.xml').with_content(/^Test of the mcollective::activemq_template parameter/) }
          end
        end

        context '#activemq_config' do
          context 'default (use template in-module)' do
            let(:params) { { :middleware => true } }
            it { should contain_file('activemq.xml').with_content(/middleware/) }
          end

          context 'set' do
            let(:params) { { :middleware => true, :activemq_config => 'Lovingly hand-crafted' } }
            it { should contain_file('activemq.xml').with_content('Lovingly hand-crafted') }
          end
        end
      end
    end
  end

  describe '#client' do
    context 'true' do
      let(:params) { { :client => true } }
      it { should contain_class('mcollective::client') }
    end

    context 'false' do
      let(:params) { { :client => false } }
      it { should_not contain_class('mcollective::client') }
    end
  end

  describe 'installing a client' do
    let(:params) { { :server => false, :client => true } }

    describe '#manage_packages' do
      context 'true' do
        let(:params) { { :client => true, :manage_packages => true } }
        it { should contain_package('mcollective-client') }
      end

      context 'false' do
        let(:params) { { :client => true, :manage_packages => false } }
        it { should_not contain_package('mcollective-client') }
      end
    end

    describe '#version' do
      it 'should default to present' do
        should contain_package('mcollective-client').with_ensure('present')
      end

      context '42' do
        let(:params) { { :client => true, :version => '42' } }
        it { should contain_package('mcollective-client').with_ensure('42') }
      end
    end

    describe '#connector' do
      it 'should default to activemq' do
        should contain_mcollective__common__setting('connector').with_value('activemq')
      end

      describe 'activemq' do
        describe '#middleware_hosts' do
          let(:params) { { :server => false, :client => true, :middleware_hosts => %w{ foo bar } } }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.size').with_value(2) }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.1.host').with_value('foo') }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.1.port').with_value('61613') }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.2.host').with_value('bar') }
          it { should contain_mcollective__common__setting('plugin.activemq.pool.2.port').with_value('61613') }
        end
      end
    end

    describe '#securityprovider' do
      it 'should default to psk' do
        should contain_mcollective__common__setting('securityprovider').with_value('psk')
      end

      describe 'ssl' do
        let(:params) { { :server => true, :securityprovider => 'ssl' } }
        it { should contain_mcollective__server__setting('plugin.ssl_server_public').with_value('/etc/mcollective/server_public.pem') }
        it { should contain_file('/etc/mcollective/server_public.pem') }
      end

      describe 'psk' do
        let(:params) { { :server => true, :securityprovider => 'psk' } }
        it { should contain_mcollective__common__setting('securityprovider').with_value('psk') }
        it { should contain_mcollective__common__setting('plugin.psk').with_value('changemeplease') }
      end
    end
  end
end
