require 'rubygems'

begin
  require 'thor'
  require 'vertebra/base_runner'
rescue LoadError
  puts "Please install the thor and vertebra gems."
  exit
end

module Vertebra
  class VXen < BaseRunner
  
    @@global_method_options = {:node => :optional, :cluster => :optional, :only_nodes => :boolean, :slice => :optional}
      
    def self.all_method_options(opts = {})
      self.method_options(@@global_method_options.merge(opts))
    end

    desc "list", "Get a list of slices on a node"
    all_method_options

    def list(opts = {})
      results = broadcast('list', '/xen', opts)
      results.each do |host, values|
        puts "\n#{host}\n#{values.to_yaml}"
      end
    end

    desc "info", "Get output of xm info"
    all_method_options

    def info(opts = {})
      results = broadcast('info', '/xen', opts)
      puts results.inspect
    end

  end
end