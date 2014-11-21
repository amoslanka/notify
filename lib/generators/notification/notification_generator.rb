class NotificationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_notification_file
    template "notification.rb", "app/notifications/#{name}_notification.rb"
  end

  def notification_name
    name
  end
end
