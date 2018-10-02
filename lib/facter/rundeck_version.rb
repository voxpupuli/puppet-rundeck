# Fact: rundeck_version
#
# Purpose: Retrieve rundeck version if installed
#
# Resolution:
#
# Caveats: not well tested
#
if Facter::Util::Resolution.which('rd-acl')
  rd_acl_help = Facter::Util::Resolution.exec('rd-acl -h')
  pattern = %r{^\[RUNDECK version (?<rd_ver>[\w\.]+)\-?(?<rd_commitid>[\w]*) \(([\w]+)\)\]}

  pattern.match( rd_acl_help ) { |m|
    Facter.add( "rundeck_version" ) do
      setcode do
        m[:rd_ver]
      end
    end
    Facter.add( "rundeck_commitid" ) do
      setcode do
        m[:rd_commitid]
      end
    end
  }

end
