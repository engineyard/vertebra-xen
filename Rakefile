require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'rake/testtask'
require "spec/rake/spectask"

GEM = "vertebra-xen"
GEM_VERSION = "0.3.1"
AUTHOR = "Engine Yard, Inc."
EMAIL = "vertebra-dev@googlegroups.com"
HOMEPAGE = "http://vertebra.engineyard.com"
SUMMARY = "Handle xen servers through vertebra"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'LICENSE', 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  s.executables = %w(vxen)
  
  s.add_dependency "thor"
  s.add_dependency "treetop"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,specs,vendor}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "uninstall the gem locally"
task :uninstall => [:package] do
  sh %{sudo gem uninstall #{GEM} -v #{GEM_VERSION} -I -x}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

desc "Run specs"
Spec::Rake::SpecTask.new("specs") do |t|
  t.spec_opts = ["--format", "specdoc", "--colour"]
  t.spec_files = FileList["spec/**/*_spec.rb"]
end
