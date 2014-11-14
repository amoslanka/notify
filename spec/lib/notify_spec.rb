require 'spec_helper'

module Notify
  describe Notify do

    describe '.register_notification' do
      subject do
        Notify.register_notification do
          name "Foo"
        end
      end

      it 'adds a notification type to types' do
        expect{ subject }.to change{ Notify.types.length }.by 1
      end

      it 'validates the notification type' do
        expect_any_instance_of(NotificationType).to receive :validate!
        subject
      end

    end

  end
end
