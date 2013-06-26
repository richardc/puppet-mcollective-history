require 'spec_helper'
describe 'mcollective' do
  let(:facts) { { :osfamily => 'RedHat' } }

  context "RedHat family machines" do
    it { should contain_class('mcollective') }
    it { should_not contain_class('mcollective::server') }
    it { should_not contain_class('mcollective::client') }
  end

  describe "installing a server" do
    let(:params) { { :server => true } }
    it { should contain_class('mcollective::server') }

    describe "factsource" do
      it "should default to a yaml factsource" do
        should contain_mcollective_server_setting('factsource').with_value('yaml')
      end

      describe "yaml factsource" do
        let(:facts) { { :osfamily => 'RedHat', :number_of_cores => 42, } }
        it { should contain_class('mcollective::server::config::factsource::yaml') }
        it { should contain_file('/etc/mcollective/facts.yaml') }
        it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  osfamily: RedHat/) }
        it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores: 42/) }
        it "should be alpha-sorted" do
          should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores:.*?^  osfamily:/m)
        end
      end
    end
  end
end
