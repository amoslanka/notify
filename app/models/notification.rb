class Notification < ActiveRecord::Base
  RULESET_ATTRIBUTES = %w(deliver_via visible policy)
  self.inheritance_column = :_disabled

  has_many :deliveries

  validates_presence_of :type

  attr_accessor :to, :ruleset
end
