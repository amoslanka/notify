module Notify
  class NotificationType

    attr_accessor :name, :deliver_via, :visible, :retry


    # Validate the settings on notification type.
    def validate!
      raise Exception, 'a name must be provided for the notification type' if @name.blank?
    end

  end
end
