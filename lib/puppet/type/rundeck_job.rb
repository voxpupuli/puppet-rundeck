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

  newparam(:api_token) do
    desc ''
    defaultto ''
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

    munge do |value|
      value = Hash[value.sort_by{|k,v| k}]
      value
    end
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
    defaultto ''
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
    defaultto ''
  end

  newproperty(:notifications) do
    desc ''
    defaultto {}

    munge do |value|
      value = Hash[value.sort_by{|k,v| k}]
      value
    end
  end

  newproperty(:job_schedule) do
    desc ''
    defaultto {}
  end

  newproperty(:multiple_exec) do
    desc ''
    defaultto false

    munge do |value|
      case
      when value == true || value =~ /^(true)$/i
        true
      when value == false || value =~ /^(false)$/i
        false
      else
        raise ArgumentError.new "invalid value for Boolean: '#{value}'"
      end
    end
  end

  newproperty(:timeout) do
    desc ''
    defaultto ''
  end

  newproperty(:retry) do
    desc ''
    defaultto ''
  end

  newproperty(:options, :array_matching => :all) do
    desc ''
    defaultto []

    munge do |value|
      value = Hash[value.sort_by{|k,v| k}]
      value
    end
  end
end
