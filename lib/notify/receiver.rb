module Notify
  # Include this module in the class of whatever will be the receiver of
  # notifications. Including this modules adds helpful methods to the receiver
  # class that will make sending and receiving notifications easier.
  module Receiver
    extend ActiveSupport::Concern

    included do
      has_many :notify_deliveries, as: :receiver
      has_many :notify_messages, through: :notify_deliveries, source: :message
    end

    # Public. Create a notification for this user.
    def notify notification_name, rules={}
      Notify.notification(notification_name).create(self, rules)
    end

  end
end
