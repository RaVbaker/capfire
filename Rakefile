require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "capfire"
    gem.summary = %Q{Send a notification to Campfire after a Capistrano cap deploy}
    gem.description = %Q{Send a notification to Campfire after a Capistrano cap deploy. It's also possible to send notification before.}
    gem.email = "ravbaker@gmail.com"
    gem.homepage = "http://github.com/RaVbaker/capfire"
    gem.authors = ["pjaspers", "atog", "tylerjohnst", "ravbaker"]
    gem.files = FileList['[A-Z]*',
      'lib/**/*.rb',
      'lib/templates/*.erb']
    gem.add_dependency('broach', '>= 0.2.1')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end
