require 'rails'
require 'active_support/dependencies'
require 'notify/engine'

module Notify

  autoload :CreateDeliveries,    'notify/create_deliveries'
  autoload :NotificationType,    'notify/notification_type'
  autoload :NotificationTypeDsl, 'notify/notification_type_dsl'
  autoload :Receiver,            'notify/receiver'
  autoload :Ruleset,             'notify/ruleset'

  # The logger used by Notify
  mattr_accessor :logger
  @@logger = Rails.logger || Logger.new(nil)

  # The list of all the notification types
  mattr_accessor :types

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

  # Reloads all notification type configurations
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
    raise ArgumentError, "to argument is required" if to.empty?

    # Find the type
    default_config = type.is_a?(NotificationType) ? NotificationType : notification_type(type)
    raise ArgumentError, "could not find notification type #{type}" unless default_config

    # Flatten the rules and hold them in a ruleset.
    ruleset = default_config.ruleset.merge(config)

    # Create the notification
    notification = Notification.create! type: default_config.name, ruleset: ruleset

    # Create the deliveries
    CreateDeliveries.new.call(notification: notification, to: to)

    notification
  end

end

