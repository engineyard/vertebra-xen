$:.unshift File.dirname(__FILE__)

require 'parsers/xenstore_ls'
require 'parsers/xm_info'
require 'parsers/xm_list'

module VertebraXen
  module Actor
    class Xen < ::Vertebra::Actor
      
      provides '/xen'

      # should be able to list running or all slices
    	def list(options = {})
    	  Xm::ListOutput.new.parse(StringIO.new(`xm list`))
    	end
    	
    	# get slice info
    	def info(options = {})
    	  Xm::InfoOutput.new.parse(StringIO.new(`xm info`))
    	end
    	
    	# parse entire xenstore_ls output
    	def xenstore_ls(options = {})
    	  Xm::XenstoreLs.new(StringIO.new(`xenstore-ls`)).parse
      end

      # takes a slice name, i.e. ey04-s00010
<<<<<<< HEAD:lib/vertebra-xen/actor.rb
    	def shutdown_slice(options = {})
        execute("xm shutdown #{options['slice']}")
      end

      # takes a slice name, i.e. ey04-s00010
    	def create_slice(options = {})
=======
    	def shutdown(options = {})
    	  `xm shutdown #{options['slice']}`
      end

      # takes a slice name, i.e. ey04-s00010
    	def create(options = {})
>>>>>>> 9d6c737c65f6ca4479434ed1f0ae804bc23b31cb:lib/vertebra-xen/actor.rb
    	  `xm create /etc/xen/auto/#{options['slice']}.xen`
      end

      # takes a slice name, i.e. ey04-s00010
    	def reboot_slice(options = {})
    	  `xm reboot #{options['slice']}`
      end
      
      # takes a slice name, i.e. ey04-s00010      
      def set_slice_ram(options = {})
        # use parser to read file, validate ram setting against the maxmem and node, and write back, backup up the original
      end

    end
  end
end
