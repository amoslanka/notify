module Notify
  #
  # The base for any notification class. Extend this module with your
  # notification classes defined in app/notifications.
  #
  # Example:
  #   class FooNotification
  #     extend Notify::Notification
  #     # ...
  #   end
  #
  module Notification

    autoload :Deliverer, 'notify/notification/deliverer'
    autoload :Factory,   'notify/notification/factory'
    autoload :Renderer, 'notify/notification/renderer'

    def self.extended(obj)
      obj.class_eval do
        include InstanceMethods

        class <<self
          # Make all the rule attributes into cvars. Retrieving or setting strategy
          # rules on the class is the way to define the strategy for this
          # notification type.
          attr_accessor *Strategy::RULES
        end

        # Make all rule attributes into getters. Getting from the instance Strategy
        # will be retrieving the rule after all rule flattening has occured.
        Strategy::RULES.each do |rule|
          delegate rule, to: :strategy
        end
      end
    end

    # The identifier with which to refer to this notification. It is derived from
    # the name of the class.
    def id
      self.name.demodulize.gsub(/Notification$/, '').underscore.to_sym
    end

    #
    # Create and return a strategy ruleset for this class. Creates a merged
    # strategy with convenience, and any hash values passed in will be merged
    # intothe returned ruleset, presuming them to be of a higher priority than
    # the global or notification class strategies.
    def strategy rules={}
      Strategy.from_notification self, rules
    end

    # The factory delegate is given the work of creating a notification. It
    # flattens the strategies and creates the persisted records for the
    # message and deliveries.
    def factory
      @@factory ||= Factory.new(self)
    end

    # Manually set the factory your notification prefers to use.
    def factory=(val)
      @@factory = val
    end

    # The deliverer delegate is responsible of delivering the messages after
    # they've been created.
    def deliverer
      @@deliverer ||= Deliverer
    end

    # Manually set the deliverer your notifications should use.
    def deliverer=(val)
      @@deliverer = val
    end

    #
    # Create a notification and deliver it to the specified receivers. This method
    # is the central access point to sending a notification of this class. Three
    # layers of rulesets are merged together here to finalize the ruleset to be used
    # for the created message and deliveries, in order of highest priority: immediate
    # strategy defined in the call to create, the strategy configurations specified
    # in the extended class, and finally, the global default strategy.
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
    # See `Strategy::RULES`. Any strategy rule can be passed as an option and will
    # take precedence over the same options set higher up the precedence chain.
    #
    # This method specifically uses factory files for creating the data and delivering
    # the data so that those factories can be customized in the app.
    def create receivers, config={}
      send_to_deliverer = config.delete :deliver
      notification = factory.create receivers, config
      notification.deliver unless send_to_deliverer == false
    end
    alias_method :create_for, :create


    module InstanceMethods

      # Instantiate a notification instance.
      def initialize message
        self.message = message
      end

      attr_accessor :message

      # Deliver the notification. Use the class's deliverer by default,
      # but passing a delegate object allows delivery through any object
      # that responds to `call` and expecting the notification as the
      # argument.
      def deliver(delegate=nil)
        delegate ||= self.class.deliverer
        delegate.call self
      end

      # An instance of a notification delegates the retrieval of its strategy
      # back through the message instance.
      delegate :strategy, to: :message

    end

  end
end
