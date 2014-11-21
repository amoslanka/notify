module Notify
  # A service object. Its task is to handle the receiver list when a notification
  # is created in the most efficient way possible, creating delivery records for
  # each receiver.
  class CreateDeliveries

    # Options
    #   notification - Required. The notification instance.
    #   to           - Required. The list of receivers or an instance of one. Most
    #                  efficient if passed as an ActiveRecord::Relation object.
    #
    # Any error raised while creating deliveries will be allowed to bubble up.
    def call options={}
      options.symbolize_keys!
      notification = options.delete :notification
      raise ArgumentError, 'A notification is required' if notification.blank?
      raise ArgumentError, 'A list of receivers is required' if options[:to].blank?

      delivery_count = 0

      ActiveRecord::Base.transaction do

        # Loop the receivers and create a delivery.
        each options[:to] do |receiver|
          delivery = Notification::Delivery.new notification: notification

          # ! This doesn't always have to stay this way, but for now we're only
          # ! going to associate notifications to ActiveRecord objects.
          # At some point, we could just as easily associate it to any object.
          # Say for instance you give it a string thats a receiver. Maybe the
          # implementer would like to assume that notifying a string assumes that
          # that string is the name of a pubsub channel.
          unless receiver.is_a? ::ActiveRecord::Base
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

    # Private. Loops the items in the most efficient way depending on what class
    # items is, and yields the block with each.
    private def each items, &block
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
