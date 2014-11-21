Notify.register_notification do

  # Name your notifications in line with the filename and directory they
  # live in. You can create one of these notifications using
  #     user.notify "<%= notification_name %>"
  name "<%= notification_name %>"

  # The delivery platforms this notification should use. The fallback
  # will be the default list of all platforms.
  # deliver_via :action_mailer

  # The mailer that will be used if delivering via ActionMailer. Specify
  # the mailer name (and the action will be inferred from the notification
  # type) or specify the whole thing with 'foo#bar'. Without a specified
  # mailer, Notify defaultly tries to send the email to the NotificationsMailer.
  # mailer :notifications

  # The number of times to retry failed notifications. Default is 5.
  # retry 5

  # Whether this notification will be visible in a notifications feed for
  # the receiver model. Default is true.
  # visible true

end
