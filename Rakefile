
begin
  require 'rubygems'
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "timezone_local"
    gemspec.summary = "Determine the local system's time zone"
    gemspec.description = ""
    gemspec.email = "chetan@pixelcop.net"
    gemspec.homepage = "http://github.com/chetan/timezone_local"
    gemspec.authors = ["Chetan Sarva"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install jeweler"
end

require "rake/testtask"
desc "Run unit tests"
Rake::TestTask.new("test") { |t|
    #t.libs << "test"
    t.ruby_opts << "-rubygems"
    t.pattern = "test/**/*_test.rb"
    t.verbose = false
    t.warning = false
}

require "yard"
YARD::Rake::YardocTask.new("docs") do |t|
end
