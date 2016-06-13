# Fact: rundeck_version
#
# Purpose: Retrieve rundeck version if installed
#
# Resolution:
#
# Caveats: not well tested
#
Facter.add(:rundeck_version) do
  setcode do
    if Facter::Util::Resolution.which('rd-acl')
      rd_acl_help = Facter::Util::Resolution.exec('rd-acl -h')
      %r{^\[RUNDECK version ([\w\.]+) \(([\w]+)\)\]}.match(rd_acl_help)[1]
    end
  end
end
