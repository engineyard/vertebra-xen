$:.unshift File.dirname(__FILE__)

require 'rubygems'
require 'parsers/xenstore_ls'
require 'parsers/xm_info'
require 'parsers/xm_list'
require 'thor'

require File.dirname(__FILE__) + '/../../vendor/dot_xen/lib/dot_xen'
require File.dirname(__FILE__) + '/../../vendor/dot_xen/lib/xen/ast'
require File.dirname(__FILE__) + '/../../vendor/dot_xen/lib/xen/visitor'

module VertebraXen
  class Actor < Thor
    
    RESOURCES = ['/xen']

    def initialize(opts = {}, *args)
      @conf_parser = XenConfigFile::Parser.new
      super
    end
    
    desc "list", "List running slices"
  	def list(options = {})
  	  Xm::ListOutput.new.parse(StringIO.new(`xm list`))
  	end
  	
    desc "info", "Show xm info"
  	def info(options = {})
  	  Xm::InfoOutput.new.parse(StringIO.new(`xm info`))
  	end
  	
    desc "xenstore", "Show xenstore-ls output"
  	def xenstore_ls(options = {})
  	  Xm::XenstoreLs.new(StringIO.new(`xenstore-ls`)).parse
    end

    desc 'shutdown_slice', "Shutdown a specific slice"
    method_options :slice => :required
  	def shutdown_slice(options = {})
      spawn "xm shutdown", options['slice']
    end

    # takes a slice name, i.e. ey04-s00010
  	def create_slice(options = {})
  	  spawn "xm create", "/etc/xen/auto/#{options['slice']}.xen"
    end

    # takes a slice name, i.e. ey04-s00010
  	def reboot_slice(options = {})
  	  spawn "xm reboot", options['slice']
    end
    
    # takes a slice name, i.e. ey04-s00010      
    desc 'set_slice_values', "Set memory or vcpu of a slice"
    method_options :memory => :optional, :vcpu => :optional, :slice => :required
    
    def set_slice_values(options = {})
      xen_root = options['xen_root'] || "/etc/xen/auto"
      conf_path = "#{xen_root}/#{options['slice']}.xen"
      backup_config(conf_path)
      
      contents = File.read(conf_path)
        
      # parse config file into an object with hash-style accessors for attributes
      parsed_conf = @conf_parser.parse(contents)
      conf_obj = parsed_conf.eval
      # take any options that match config file settings and update them
      
      options.each do |k,v|
        case k.to_sym
        when :memory
          
          # TODO: throw exception/return error when there isn't enough memory left
          
          # set the xen file value
          conf_obj[:memory].value = v
          
          if conf_obj[:maxmem]
            spawn "xm mem-set", options['slice'], v
          else
            shutdown_slice('slice' => options['slice'])
            create_slice('slice' => options['slice'])
          end
        else
          if conf_obj[k.to_sym]
            conf_obj[k.to_sym].value = v
          end
        end
      end
  
      # TODO: check for available memory!
      
      # load visitor to write the updated config back
      @visitor = XenConfigFile::AST::Visitor::PrettyPrintVisitor.new
      new_conf_contents = conf_obj.accept(@visitor)
      File.open(conf_path, "w") do |f|
       f.write(new_conf_contents)
      end

      # TODO: If the max-mem directive exists, use mem-set to dynamically set the memory. Otherwise, the slice must be restarted (job for cavalcade?)
    end
    
    def backup_config(path)
      base_path = File.dirname(path)
      filename = File.basename(path)
      backup_path = "#{base_path}/.#{filename}.bak"
      # write backup of original file
      FileUtils.cp(path, backup_path)
    end
        
  end
end
