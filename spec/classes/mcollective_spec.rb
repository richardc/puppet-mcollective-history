require 'spec_helper'
describe 'mcollective' do
  it { should contain_class('mcollective') }
  it { should_not contain_class('mcollective::server') }
  it { should_not contain_class('mcollective::client') }

  describe "installing a server" do
    let(:params) { { :server => true } }
    it { should contain_class('mcollective::server') }

    describe "#factsource" do
      it "should default to yaml" do
        should contain_mcollective__server__setting('factsource').with_value('yaml')
      end

      describe "yaml" do
        let(:facts) { { :osfamily => 'RedHat', :number_of_cores => 42 } }
        it { should contain_file('/etc/mcollective/facts.yaml') }
        it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  osfamily: RedHat/) }
        it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores: 42/) }
        it "should be alpha-sorted" do
          should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores:.*?^  osfamily:/m)
        end
      end

      describe "facter" do
        let(:params) { { :server => true, :factsource => 'facter' } }
        it { should contain_mcollective__server__setting('factsource').with_value('facter') }
        it { should contain_package('mcollective-facter-facts') }
      end
    end

    describe "#connector" do
      it "should default to activemq" do
        should contain_mcollective__server__setting('connector').with_value('activemq')
      end

      describe "activemq" do
        describe "setting connectors" do
          let(:params) { { :server => true, :activemq_hosts => %w{ foo bar } } }
          it { should contain_mcollective__server__setting('plugin.activemq.pool.size').with_value(2) }
          it { should contain_mcollective__server__setting('plugin.activemq.pool.1.host').with_value('foo') }
          it { should contain_mcollective__server__setting('plugin.activemq.pool.1.port').with_value(61614) }
          it { should contain_mcollective__server__setting('plugin.activemq.pool.2.host').with_value('bar') }
          it { should contain_mcollective__server__setting('plugin.activemq.pool.2.port').with_value(61614) }
        end
      end
    end

    describe "#securityprovider" do
      it "should default to ssl" do
        should contain_mcollective__server__setting('securityprovider').with_value('ssl')
      end

      describe "ssl" do
        it { should contain_mcollective__server__setting('plugin.ssl_server_public').with_value('/etc/mcollective/server_public.pem') }
        it { should contain_file('/etc/mcollective/server_public.pem') }
      end

      describe "psk" do
        let(:params) { { :server => true, :securityprovider => 'psk' } }
        it { should contain_mcollective__server__setting('securityprovider').with_value('psk') }
        it { should contain_mcollective__server__setting('plugin.psk').with_value('changeme') }
      end
    end
  end
end
