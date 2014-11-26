require 'spec_helper'
require 'ammeter/init'
require 'generators/adapter/adapter_generator'

module Notify
  describe AdapterGenerator, type: :generator do
    before { run_generator %w(foo) }

    describe 'the adapter file' do
      subject { file('lib/notify/adapter/foo.rb') }
      it { should exist }
    end

  end
end
