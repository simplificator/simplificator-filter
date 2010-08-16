# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{simplificator-filter}
  s.version = "0.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alessandro Di Maria", "Pascal Betz"]
  s.date = %q{2010-08-09}
  s.description = %q{An attempt to generalize filtering of AR objects}
  s.email = %q{info@simplificator.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "init.rb",
     "test/models.rb",
     "test/simplificator_filter_test.rb",
     "test/test_helper.rb",
     "test/unit/associations_test.rb",
     "test/unit/default_filters_test.rb",
     "test/unit/filter_parameters_test.rb",
     "test/unit/filterable_test.rb"
  ]
  s.homepage = %q{http://github.com/simplificator/simplificator-filter}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{An attempt to generalize filtering of AR objects}
  s.test_files = [
    "test/models.rb",
     "test/simplificator_filter_test.rb",
     "test/test_helper.rb",
     "test/unit/associations_test.rb",
     "test/unit/default_filters_test.rb",
     "test/unit/filter_parameters_test.rb",
     "test/unit/filterable_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 2.11"])
      s.add_development_dependency(%q<redgreen>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 2.0.0"])
      s.add_runtime_dependency(%q<context_aware_scope>, [">= 0.0.3"])
    else
      s.add_dependency(%q<shoulda>, [">= 2.11"])
      s.add_dependency(%q<redgreen>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 2.0.0"])
      s.add_dependency(%q<context_aware_scope>, [">= 0.0.3"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 2.11"])
    s.add_dependency(%q<redgreen>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 2.0.0"])
    s.add_dependency(%q<context_aware_scope>, [">= 0.0.3"])
  end
end

