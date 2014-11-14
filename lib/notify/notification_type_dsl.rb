module Notify
  class NotificationTypeDsl
    attr_reader :notification

    def initialize
      @notification = NotificationType.new
    end

    # Set the name for the notification type.
    def name(val)
      @notification.name = val
    end

    def deliver_via(platforms)
      @notification.deliver_via = platforms
    end

    def retry(val)
      @notification.retry = val
    end

    def visible(val)
      @notification.visible = val
    end
  end
end
