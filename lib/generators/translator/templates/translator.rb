require 'notify'

module ::Notify::Translator
  class <%= translator_name.classify %>

    def deliver(delivery, options={})
      # Translate the delivery, which references both the notification and
      # the receiver into the protocol of the service this translator is for.
    end

  end
end
