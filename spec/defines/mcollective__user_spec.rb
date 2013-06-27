require "spec_helper"

describe "mcollective::user" do
  let(:title) { 'nagios' }
  let(:facts) { { :concat_basedir => '/var/lib/concat' } }
  it { should contain_file('/home/nagios/.mcollective.d') }
  it { should contain_concat('/home/nagios/.mcollective') }
  it { should contain_concat__fragment('mcollective::user nagios') }

  describe "specifying pem" do
    let(:params) { { :cert_public => 'public.pem' } }
    it { should contain_concat__fragment('mcollective::user nagios').with_content(/^plugin.ssl_client_public/m) }
  end
end
