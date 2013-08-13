module Puppet::Parser::Functions
  newfunction(:prepend_array, :type => :rvalue) do |args|
    outputarray = Array.new
    prepend_value = args[0]
    array = args[1]
    if array.respond_to?('each_index')
	array.each_index {|x| outputarray << prepend_value + array[x] }
	return outputarray
    else
	outputarray <<  prepend_value + array
    end
    return outputarray
  end
end
