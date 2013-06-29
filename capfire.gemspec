# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "capfire"
  s.version = "0.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["pjaspers", "atog", "tylerjohnst", "ravbaker"]
  s.date = "2013-06-29"
  s.description = "Send a notification to Campfire after a Capistrano cap deploy. It's also possible to send notification before."
  s.email = "ravbaker@gmail.com"
  s.extra_rdoc_files = [
    "LICENSE",
    "README.markdown"
  ]
  s.files = [
    "Gemfile",
    "Gemfile.lock",
    "LICENSE",
    "README.markdown",
    "Rakefile",
    "VERSION",
    "lib/capfire.rb",
    "lib/capfire/capistrano.rb"
  ]
  s.homepage = "http://github.com/RaVbaker/capfire"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.25"
  s.summary = "Send a notification to Campfire after a Capistrano cap deploy"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jeweler>, [">= 0"])
      s.add_runtime_dependency(%q<broach>, [">= 0.2.1"])
    else
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<broach>, [">= 0.2.1"])
    end
  else
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<broach>, [">= 0.2.1"])
  end
end

