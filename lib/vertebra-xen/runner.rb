require 'rubygems'

begin
  require 'thor'
  require 'vertebra/base_runner'
rescue LoadError
  puts "Please install the thor and vertebra gems."
  exit
end

module Vertebra
  class VGem < BaseRunner
  
    @@global_method_options = {:node => :optional, :cluster => :required, :only_nodes => :boolean, :slice => :optional}
      
    def self.all_method_options(opts = {})
      self.method_options(@@global_method_options.merge(opts))
    end

    desc "list", "Get a list of gems"
    all_method_options :filter => :optional
    
    def list(opts = {})
      gems = broadcast('list', '/gem', opts)
      gems.each { |host, gems| puts "\n#{host}";puts "---"; puts gems.is_a?(Array) ? gems.join("\n") : gems }
    end

    desc "install <gem_name>", "Install a gem"
    all_method_options

    def install(gem_name, opts = {})
      result = broadcast('install', '/gem', opts.merge(:name => gem_name))
      puts result.inspect
    end

  end
end