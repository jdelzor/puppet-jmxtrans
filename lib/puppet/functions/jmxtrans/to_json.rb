# Stringify data into the JSON format
Puppet::Functions.create_function(:'jmxtrans::to_json') do
  # @param data Data to stringify
  # @return Generated JSON string
  dispatch :data_to_json do
    param 'Data', :data
  end

  def data_to_json(data)
    require 'json'

    data.to_json
  end
end
