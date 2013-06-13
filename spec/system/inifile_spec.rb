require 'spec_helper_system'

describe 'mcollective_server_setting:' do
  # set initial content
  context shell('(echo foo = 1; echo bar = 2) > /etc/mcollective/server.cfg') do
    its(:exit_code) { should == 0 }
  end

  pp = <<-EOS
    resources { 'mcollective_server_setting':
      purge => true,
    }
    mcollective_server_setting { 'there_can_be_only_one':
      value => 'or something like that',
    }
  EOS

  context puppet_apply(pp) do
    its(:exit_code) { should_not eq(1) }
  end

  context shell('cat /etc/mcollective/server.cfg') do
    its(:stdout) { should == "there_can_be_only_one = or something like that\n" }
  end
end
