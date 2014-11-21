module Notify
  class Engine < ::Rails::Engine

    # Configure Migrations
    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end

    # Configure Generators
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    # Load Notify configurations
    initializer :notify_load_notifications do |app|
      Notify.reload!
    end

    # Initialize an delivery platform for ActionMailer
    # The action_mailer platform is automatically created if ActionMailer
    # is present.
    initializer :notify_load_default_platforms do |app|
      if defined?(ActionMailer)
        Notify.delivery_platform :action_mailer
      end
    end

  end
end
