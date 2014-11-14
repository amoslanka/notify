$:.push File.expand_path("../lib", __FILE__)

require "notify/version"

Gem::Specification.new do |s|
  s.name        = "notify"
  s.version     = Notify::VERSION
  s.authors     = ["Amos Lanka"]
  s.email       = ["amoslanka@gmail.com"]
  s.homepage    = "https://github.com/amoslanka/notify"
  s.summary     = "A Rails Engine that seeks manages the data structure of your notification system and gives you a way to define what notifications you send and some rules about how or when they're sent."
  s.description = "Notify is a Rails Engine that seeks manages the data structure of your notification system and gives you a way to define what notifications you send and some rules about how or when they're sent. It doesn't deal with the views, delivery, or logic that says when to send them. Just the defined notification types and the data that links your users with things they're notified about."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.1.7"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'ammeter'
end
