require "spec_helper"

describe "mcollective::user::setting" do
  context "nagios:some_setting" do
    let(:title) { 'nagios:some_setting' }
    let(:params) { { 'username' => 'nagios', 'value' => "pie" } }
    it { should contain_datacat_fragment('mcollective::user nagios some_setting') }
    it { should contain_datacat_fragment('mcollective::user nagios some_setting').with_data({ 'some_setting' => 'pie' }) }
  end
end
