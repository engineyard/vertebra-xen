Gem::Specification.new do |s|
  s.name = %q{dot_xen}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Corey Donohoe"]
  s.autorequire = %q{dot_xen}
  s.date = %q{2008-06-28}
  s.description = %q{A gem that provides reading and writing utils for xen config files.  It's also a really simple use of treetop}
  s.email = %q{atmos@atmos.org}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/dot_xen.rb", "lib/xen", "lib/xen/ast.rb", "lib/xen/xen_config_file_you_shouldnt_use.treetop", "lib/xen/xen_config_file_you_shouldnt_use_node_classes.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://atmos.org}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.2.0}
  s.summary = %q{A gem that provides reading and writing utils for xen config files.  It's also a really simple use of treetop}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if current_version >= 3 then
      s.add_runtime_dependency(%q<treetop>, [">= 0"])
    else
      s.add_dependency(%q<treetop>, [">= 0"])
    end
  else
    s.add_dependency(%q<treetop>, [">= 0"])
  end
end
