require 'spec_helper'

describe 'mcollective::agent' do
  context 'dummy' do
    let(:title) { 'dummy' }
    context 'package' do
      context 'default' do
        it { should_not contain_package('mcollective-dummy-agent') }
      end
      context 'true' do
        let(:params) { { 'package' => true } }
        context 'name unspecified' do
          it { should contain_package('mcollective-dummy-agent') }
        end

        context 'package_name' do
          let(:params) { { 'package' => true, 'package_name' => 'foomatic-agent' } }
          it { should_not contain_package('mcollective-dummy-agent') }
          it { should contain_package('foomatic-agent') }
        end
      end
    end
  end
end
