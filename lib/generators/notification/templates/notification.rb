Notify.register_notification do

  # Name your notifications in line with the filename and directory they
  # live in. You can create one of these notifications using
  #     user.notify "<%= notification_name %>"
  name "<%= notification_name %>"

  # The delivery platforms this notification should use. The fallback
  # will be the default list of all platforms.
  # deliver_via :email

  # The number of times to retry failed notifications. Default is 5.
  # retry 5

  # Whether this notification will be visible in a notifications feed for
  # the receiver model. Default is true.
  # visible true

end
