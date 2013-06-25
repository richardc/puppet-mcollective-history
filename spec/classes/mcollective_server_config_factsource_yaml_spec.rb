require 'spec_helper'
describe 'mcollective::server::config::factsource::yaml' do
  let(:facts) { { :osfamily => 'RedHat', :number_of_cores => 42, } }
  it { should contain_class('mcollective::server::config::factsource::yaml') }
  it { should contain_mcollective_server_setting('factsource').with_value('yaml') }
  it { should contain_file('/etc/mcollective/facts.yaml') }
  it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  osfamily: RedHat/) }
  it { should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores: 42/) }
  it "should be alpha-sorted" do
    should contain_file('/etc/mcollective/facts.yaml').with_content(/^  number_of_cores:.*?^  osfamily:/m)
  end
end
