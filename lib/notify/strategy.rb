module Notify
  # A Strategy is a flattened group of rules for creation and delivery of a
  # notification. In this capacity, it represents a normalized set of rules that
  # can be passed around as a collection of rules.
  class Strategy < OpenStruct
    RULES = %w(deliver_via mailer visible)

    # Create a strategy from a notification class or notification instance.
    def self.from_notification(notification, rules={})
      notification_rules = RULES.collect{ |r| [r, notification.send(r)] }.to_h
      Notify.strategy.merge(notification_rules).merge(rules)
    end

    # Returns a new Strategy instance containing the contents of hash and itself
    # merged together. Any pairs with a nil value will be ignored.
    def merge(hash)
      Strategy.new self.to_h.merge(hash.delete_if{ |k,v| v.nil?}.symbolize_keys)
    end

  end
end
