require 'rails'
require 'active_support/dependencies'
require 'notify/engine'
require 'notify/errors'

module Notify

  autoload :CreateDeliveries,    'notify/create_deliveries'
  autoload :ExecuteDeliveries,   'notify/execute_deliveries'
  autoload :NotificationType,    'notify/notification_type'
  autoload :Receiver,            'notify/receiver'
  autoload :Ruleset,             'notify/ruleset'
  autoload :Translator,          'notify/translator'

  # The logger used by Notify
  mattr_accessor :logger
  @@logger = Rails.logger || Logger.new(nil)


  ###
  # Lookups
  ###

  # Finds a notification type model by the name provided.
  def self.notification_type name
    name = name.to_s.classify
    "#{name}Notification".safe_constantize
  end

  # Finds the translator class by name. Tries a few class names
  # the name may have been derived from.
  def self.translator(name)
    name = name.to_s.camelize
    "Notify::Translator::#{name}".safe_constantize ||
    "Translator::#{name}".safe_constantize ||
    "#{name}Translator".safe_constantize ||
    name.safe_constantize
  end


  ###
  # Primary Actions
  ###

  #
  # Create the specified notification to the specified receivers. This
  # method is the central access point to sending a notification. Three layers
  # of rulesets are merged together here to finalize the ruleset to be used
  # for the created notification, in order of highest priority: immediate config
  # defined in the call to create, notification type config, global default config.
  #
  def self.create type_id, config={}
    config.symbolize_keys!
    to = config.delete(:to)
    raise ArgumentError, "type argument is required" if type_id.blank?

    # Find the notification configuration.
    type_definition = type_id.is_a?(NotificationType) ? NotificationType : notification_type(type_id)
    raise ArgumentError, "could not find a notification definition for #{type_id}" unless type_definition

    # Flatten the rules and hold them in a ruleset.
    ruleset = global_config.merge(type_definition.ruleset).merge(config)

    # Create the notification
    notification = Notification.create! type: type_definition.id, ruleset: ruleset

    # Create the deliveries
    CreateDeliveries.new.call(notification: notification, to: to)

    # Execute the deliveries
    ExecuteDeliveries.new.call(notification: notification, ruleset: ruleset)

    notification
  end

  def self.global_config
    # TODO: make this customizeable
    Ruleset.new deliver_via: [], visible: true, mailer: :notifications
  end

end
