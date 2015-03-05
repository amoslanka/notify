require 'spec_helper'

module Notify
  describe Notification do
    let(:notification_class) { class FooNotification; extend Notification; end }
    after { Notify.send(:remove_const, :FooNotification) if Notify.constants.include?(:FooNotification) }

    describe 'class methods' do
      subject { notification_class }

      describe '.id' do
        it 'returns the class name with "Notification" removed' do
          expect(subject.id.to_sym).to eq :foo
        end
      end

      describe '.strategy' do
        it 'uses Strategy.from_notification' do
          expect(Strategy).to receive(:from_notification)
          subject.strategy
        end
      end

      describe '.factory' do
        it 'defaults to a Notification::Factory instance' do
          subject.factory = nil
          expect(subject.factory).to be_a_kind_of Notification::Factory
          expect(subject.factory.notification_class).to eq subject
        end

        it 'returns the factory object' do
          fake = double()
          subject.factory = fake
          expect(subject.factory).to eq fake
        end
      end

      describe '.deliverer' do
        it 'defaults to the Notification::Deliverer class' do
          subject.deliverer = nil
          expect(subject.deliverer).to eq Notification::Deliverer
        end

        it 'returns the deliverer object' do
          fake = double()
          subject.deliverer = fake
          expect(subject.deliverer).to eq fake
        end
      end

      describe '.create' do
        let(:options) { {} }
        subject { notification_class.create [double()], options }

        it 'creates a notification using the factory' do
          allow(notification_class).to receive :deliver
          expect(notification_class.factory).to receive(:create).and_return double(deliver: nil)
          subject
        end

        it 'delivers the notification using the deliverer' do
          notification = double
          allow(notification_class.factory).to receive(:create).and_return notification
          expect(notification).to receive :deliver
          subject
        end

        context 'with deliver=false' do
          let(:options) { { deliver: false } }

          it 'does not deliver the notificiation' do
            notification = double
            allow(notification_class.factory).to receive(:create).and_return notification
            expect(notification).to_not receive :deliver
            subject
          end
        end
      end
    end

    describe 'instance methods' do
      let(:message) { double }
      subject { notification_class.new(message) }

      describe '#deliver' do
        it 'calls call on the notification class deliverer' do
          allow(notification_class).to receive(:deliverer).and_return double
          expect(notification_class.deliverer).to receive :call
          subject.deliver
        end

        context 'with a provided delegate argument' do
          it 'calls call on the delegate' do
            delegate = double
            expect(delegate).to receive :call
            subject.deliver(delegate)
          end
        end
      end

      it 'delegates #strategy to the message' do
        expect(message).to receive :strategy
        subject.strategy
      end
    end

  end
end
