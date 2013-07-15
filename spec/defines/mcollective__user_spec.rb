require "spec_helper"

describe "mcollective::user" do
  let(:title) { 'nagios' }
  it { should contain_file('/home/nagios/.mcollective.d') }
  it { should contain_file('/home/nagios/.mcollective') }

  describe "specifying certificate" do
    let(:params) { { :certificate => 'certs/nagios.pem' } }
    it { should contain_mcollective__user__setting('nagios:plugin.ssl_client_public') }
    it { should contain_mcollective__user__setting('nagios:plugin.ssl_client_public').with_value('/home/nagios/.mcollective.d/credentials/certs/nagios.pem') }
    it { should contain_file('/home/nagios/.mcollective.d/credentials/certs/nagios.pem') }
  end
end
