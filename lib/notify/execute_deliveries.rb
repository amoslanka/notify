module Notify
  # A service object. Its task is to send each specific delivery through the
  # delivery process.
  class ExecuteDeliveries

    # Options
    #   message - Required. The message instance.
    #   ruleset - Optional. A ruleset containing delivery options to be passed
    #             on to the service adapters.
    #
    # Any error raised while creating deliveries will be allowed to bubble up.
    #
    # ROADMAP:
    #   - batches for some delivery platforms.
    #   - built in adaptation for background queueing
    def call options={}
      options.symbolize_keys!
      message = options.delete :message
      ruleset = options.delete(:ruleset) || {}

      raise ArgumentError, 'A message is required' if message.blank?

      if message.deliver_via.empty?
        raise AdapterError, "The given message has no delivery platforms"
      end

      adapters = message.deliver_via.collect do |name|
        unless adapter_class = Notify.adapter(name)
          raise AdapterError, "Could not find a platform adapter for #{name}"
        end
        adapter = adapter_class.new
        unless adapter.respond_to? :deliver
          raise AdapterError, "The #{adapter.class} adapter does not respond to #deliver"
        end
        [name, adapter]
      end
      adapters = adapters.to_h

      # Deliver to each person on each platform.
      message.deliveries.find_each do |delivery|

        # TODO
        # What to do if 1 adapter succeeds but the others dont?
        # What to do if no adapters succeed?
        #  - when to mark as delivered
        #  - when to mark for retry
        #  - how to mark the current try

        failures = {}

        adapters.each do |adapter_name, adapter|
          begin
            adapter.deliver delivery, ruleset.to_h
          rescue StandardError => e

            # TODO: Problem: this rescue will hide any errors. Perhaps
            # we should only be rescuring certain types of errors

            failures[adapter] = e
            Notify.logger.warn "Adapter failed to deliver message. adapter=#{adapter_name} message_id=#{message.id} delivery_id=#{delivery.id}"
          end
        end

        # Mark it as delivered if any of the adapters succeeded.
        if failures.count < adapters.count
          delivery.mark_as_delivered!
        end

      end

      true
    end
   end
end
