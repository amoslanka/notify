require 'spec_helper'
require 'ammeter/init'
require 'generators/translator/translator_generator'

module Notify
  describe TranslatorGenerator, type: :generator do
    before { run_generator %w(foo) }

    describe 'the translator file' do
      subject { file('lib/notify/translator/foo.rb') }
      it { should exist }
    end

  end
end
