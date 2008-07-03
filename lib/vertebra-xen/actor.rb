$:.unshift File.dirname(__FILE__)

require 'parsers/xenstore_ls'
require 'parsers/xm_info'
require 'parsers/xm_list'

module VertebraXen
  module Actor
    class Xen < ::Vertebra::Actor
      
      provides '/xen'

      # no arguments
    	def list(options = {})
    	  Xm::ListOutput.new.parse(StringIO.new(`xm list`))
    	end
    	
    	# no arguments
    	def info(options = {})
    	  Xm::InfoOutput.new.parse(StringIO.new(`xm info`))
    	end
    	
    	# no arguments
    	def xenstore_ls(options = {})
    	  Xm::XenstoreLs.new(StringIO.new(`xenstore-ls`)).parse
      end

      # takes a slice name, i.e. ey04-s00010
    	def shutdown(options = {})
    	  `xm shutdown #{options['slice']}`
      end

      # takes a slice name, i.e. ey04-s00010
    	def create(options = {})
    	  `xm create /etc/xen/auto/#{options['slice']}.xen`
      end
      
    end
  end
end
