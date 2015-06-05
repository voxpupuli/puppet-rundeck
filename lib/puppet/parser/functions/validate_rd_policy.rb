require 'puppet/util/rundeck_acl'

module Puppet::Parser::Functions

  newfunction(:validate_rd_policy, :doc => <<-'ENDHEREDOC') do |args|

    ENDHEREDOC

    unless args.length == 1 then
      raise Puppet::ParseError, ("validate_rd_policy(): wrong number of arguments (#{args.length}; must be 1)")
    end

    args.each do |arg|
      if arg.is_a?(Array)

      elsif arg.is_a?(Hash)
        Puppet::Util::RundeckACL.validate_acl(arg)
      else
        raise Puppet::ParseError, ("#{arg.inspect} is not a Hash or Array of hashes.  It looks to be a #{arg.class}")
      end
    end
  end
end