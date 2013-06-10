Puppet::Type.newtype(:mcollective_server_setting) do
  ensurable

  newparam(:setting, :namevar => true) do
    desc 'Setting to manage from server.cfg'
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
  end
end
