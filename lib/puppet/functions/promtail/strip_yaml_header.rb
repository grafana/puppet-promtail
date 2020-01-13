# A function to strip the --- from the beginning of a string
Puppet::Functions.create_function(:'promtail::strip_yaml_header') do
  # @param yaml_string
  #   A string that may start with the ---'s used to denote a YAML file
  # @return [String]
  #   Returns the string with the leading header stripped off
  # @example
  #   concat::fragment { 'server_config_hash':
  #     target  => $config_file,
  #     content => $promtail::server_config_hash.promtail::to_yaml.promtail::strip_yaml_header,
  #     order   => '10',
  #   }
  #
  dispatch :strip_header do
    param 'String', :yaml_string
    return_type 'String'
  end

  def strip_header(yaml_string)
    yaml_string.gsub(%r{^---\s}, '')
  end
end
