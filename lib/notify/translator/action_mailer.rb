module Notify::Translator

  #
  # Platform options
  #   - mailer - The name or class of the mailer to use. If a name is provided, only
  #              including the part of the name that doesn't include "Mailer" is
  #              necessary. Similar to Rails routing, the action can also be specified
  #              using a hash to separate the mailer name from the mailer method.
  #              Examples:
  #                - "foo". Calls: FooMailer.<notification type name>
  #                - "foo#bar". Calls: FooMailer.bar
  class ActionMailer

    # TODO: switch delivery translators to receive the user and the notification
    # (or a presenter) instead of the delivery object.

    def deliver(delivery, options={})
      options.symbolize_keys!

      # TODO: move parsing out the mailer to the NotificationType object.
      # This will give us the ability to stay out of the notif object during
      # translation, and allow us to raise an error early on if the mailer
      # doesn't exist.
      method_name = nil
      mailer = case options[:mailer]
      when Class then options[:mailer]
      when String, Symbol
        segments = options[:mailer].to_s.split("#")
        method_name = segments[1]
        mailer_class(segments[0])
      else
        raise TranslatorError, "#{options[:mailer]} is not a valid mailer"
      end

      method_name ||= delivery.notification.type
      mail = mailer.send method_name, delivery.receiver, delivery.notification

      mail.deliver!
    end

    private def mailer_class(name)
      name = name.to_s.classify
      "#{name.classify}Mailer".safe_constantize ||
      "#{name.classify}".safe_constantize
    end
  end
end
