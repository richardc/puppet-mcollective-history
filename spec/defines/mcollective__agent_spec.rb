require 'spec_helper'

describe 'mcollective::agent' do
  context 'dummy' do
    let(:title) { 'dummy' }
    it { should contain_datacat('mcollective::agent dummy actionpolicy') }
  end
end
