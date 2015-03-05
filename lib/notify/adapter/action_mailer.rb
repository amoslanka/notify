require 'action_mailer'

module Notify::Adapter
  #
  # Platform options
  #   - mailer - The name or class of the mailer to use. If a name is provided, only
  #              including the part of the name that doesn't include "Mailer" is
  #              necessary. Similar to Rails routing, the action can also be specified
  #              using a hash to separate the mailer name from the mailer method.
  #              Examples:
  #                - "foo". Calls: FooMailer.<strategy name>
  #                - "foo#bar". Calls: FooMailer.bar
  class ActionMailer

    # TODO: switch service adapters to receive the user and the notification
    # (or a presenter) instead of the delivery object.

    def deliver(delivery, strategy)

      # TODO: move parsing out the mailer to the Strategy object.
      # This will give us the ability to stay out of the notif object during
      # adaptation, and allow us to raise an error early on if the mailer
      # doesn't exist.

      method_name = nil
      mailer = case strategy.mailer
      when Class then strategy.mailer
      when String, Symbol
        segments = strategy.mailer.to_s.split("#")
        method_name = segments[1]
        mailer_class(segments[0])
      else
        raise AdapterError, "#{strategy.mailer} is not a valid mailer"
      end

      method_name ||= delivery.notification.class.id
      mail = mailer.send method_name, delivery.receiver, delivery.message

      mail.deliver!
    end

    private

    def mailer_class(name)
      name = name.to_s.classify
      "#{name.classify}Mailer".safe_constantize ||
      "#{name.classify}".safe_constantize
    end
  end
end
