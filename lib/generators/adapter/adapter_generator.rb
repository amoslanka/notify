module Notify
  class AdapterGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def copy_adapter_file
      template "adapter.rb", "lib/notify/adapter/#{name}.rb"
    end

    def adapter_name
      name
    end
  end
end
