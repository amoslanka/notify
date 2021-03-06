require 'active_record'

module Notify
  class Message < ActiveRecord::Base
    self.table_name = 'notify_messages'
    STRATEGY_ATTRIBUTES = %w(deliver_via visible)

    has_many :deliveries, class_name: "Notify::Delivery", foreign_key: :notify_message_id
    belongs_to :activity, polymorphic: true

    # Validations

    validates_presence_of :notification_name

    # Scopes

    scope :visible, -> { where visible: true }
    scope :invisible, -> { where visible: false }

    # Serializations

    serialize :deliver_via, JSON

    def deliver_via=(val)
      write_attribute :deliver_via, Array(val)
    end


    # A reference to the notification instance that can be used to more
    # collectively represent this message. If no instance has been assigned, it
    # will instantiate one after finding it from Notify.
    def notification
      @notification ||= Notify.notification(self.notification_name).new(self)
    end

    def notification=(val)
      @notification = val
    end

    # Compile the strategy attributes as a strategy object. Persisted attributes
    # are the highest priority values in a tier of rules to merge.
    def strategy
      attribs = Hash[STRATEGY_ATTRIBUTES.collect{ |r| [r, self.send(r)] }]
      notification.class.strategy attribs
    end

    # Assign the strategy values as a group. Delegates to #attributes=
    # method, so behavior should follow suite. Only official STRATEGY_ATTRIBUTES
    # attributes will be passed on and assigned.
    def strategy=val
      self.attributes = val.to_h.stringify_keys.slice(*STRATEGY_ATTRIBUTES)
    end

  end
end
