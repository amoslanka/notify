module Notify
  # A service object. Its task is to send each specific delivery through the
  # delivery process.
  class ExecuteDeliveries

    # Options
    #   notification - Required. The notification instance.
    #   ruleset - Optional. A ruleset containing delivery options to be passed
    #             on to the delivery translators.
    #
    # Any error raised while creating deliveries will be allowed to bubble up.
    #
    # ROADMAP:
    #   - batches for some delivery platforms.
    #   - built in adaptation for background queueing
    def call options={}
      options.symbolize_keys!
      notification = options.delete :notification
      ruleset = options.delete(:ruleset) || {}

      raise ArgumentError, 'A notification is required' if notification.blank?

      if notification.deliver_via.empty?
        raise TranslatorError, "The given notification has no delivery platforms"
      end

      translators = notification.deliver_via.collect do |name|
        unless translator_class = Notify.translator(name)
          raise TranslatorError, "Could not find a platform translator for #{name}"
        end
        translator = translator_class.new
        unless translator.respond_to? :deliver
          raise TranslatorError, "The #{translator.class} translator does not respond to #deliver"
        end
        [name, translator]
      end
      translators = translators.to_h

      # Deliver to each person on each platform.
      notification.deliveries.find_each do |delivery|

        # TODO
        # What to do if 1 translator succeeds but the others dont?
        # What to do if no translators succeed?
        #  - when to mark as delivered
        #  - when to mark for retry
        #  - how to mark the current try

        failures = {}

        translators.each do |translator_name, translator|
          begin
            translator.deliver delivery, ruleset.to_h
          rescue StandardError => e

            # TODO: Problem: this rescue will hide any errors. Perhaps
            # we should only be rescuring certain types of errors

            failures[translator] = e
            Notify.logger.warn "Translator failed to deliver notification. translator=#{translator_name} notification_id=#{notification.id} delivery_id=#{delivery.id}"
          end
        end

        # Mark it as delivered if any of the translators succeeded.
        if failures.count < translators.count
          delivery.mark_as_delivered!
        end

      end

      true
    end
   end
end
