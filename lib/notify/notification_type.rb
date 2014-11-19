module Notify
  class NotificationType
    RULE_ATTRIBUTES = %w(deliver_via visible retry)

    attr_accessor :name, :deliver_via, :visible, :retry

    # Validate the settings on notification type.
    def validate!
      raise Exception, 'a name must be provided for the notification type' if @name.blank?
    end

    # Create a ruleset from the config options in for this type.
    # Creates a new instance on every request to avoid unintentionally
    # writing rules to the global config for this type.
    def ruleset
      Ruleset.new RULE_ATTRIBUTES.collect{ |r| [r, self.send(r)] }.to_h
    end

  end
end
