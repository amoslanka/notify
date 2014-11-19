ENV['RAILS_ENV'] ||= 'test'

# The dummy app
app_path = File.expand_path("../dummy", __FILE__)
$LOAD_PATH.unshift(app_path) unless $LOAD_PATH.include?(app_path)
require 'rails/all'
require 'config/environment'
require 'db/schema'
require 'rails/test_help'

# Rspec config
require 'rspec/rails'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
end


RSpec.configure do |config|
  config.before :each do
    Notify.reload!
  end
end
