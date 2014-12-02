require 'uri'

Puppet::Type.newtype(:rundeck_job) do

  ensurable

  newparam(:base_url) do
    desc ''
    defaultto 'http://localhost:4440'

    validate do |value|
      unless URI.parse(value).is_a?(URI::HTTP)
        fail("Invalid base_url #{value}")
      end
    end
  end

  newparam(:name, :namevar => true) do
    desc ''
  end

  newparam(:project) do
    desc ''
  end

  newproperty(:commands, :array_matching => :all) do
    desc ''
    defaultto []
  end

  newproperty(:group) do
    desc ''
    defaultto ''
  end

  newproperty(:description) do
    desc ''
    defaultto ''
  end

  newproperty(:log_level) do
    desc ''
    defaultto 'INFO'
  end

  newproperty(:node_filter) do
    desc ''
    defaultto {}
  end

  newproperty(:threads) do
    desc ''
    defaultto '1'
  end

  newproperty(:rank_attribute) do
    desc ''
    defaultto ''
  end

  newproperty(:rank_order) do
    desc ''
    defaultto ''
  end

  newproperty(:keep_going) do
    desc ''
    defaultto 'false'
  end

  newproperty(:node_precedence) do
    desc ''
    defaultto 'include'
  end
end
