#
# The definition file for a <%= notification_name.humanize %> notification.
# Create one of these notifications using
#
#   user.notify "<%= notification_name %>"
#
# or
#
#   <%= notification_name.classify %>.send_for user
#
# A number of configurations are available to customize the definition of
# this type of notification. All notifications that are created rely on
# three tiers of configuration. Healthy global defaults are available which
# you can customize yourself. But different notifications have different
# behaviors and this is one of the main goals of Notify. The definition of
# the notification in this class can be very specific to what is best for
# rendering and delivering this type of notification. Finally, the `user.notify`
# method will override any definitions here, allowing for a final tier of
# notification delivery configuration.
#
class <%= notification_name.classify %>Notification
  extend Notify::Strategy

  # The delivery platforms this notification should use. The fallback
  # will be the default list of all platforms.
  self.deliver_via = :action_mailer

  # The mailer that will be used if delivering via ActionMailer. Specify
  # the mailer name (and the action will be inferred from the notification
  # type) or specify the whole thing with 'foo#bar'. Without a specified
  # mailer, Notify defaultly tries to send the email to the NotificationsMailer.
  self.mailer = :user_lifecycle

  # The number of times to retry failed notifications. Default is 5.
  # retry 5

  # Whether this notification will be visible in a notifications feed for
  # the receiver model. Default is true.
  self.visible = true
end
