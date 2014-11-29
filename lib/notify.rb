require 'rails'
require 'active_support/dependencies'
require 'notify/engine'
require 'notify/errors'

module Notify

  autoload :Notification, 'notify/notification'
  autoload :Strategy,     'notify/strategy'
  autoload :Receiver,     'notify/receiver'
  autoload :Adapter,      'notify/adapter'

  #
  # The logger used by Notify
  mattr_accessor :logger
  @@logger = Rails.logger || Logger.new(nil)

  #
  # The global strategy. Easy to customize, by simply adding to the strategy:
  #
  #     Notify.strategy[:visible] = false
  #
  mattr_accessor :strategy
  @@strategy = Strategy.new(
    deliver_via: [:action_mailer],
    visible: true,
    mailer: :notifications
  )

  #
  # Finds a notification class by the name provided. Expects the class to already
  # be loaded or to be autoloadable. Accepts a submoduled name as well using
  # slash syntax.
  #
  # Examples:
  #   Notify.notification :foo
  #   # Will attempt to load FooNotification
  #
  #   Notify.notification 'foo/bar'
  #   # Will attempt to load Foo::BarNotification
  #
  # Returns the notification class or nil if the class is not found.
  def self.notification name
    name = name.to_s.classify
    "#{name}Notification".safe_constantize
  end

  #
  # Finds a adapter class by name. Tries a few class names the name may have been
  # derived from. Expects the class to already be loaded or autoloadable. Accepts
  # a submoduled name as well using slash syntax.
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
end
