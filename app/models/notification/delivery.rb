class Notification::Delivery < ActiveRecord::Base

  belongs_to :receiver, polymorphic: true
  belongs_to :notification

  validates_presence_of :receiver

  # Public. Call when the notification is delivered. This
  # method will save the record and return the instance.
  def mark_as_delivered!
    self.update_attributes!(delivered_at: Time.zone.now)
    self
  end

  # Public. Call when the notification has been confirmed as
  # received by the receiver. This method will save the record
  # and return the instance.
  def mark_as_received!
    self.update_attributes!(delivered_at: Time.zone.now)
    self
  end

end
