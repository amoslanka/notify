require 'spec_helper'
require 'ammeter/init'
require 'generators/notification/notification_generator'

describe NotificationGenerator, type: :generator do
  before { run_generator %w(foo) }

  describe 'the notification file' do
    subject { file('app/notifications/foo.rb') }
    it { should exist }
  end

end
