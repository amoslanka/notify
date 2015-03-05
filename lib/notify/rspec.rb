module Notify
  module RSpec
    # A set of RSpec matchers to use with Notify.
    module Matchers

      # Stubs notifications for the given instance.
      def stub_notifications_for(instance)
        allow(instance).to receive(:notify)
      end

      # Unstubs notifications for the given instance.
      def unstub_notifications_for(instance)
        allow(instance).to receive(:notify).and_call_original
      end

      #
      # Matches that a notification was created.
      #
      # Options:
      #
      # name     - The name of the notification that should have been created.
      # to       - The receiver object(s) that should be assigned as receivers.
      # activity - The activity object that should be assigned to the message.
      #
      # TODO: Support any Strategy rule to be passed as an option.
      #
      def send_notification(name, options={})
        SendNotificationMatcher.new self, name, options
      end

      # @private
      class SendNotificationMatcher
        def supports_block_expectations?; true; end

        def initialize(context, name, options={})
          options.symbolize_keys!
          @context = context
          @name = name
          @receivers = Array(options.delete :receivers)
          @activity = options.delete :activity
          @errors = []
        end

        def matches? block_to_test

          unless notification_class = Notify.notification(@name)
            @errors << "Could not find a notification with the name #{@name}"
            return false
          end

          arg1 = @receivers.any? ? @receivers : @context.anything
          arg2 = {}
          arg2[:activity] = @activity

          message_ids = Message.pluck(:id)

          block_to_test.call

          unless Message.count > message_ids.size
            @errors << "A Notify::Message was not created."
            return false
          end

          # Find the created message.
          unless message = Message.where.not(id: message_ids).where(notification_name: @name)
            @errors << "A #{@name} notification was not created."
            return false
          end

          # Make sure it went to the right receivers
          if @receivers.any?
            deliveries = message.deliveries
            failed_receivers = @receivers.select do |receiver|
              deliveries.find_by(receiver: receiver).nil?
            end
            if failed_receivers.any?
              @errors << "Not all receivers received the notification."
              failed_receivers.each { |r| @errors << "  #{r}" }
              return false
            end

            # TODO: this does not match receivers who should not be in the list
          end

          # Activity match
          if @activity && message.activity != @activity
            @errors << "The activity #{@activity} does not match the message activity #{message.activity}"
            return false
          end

          # begin
          #   @context.expect(notification_class).
          #     to @context.receive(:create).with(arg1, arg2)
          #   block_to_test.call

          # rescue ::RSpec::Expectations::ExpectationNotMetError => e
          #   require 'pry'; binding.pry
          # rescue ::RSpec::Mocks::MockExpectationError => e
          #   require 'pry'; binding.pry
          # end
          true
        end

        def description
          str = "sends a #{@name} notification"
          str += " to #{@receivers}" if @receivers.any?
          str += " with #{@activity} activity" if @activity
          str
        end

        def failure_message
          @errors.join("\n")
        end

        def failure_message_when_negated
          "Expected to not send a #{@name} notification"
        end
      end
    end
  end
end
