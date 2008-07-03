require 'rubygems'
require 'treetop'

require File.dirname(__FILE__) + '/xen/ast'
Treetop.load File.dirname(__FILE__) + '/xen/xen_config_file_you_shouldnt_use'
require File.dirname(__FILE__) + '/xen/xen_config_file_you_shouldnt_use_node_classes'

module XenConfigFile
  class Parser < Treetop::Runtime::CompiledParser
    include XenConfigFileYouShouldntUse
    
    def simple_parse(io)
      parsed = parse(io)
      parsed.eval({}) unless parsed.nil?
    end
  end
end

