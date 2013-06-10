Puppet::Type.type(:mcollective_client_setting).provide(
  :ini_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  # mcollective config files are all in the global setting space
  def section
    ''
  end

  def self.file_path
    '/etc/mcollective/client.cfg'
  end
end
