require File.expand_path('../../../../puppetx/rundeck/acl', __FILE__)

# Validates the rundeck ACL policies
# Usage:
# Example:
# Parser
Puppet::Parser::Functions.newfunction(:validate_rd_policy, :doc => <<-'ENDHEREDOC') do |args|
  ENDHEREDOC

  raise Puppet::ParseError, "validate_rd_policy(): wrong number of arguments (#{args.length}; must be 1)" unless args.length == 1

  args.each do |arg|
    next if arg.is_a?(Array)
    return PuppetX::Rundeck::ACL.validate_acl(arg) if arg.is_a?(Hash)
    raise Puppet::ParseError, "#{arg.inspect} is not a Hash or Array of hashes.  It looks to be a #{arg.class}"
  end
end
