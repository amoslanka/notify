module Notify
  module Notification
    #
    # Factory functionality that deals with instantiating a notification
    # and creating its consolidated strategy, message, and deliveries. A
    # Factory instance is owned by a notification class and instantiates
    # the notification on behalf of the notification.
    #
    class Factory
      attr_reader :notification_class

      def initialize(notification_class)
        @notification_class = notification_class
      end

      #
      # Create a notification. Creates the message record and delivery records.
      #
      # Returns an instance of the notification.
      def create(receivers, config={})
        activity = config.delete :activity

        unless activity.nil? || activity.is_a?(ActiveRecord::Base)
          raise ArgumentError, "activity must be an ActiveRecord object"
        end

        # Flatten the rules and hold them in a strategy object.
        strategy = self.notification_class.strategy(config)

        # Create the message
        message = Message.create! notification_name: self.notification_class.id,
          strategy: strategy,
          activity: activity

        # Create the deliveries
        create_deliveries(message: message, receivers: receivers)

        self.notification_class.new message
      end

      alias_method :send_to,    :create
      alias_method :create_for, :create

      private

      # Create the deliveries that join the message to each receiver.
      #
      # Options
      #   message   - Required. The message instance.
      #   receivers - Required. The list of receivers or an instance of one. Most
      #               efficient if passed as an ActiveRecord::Relation object.
      #
      # Any error raised while creating deliveries will be allowed to bubble up.
      def create_deliveries options={}
        options.symbolize_keys!
        message = options.delete :message
        raise ArgumentError, 'A message is required' if message.blank?
        raise ArgumentError, 'A list of receivers is required' if options[:receivers].blank?

        delivery_count = 0

        ActiveRecord::Base.transaction do

          # Loop the receivers and create a delivery.
          each options[:receivers] do |receiver|
            delivery = Delivery.new message: message

            # ! This doesn't always have to stay this way, but for now we're only
            # ! going to associate notifications to ActiveRecord objects.
            # At some point, we could just as easily associate it to any object.
            # Say for instance you give it a string thats a receiver. Maybe the
            # implementer would like to assume that notifying a string assumes that
            # that string is the name of a pubsub channel.
            unless receiver.is_a? ::ActiveRecord::Base

              # TODO: raise its own error instead, or keep track on a separate object,
              # so that validation errors can be untouched, left for end users.

              delivery.errors.add :receiver, "must be an ActiveRecord::Base instance"
              raise ::ActiveRecord::RecordInvalid, delivery
            end

            # Here we could also verify that the class of the receiver has included
            # the receiver module.

            delivery.receiver = receiver
            delivery.save!
            delivery_count += 1
          end
        end

        delivery_count
      end

      # Private. Loops the items in the most efficient way depending on what
      # class items is, and yields the block with each.
      def each items, &block
        if items.is_a?(::ActiveRecord::Relation)
          items.find_each do |item|
            block.yield item
          end
        else
          Array(items).each do |item|
            block.yield item
          end
        end
      end

    end
  end
end
