Puppet::Type.type(:mcollective_server_setting).provide(
  :init_setting,
  :parent => Puppet::Type.type(:ini_setting).provider(:ruby)
) do

  # mcollective config files are all in the global setting space
  def section
    ''
  end

  def self.file_path
    '/etc/mcollective/server.cfg'
  end
end