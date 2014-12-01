require 'active_record'

module Notify
  class Message < ActiveRecord::Base
    self.table_name = 'notify_messages'
    STRATEGY_ATTRIBUTES = %w(deliver_via visible)

    has_many :deliveries, class_name: Delivery.name, foreign_key: :notify_message_id
    belongs_to :activity, polymorphic: true

    validates_presence_of :notification_name

    serialize :deliver_via, Array

    def deliver_via=(val)
      write_attribute :deliver_via, Array(val)
    end


    # A reference to the notification instance that can be used to more
    # collectively represent this message. If no instance has been assigned, it
    # will instantiate one after finding it from Notify.
    def notification
      @notification ||= Notify.notification(self.notification).new(self)
    end

    def notification=(val)
      @notification = val
    end

    # Compile the strategy attributes as a strategy object. Persisted attributes
    # are the highest priority values in a tier of rules to merge.
    def strategy
      attribs = STRATEGY_ATTRIBUTES.collect{ |r| [r, self.send(r)] }.to_hash
      notification.class.strategy attribs
    end

    # Assign the strategy values as a group. Delegates to #attributes=
    # method, so behavior should follow suite. Only official STRATEGY_ATTRIBUTES
    # attributes will be passed on and assigned.
    def strategy=val
      self.attributes = val.to_hash.slice(*STRATEGY_ATTRIBUTES)
    end

  end
end
