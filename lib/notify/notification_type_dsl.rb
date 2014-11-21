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

    ###
    # Configurations that are part of the persisted ruleset
    # These settings are stored on the notification object.
    ###
    def deliver_via(platforms)
      @notification.deliver_via = platforms
    end

    def retry(val)
      @notification.retry = val
    end

    def visible(val)
      @notification.visible = val
    end

    ###
    # Configurations that can be pulled from the type object when needed.
    ###

    # The name of the mailer to use if delivering using action mailer.
    # Possible formats:
    #   - 'foo' - Maps to FooMailer and infers the type name as the action.
    #   - 'foo#bar' - Maps to FooMailer.bar
    def mailer(val)
      @notification.mailer = val
    end

  end
end
