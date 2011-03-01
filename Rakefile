require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "static_list"
  gem.homepage = "http://github.com/novelys/static_list"
  gem.license = "MIT"
  gem.summary = %q{This gem is very useful to handle static lists (like enumerations).}
  gem.description = %q{
    In your application you may want to handle things in your User model like sex (female, male) or other static lists.
    You want these lists to be handled using 'textual keys' in your application but stored in your database using codes in an integer column.
  }
  gem.email = "yann.klis@novelys.com"
  gem.authors = ["Yann Klis"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
  gem.add_runtime_dependency 'active_support', '>= 2.3.4'
end
Jeweler::RubygemsDotOrgTasks.new

require "rspec"
require "rspec/core/rake_task"

Rspec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = "spec/**/*_spec.rb"
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "static_list #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

