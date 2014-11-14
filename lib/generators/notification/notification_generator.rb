class NotificationGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_notification_file
    template "notification.rb", "app/notifications/#{file_name}.rb"
  end
end
