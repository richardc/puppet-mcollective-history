require "spec_helper"

describe "mcollective::user" do
  let(:title) { 'nagios' }
  it { should contain_file('/home/nagios/.mcollective.d') }
  it { should contain_file('mcollective::user nagios').with_path('/home/nagios/.mcollective') }

  describe "#certificate" do
    context "unspecified" do
      it { should_not contain_file('/home/nagios/.mcollective.d/credentials/certs/nagios.pem') }
      it { should_not contain_mcollective__user__setting('nagios:plugin.ssl_client_public') }
    end

    context "specified" do
      let(:params) { { :certificate => 'certs/nagios.pem' } }
      it { should contain_file('/home/nagios/.mcollective.d/credentials/certs/nagios.pem') }
      it { should contain_file('/home/nagios/.mcollective.d/credentials/certs/nagios.pem').with_source('certs/nagios.pem') }
      it { should contain_mcollective__user__setting('nagios:plugin.ssl_client_public') }
      it { should contain_mcollective__user__setting('nagios:plugin.ssl_client_public').with_value('/home/nagios/.mcollective.d/credentials/certs/nagios.pem') }
    end
  end

  describe "#private_key" do
    context "unspecified" do
      it { should_not contain_file('/home/nagios/.mcollective.d/credentials/private_keys/nagios.pem') }
      it { should_not contain_mcollective__user__setting('nagios:plugin.ssl_client_private') }
    end

    context "specified" do
      let(:params) { { :private_key => 'private_keys/nagios.pem' } }
      it { should contain_file('/home/nagios/.mcollective.d/credentials/private_keys/nagios.pem') }
      it { should contain_file('/home/nagios/.mcollective.d/credentials/private_keys/nagios.pem').with_source('private_keys/nagios.pem') }
      it { should contain_mcollective__user__setting('nagios:plugin.ssl_client_private') }
      it { should contain_mcollective__user__setting('nagios:plugin.ssl_client_private').with_value('/home/nagios/.mcollective.d/credentials/private_keys/nagios.pem') }
    end
  end
end
