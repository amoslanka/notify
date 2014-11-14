require 'rails'
require 'active_support/dependencies'

require 'notify/engine'
require 'notify/notification_type'
require 'notify/notification_type_dsl'

module Notify

  # The logger used by Notify
  mattr_accessor :logger
  @@logger = Rails.logger

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
  def self.type name
    @@types[name.to_sym]
  end

  # Reloads all notification type configurations
  def self.reload!
    @@types = {}
    # Load all notification type configuration files
    files = @@load_paths.flatten.compact.uniq.map{ |path| Dir["#{path}/**/*.rb"] }.flatten
    files.each{ |file| load file }
  end

end

