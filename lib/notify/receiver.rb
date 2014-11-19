module Notify
  # A receiver of notifications. Including this modules adds helpful methods
  # to the including class that will make sending and receiving notifications
  # easier.
  module Receiver
    extend ActiveSupport::Concern

    included do
      has_many :notification_deliveries, as: :receiver
      has_many :notifications, through: :notification_deliveries
    end

    # Public. Create a notification for this user.
    def notify type, rules={}
      Notify.create type, rules.symbolize_keys.merge(to: self)
    end

  end
end
