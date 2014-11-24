module Notify
  class TranslatorGenerator < Rails::Generators::NamedBase
    source_root File.expand_path('../templates', __FILE__)

    def copy_translator_file
      template "translator.rb", "lib/notify/translator/#{name}.rb"
    end

    def translator_name
      name
    end
  end
end
