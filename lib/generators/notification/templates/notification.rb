Notify.register_notification do
  type :<%= file_name%>

  # The delivery platforms this notification should use. The fallback
  # will be the default list of all platforms.
  # deliver_via :email

  # The number of times to retry failed notifications. Default is 5.
  # retry 5

  # Whether this notification will be visible in a notifications feed for
  # the receiver model. Default is true.
  # visible true

end
