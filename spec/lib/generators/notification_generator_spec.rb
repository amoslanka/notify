require 'spec_helper'
require 'ammeter/init'
require 'generators/notification/notification_generator'

module Notify
  describe NotificationGenerator, type: :generator do
    before { run_generator %w(foo) }

    describe 'the notification file' do
      subject { file('app/notifications/foo_notification.rb') }
      it { should exist }
    end

  end
end
