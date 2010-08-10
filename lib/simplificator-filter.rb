modules = ['Filterable', 'Orderable']

# Load all modules
modules.each do |strategy|
  Dir.glob(File.join(File.dirname(__FILE__), 'simplificator_filter', strategy.downcase, '*.rb')).each {|file| require file}
end

# Add extensions to scope
modules.each do |strategy|
  ActiveRecord::NamedScope::Scope.instance_eval do
    include strategy.constantize::Scope
  end
end
