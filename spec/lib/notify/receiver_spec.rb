require 'spec_helper'

module Notify
  describe Receiver do

    let(:notification_class) { class ::FooNotification; extend Notification; end }
    after { Object.send(:remove_const, :FooNotification) if Object.constants.include?(:FooNotification) }

    let(:receiver_class) do
      class FooReceiver
        def self.has_many(*args); end
        include Receiver
      end
    end
    after { Notify.send(:remove_const, :FooReceiver) if Notify.constants.include?(:FooReceiver) }

    describe '#notify' do
      subject { receiver_class.new }

      it 'calls create on the notification_class' do
        expect(notification_class).to receive(:create).with(subject, {})
        subject.notify :foo
      end

      it 'passes the rules on to the create method' do
        rules = { foo: :bar }
        expect(notification_class).to receive(:create).with(subject, rules)
        subject.notify :foo, rules
      end

    end
  end
end
