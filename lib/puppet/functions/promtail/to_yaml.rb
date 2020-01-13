require 'yaml'

# A function to convert a hash into yaml for the promtail config
Puppet::Functions.create_function(:'promtail::to_yaml') do
  # @param config_hash
  #   A Puppet hash to be converted into YAML
  # @return [String]
  #   Returns the YAML version of the hash as a string
  # @example
  #   promtail::to_yaml($promtail::config_hash)
  #
  dispatch :generate_yaml do
    param 'Hash', :config_hash
    return_type 'String'
  end

  def generate_yaml(config_hash)
    config_hash.to_yaml
  end
end
