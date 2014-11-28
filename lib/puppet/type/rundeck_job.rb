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

  newproperty(:nodefilters) do
    desc ''
    defaultto {}
  end
end
