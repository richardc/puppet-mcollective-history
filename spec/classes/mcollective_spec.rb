require 'spec_helper'
describe 'mcollective' do
  context "RedHat family machines" do
    let(:facts) { { :osfamily => 'RedHat' } }
    it { should contain_class('mcollective') }
  end
end
