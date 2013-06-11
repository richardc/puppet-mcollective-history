require 'spec_helper'

describe 'test1' do
  let(:facts) { { :osfamily => 'Debian' } }
  it { should include_class('mcollective') }
end
