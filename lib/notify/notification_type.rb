module Notify
  #
  # The base for any notification declaration. Extend this module with your
  # notification class.
  #
  # Example:
  #   class FooNotification
  #     extend Notify::NotificationType
  #     # ...
  #   end
  #
  module NotificationType
    RULE_ATTRIBUTES = %w(deliver_via mailer visible retry)

    # When extended, we register this type with Notify.
    def self.extended(obj)
      obj.class_eval do
        class <<self
          # Make all the rule attributes into cvars.
          attr_accessor *RULE_ATTRIBUTES
        end
      end
    end

    # The identifier with which to refer to this notification. It is
    # derived from the name of the class.
    def id
      self.name.demodulize.gsub(/Notification$/, '').underscore.to_sym
    end

    # Validate the settings on notification type.
    def validate!
    end

    # Create a ruleset from the config options in for this type.
    # Creates a new instance on every request to avoid unintentionally
    # writing rules to the global config for this type.
    def ruleset
      Ruleset.new RULE_ATTRIBUTES.collect{ |r| [r, self.send(r)] }.to_h
    end

  end
end
