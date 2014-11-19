module Support
  module RegisterNotification

    def register_notification type_name

      Notify.register_notification do
        name type_name
      end

    end

  end

  RSpec.configure do |config|
    config.include RegisterNotification
  end
end
