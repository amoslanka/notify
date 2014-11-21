require 'rails'
require 'active_support/dependencies'
require 'notify/engine'
require 'notify/errors'

module Notify

  autoload :CreateDeliveries,    'notify/create_deliveries'
  autoload :ExecuteDeliveries,   'notify/execute_deliveries'
  autoload :NotificationType,    'notify/notification_type'
  autoload :NotificationTypeDsl, 'notify/notification_type_dsl'
  autoload :Receiver,            'notify/receiver'
  autoload :Ruleset,             'notify/ruleset'
  autoload :Translator,          'notify/translator'

  # The logger used by Notify
  mattr_accessor :logger
  @@logger = Rails.logger || Logger.new(nil)

  # The list of all the notification types
  mattr_accessor :types

  # The list of all delivery platforms
  mattr_accessor :platforms
  @@platforms = []

  # The load paths are where the notifications are stored in the app
  mattr_accessor :load_paths
  @@load_paths = [File.expand_path('app/notifications', Rails.root)]

  # Create a notification type by running the configuration block through the
  # notification type dsl. Stores the type in the list of types.
  def self.register_notification &block
    dsl = NotificationTypeDsl.new
    dsl.instance_eval &block
    notification = dsl.notification
    notification.validate!

    if @@types[notification.name.to_sym]
      logger.warn "Already declared a notification using the name #{notification.name.to_sym}"
    end

    @@types[notification.name.to_sym] = notification
  end

  # Finds a notification type model by the name provided.
  def self.notification_type name
    @@types[name.to_sym]
  end

  # Reloads all notification type and platform configurations
  def self.reload!
    @@types = {}
    # Load all notification type configuration files
    files = @@load_paths.flatten.compact.uniq.map{ |path| Dir["#{path}/**/*.rb"] }.flatten
    files.each{ |file| load file }
  end

  # Create the specified notification to the specified receivers. This
  # method is the central access point to sending a notification.
  def self.create type, config={}
    config.symbolize_keys!
    to = config.delete(:to)
    raise ArgumentError, "type argument is required" if type.blank?

    # Find the type
    type_config = type.is_a?(NotificationType) ? NotificationType : notification_type(type)
    raise ArgumentError, "could not find notification type #{type}" unless type_config

    # Flatten the rules and hold them in a ruleset.
    ruleset = type_config.ruleset.merge(config)

    # TODO: make this customizeable
    default_config = {
      # Defaultly deliver to all platforms.
      deliver_via: @@types.keys,
      visible: true
    }
    # The baselines that we have to have but can assume standard defaults on.
    ruleset.reverse_merge! default_config

    # Create the notification
    notification = Notification.create! type: type_config.name, ruleset: ruleset

    # Create the deliveries
    CreateDeliveries.new.call(notification: notification, to: to)

    # Execute the deliveries
    ExecuteDeliveries.new.call(notification: notification, ruleset: ruleset)

    notification
  end

  # Define a delivery platform.
  def self.delivery_platform name
    @@platforms << name.to_sym
    @@platforms.uniq!
  end

end


Notify::Translator::ActionMailer
