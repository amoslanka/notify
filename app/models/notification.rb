class Notification < ActiveRecord::Base
  RULESET_ATTRIBUTES = %w(deliver_via visible policy)
  self.inheritance_column = :_disabled

  has_many :deliveries
  belongs_to :activity, polymorphic: true

  validates_presence_of :type

  attr_accessor :ruleset

  serialize :deliver_via, Array


  def deliver_via=(val)
    write_attribute :deliver_via, Array(val)
  end

  # Retrieve all the ruleset attributes as a ruleset object.
  def ruleset
    RULESET_ATTRIBUTES.collect{ |r| [r, self.send(r)] }.to_hash
  end

  # Assign the ruleset values as a group. Delegates to #attributes=
  # method, so behavior should follow suite.
  def ruleset=val
    self.attributes = val.slice(*RULESET_ATTRIBUTES)
  end

end
