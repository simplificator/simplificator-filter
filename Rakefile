require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "simplificator-filter"
    gem.summary = %Q{An attempt to generalize filtering of AR objects}
    gem.description = %Q{An attempt to generalize filtering of AR objects}
    gem.email = "info@simplificator.com"
    gem.homepage = "http://github.com/simplificator/simplificator-filter"
    gem.authors = ["Alessandro Di Maria", "Pascal Betz", "Fabio Kuhn"]
    gem.add_development_dependency "shoulda", ">= 2.11"
    gem.add_development_dependency "redgreen"
    gem.add_development_dependency 'sqlite3-ruby', '>=1.2.5'
    gem.add_development_dependency 'mysql'
    gem.add_dependency "activerecord", ">= 2.0.0"
    # gem.add_dependency "context_aware_scope", "~> 0.1.0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'test'
    test.pattern = 'test/**/*_test.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "simplificator-filter #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
