# Copyright 2008, Engine Yard, Inc.
#
# This file is part of Vertebra.
#
# Vertebra is free software: you can redistribute it and/or modify it under the
# terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, either version 3 of the License, or (at your option) any
# later version.
#
# Vertebra is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Vertebra.  If not, see <http://www.gnu.org/licenses/>.

$:.unshift File.dirname(__FILE__)

require 'thor'
require 'vertebra/actor'
require 'vertebra/extensions'

require 'parsers/xenstore_ls'
require 'parsers/xm_info'
require 'parsers/xm_list'

require File.dirname(__FILE__) + '/../../vendor/dot_xen/lib/dot_xen'
require File.dirname(__FILE__) + '/../../vendor/dot_xen/lib/xen/ast'
require File.dirname(__FILE__) + '/../../vendor/dot_xen/lib/xen/visitor'

module VertebraXen
  class Actor < Vertebra::Actor

    provides '/xen'

    def initialize(opts = {}, *args)
      @conf_parser = XenConfigFile::Parser.new
      super
    end

    bind_op "/xen/list", :list
    desc "/xen/list", "List running slices"
    def list(options = {})
      Xm::ListOutput.new.parse(StringIO.new(`xm list`))
    end

    bind_op "/xen/info", :info
    desc "/xen/info", "Show xm info"
    def info(options = {})
      Xm::InfoOutput.new.parse(StringIO.new(`xm info`))
    end

    bind_op "/xen/store", :xenstore_ls
    desc "/xen/store", "Show xenstore-ls output"
    def xenstore_ls(options = {})
      Xm::XenstoreLs.new(StringIO.new(`xenstore-ls`)).parse
    end

    bind_op "/slice/shutdown", :shutdown_slice
    desc '/slice/shutdown', "Shutdown a specific slice"
    method_options :slice => :required
    def shutdown_slice(options = {})
      spawn "xm", "shutdown", options['slice']
    end

    # takes a slice name, i.e. ey04-s00010
    bind_op "/slice/create", :create_slice
    desc "/slice/create", "Create a slice"
    def create_slice(options = {})
      spawn "xm", "create", "/etc/xen/auto/#{options['slice']}.xen"
    end

    # takes a slice name, i.e. ey04-s00010
    bind_op "/slice/reboot", :reboot_slice
    desc "/slice/reboot", "Reboot a slice"
    def reboot_slice(options = {})
      spawn "xm", "reboot", options['slice']
    end

    # takes a slice name, i.e. ey04-s00010
    bind_op "/slice/set", :slice_set_values
    desc '/slice/set', "Set memory or vcpu of a slice"
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
            spawn "xm", "mem-set", options['slice'], v
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

    bind_op "/xen/backup/config", :backup_config
    desc "/xen/backup/config", "Backup Xen configuration"
    def backup_config(path)
      base_path = File.dirname(path)
      filename = File.basename(path)
      backup_path = "#{base_path}/.#{filename}.bak"
      # write backup of original file
      FileUtils.cp(path, backup_path)
    end

  end
end
