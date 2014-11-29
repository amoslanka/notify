require 'rails'
require 'active_support/dependencies'
require 'notify/engine'
require 'notify/errors'

module Notify

  autoload :CreateDeliveries,    'notify/create_deliveries'
  autoload :ExecuteDeliveries,   'notify/execute_deliveries'
  autoload :Strategy,            'notify/strategy'
  autoload :Receiver,            'notify/receiver'
  autoload :Ruleset,             'notify/ruleset'
  autoload :Adapter,             'notify/adapter'

  # The logger used by Notify
  mattr_accessor :logger
  @@logger = Rails.logger || Logger.new(nil)

  ###
  # Lookups
  ###

  #
  # Finds a notification strategy model by the name provided. Expects the notification
  # class to already be loaded or to be autoloadable. Accepts a submoduled name as
  # well using slash syntax.
  #
  # Examples:
  #   Notify.strategy :foo
  #   # Will attempt to load FooNotification
  #
  #   Notify.strategy 'foo/bar'
  #   # Will attempt to load Foo::BarNotification
  #
  # Returns the notification class or nil if the class is not found.
  def self.strategy name
    name = name.to_s.classify
    "#{name}Notification".safe_constantize
  end

  #
  # Finds a adapter class by name. Tries a few class names the name may have been
  # derived from. Expects the class to already be loaded or autoloadable. Accepts a
  # submoduled name as well using slash syntax.
  #
  # Examples:
  #   Notify.adapter :foo
  #   # Will attempt to load Notify::Adapter::Foo
  #   #                   or FooAdapter
  #
  #   Notify.adapter 'foo/bar'
  #   # Will attempt to load Notify::Adapter::Foo::Bar
  #   #                   or Foo::BarAdapter
  #
  # Returns the notification class or nil if the class is not found.
  def self.adapter(name)
    name = name.to_s.camelize
    "Notify::Adapter::#{name}".safe_constantize ||
    "#{name}Adapter".safe_constantize
  end

  ###
  # Primary Actions
  ###

  #
  # Create a message using the specified notification strategy and deliver it to
  # the specified receivers. This method is the central access point to sending
  # a notification. Three layers of rulesets are merged together here to finalize
  # the ruleset to be used for the created notification, in order of highest
  # priority: immediate strategy defined in the call to create, notification
  # strategy file, global default strategy.
  #
  # Options:
  #
  # [to]        A list of receivers. Most efficient if passed as an ActiveRecord::Relation.
  #             Prefer to send a large list of receivers using a query instead of a
  #             loaded list. For example, send as `User.all` instead of `User.all.to_a`
  #             (Rails 4 returns a relation for the `all` method).
  # [activity]  The object that represents what this notification is about. If you send
  #             out notifications for announcements, store them in an announcements table
  #             and pass the announcement instance as the activity.
  #
  # Ruleset options:
  #
  # See `Notification::RULESET_ATTRIBUTES`. Any standard ruleset attribute can be passed as
  # a an option and will take precedence over all other ruleset configurations.
  #
  def self.create strategy_id, config={}
    config.symbolize_keys!
    to = config.delete(:to)
    raise ArgumentError, "strategy argument is required" if strategy_id.blank?

    # Find the strategy.
    strategy_class = strategy_id.is_a?(Strategy) ? Strategy : strategy(strategy_id)
    raise ArgumentError, "could not find a notification strategy for #{strategy_id}" unless strategy_class

    activity = config.delete :activity

    unless activity.nil? || activity.is_a?(ActiveRecord::Base)
      raise ArgumentError, "activity must be an ActiveRecord object"
    end

    # Flatten the rules and hold them in a ruleset.
    ruleset = global_strategy.merge(strategy_class.ruleset).merge(config)

    # Create the message
    message = Message.create! strategy: strategy_class.id, ruleset: ruleset, activity: activity

    # Create the deliveries
    CreateDeliveries.new.call(message: message, to: to)

    # Execute the deliveries
    ExecuteDeliveries.new.call(message: message, ruleset: ruleset)

    message
  end

  def self.global_strategy
    # TODO: make this customizeable
    Ruleset.new deliver_via: [], visible: true, mailer: :notifications
  end

end
