require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'spec'
require 'spec/rake/spectask'
require 'date'

GEM = "dot_xen"
GEM_VERSION = "0.0.1"
AUTHOR = "Corey Donohoe"
EMAIL = "atmos@atmos.org"
HOMEPAGE = "http://atmos.org"
SUMMARY = "A gem that provides reading and writing utils for xen config files.  It's also a really simple use of treetop"

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", 'TODO']
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE
  
  # Uncomment this to add a dependency
  s.add_dependency "treetop"
  
  s.require_path = 'lib'
  s.autorequire = GEM
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,specs}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

task :default => ['spec:run']
namespace :spec do
  Spec::Rake::SpecTask.new('run') do |t|
    t.spec_files = FileList['spec/**/**/*.rb']
  end
  
  desc "Generate specdocs for examples for inclusion in RDoc"
  Spec::Rake::SpecTask.new('doc') do |t|
    t.spec_files = FileList['spec/**/**/*.rb']
    t.spec_opts = ["--format", "specdoc"]
  end
end

namespace :spec do
  desc "Run unit specifications"
  Spec::Rake::SpecTask.new(:unit) do |t|
    t.spec_opts << '--format' << 'specdoc' << '--colour'
    t.spec_opts << '--loadby' << 'random'
    t.spec_files = %w(units).collect { |dir| Dir["spec/#{dir}/**/*_spec.rb"] }.flatten
    t.rcov = ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true
    t.rcov_opts << '--exclude' << 'spec,'
    t.rcov_opts << '--text-summary'
    t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
    t.rcov_opts << '--only-uncovered'
  end

  desc "Run integration specifications"
  Spec::Rake::SpecTask.new(:integration) do |t|
    t.spec_opts << '--format' << 'specdoc' << '--colour'
    t.spec_opts << '--loadby' << 'random'
    t.rcov = ENV.has_key?('NO_RCOV') ? ENV['NO_RCOV'] != 'true' : true
    t.spec_files = File.dirname(__FILE__) + '/spec/integrations/**/*_spec.rb'
    t.rcov_opts << '--exclude' << 'spec,'
    t.rcov_opts << '--text-summary'
    t.rcov_opts << '--sort' << 'coverage' << '--sort-reverse'
    t.rcov_opts << '--only-uncovered'
  end
end