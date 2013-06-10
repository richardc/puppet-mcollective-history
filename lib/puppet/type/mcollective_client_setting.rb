Puppet::Type.newtype(:mcollective_client_setting) do
  ensurable

  newparam(:setting, :namevar => true) do
    desc 'Setting to manage from client.cfg'
  end

  newproperty(:value) do
    desc 'The value of the setting to be defined.'
  end

  newparam(:key_val_separator) do
    desc 'The separator string to use between each setting name and value. ' +
         'Defaults to " = ", but you could use this to override e.g. whether ' +
         'or not the separator should include whitespace.'
    defaultto(" = ")

    validate do |value|
      unless value.scan('=').size == 1
        raise Puppet::Error, ":key_val_separator must contain exactly one = character."
      end
    end
  end
end
