require 'active_record'

module Notify
  class Delivery < ActiveRecord::Base
    self.table_name = 'notify_deliveries'

    belongs_to :receiver, polymorphic: true
    belongs_to :message, class_name: Message.name, foreign_key: :notify_message_id

    # Validations

    validates_presence_of :receiver

    # Scopes

    # Scopes that are based on Message strategy
    scope :visible, -> { joins(:message).where( "#{Notify::Message.table_name}" => { visible: true }) }
    scope :invisible, -> { joins(:message).where( "#{Notify::Message.table_name}" => { visible: false }) }

    delegate :notification, to: :message
    delegate :strategy, to: :message

    # Public. Call when the message is delivered. This
    # method will save the record and return the instance.
    def mark_as_delivered!
      self.update_attributes!(delivered_at: Time.zone.now)
      self
    end

    # Public. Call when the message has been confirmed as
    # received by the receiver. This method will save the record
    # and return the instance.
    def mark_as_received!
      self.update_attributes!(delivered_at: Time.zone.now)
      self
    end

  end
end
