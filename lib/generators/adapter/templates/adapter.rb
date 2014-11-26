require 'notify'

module ::Notify::Adapter
  class <%= adapter_name.classify %>

    def deliver(delivery, options={})
      # Adapt the delivery object, which references both the notification and
      # the receiver to the protocol of the service this adapter is for.
    end

  end
end
