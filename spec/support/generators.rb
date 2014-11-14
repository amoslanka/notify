
RSpec.configure do |config|

  config.before :each, type: :generator do
    destination File.expand_path("../../../../tmp/generated", __FILE__)
    prepare_destination
  end

end
