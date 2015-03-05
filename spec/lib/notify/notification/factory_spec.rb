require 'spec_helper'

module Notify
  module Notification
    describe Factory do
      let(:notification_class) { class FooNotification; extend Notification; end }
      after { Notify.send(:remove_const, :FooNotification) if Notify.constants.include?(:FooNotification) }

      let(:receivers) { FactoryGirl.create_list :receiver, 1 }
      let(:factory) { Factory.new(notification_class) }

      describe '#create' do
        subject { factory.create receivers }

        it 'returns an instance of the notification class' do
          expect(subject).to be_a_kind_of notification_class
        end

        it 'creates a message record' do
          expect{ subject }.to change(Message, :count).by 1
        end

        it 'creates a delivery object for each item in the receiver list' do
          receivers << FactoryGirl.create(:receiver)
          expect(receivers.count).to eq 2
          expect{ subject }.to change(Delivery, :count).by 2
        end

        describe 'the receiver list' do
          it 'can be a single item' do
            receivers = FactoryGirl.create :receiver
            expect{ factory.create receivers }.to_not raise_error
          end

          it 'can be an array' do
            receivers = FactoryGirl.create_list(:receiver, 2).to_a
            expect{ factory.create receivers }.to_not raise_error
          end

          it 'can be an ActiveRecord::Relation' do
            receivers = FactoryGirl.create(:receiver).class.order(:id)
            expect(receivers).to be_a_kind_of(ActiveRecord::Relation)
            expect{ factory.create receivers }.to_not raise_error
          end

          it 'must only contain ActiveRecord::Base instances' do
            receivers = [FactoryGirl.create(:receiver), 'foo']
            expect{ factory.create receivers }.to raise_error ActiveRecord::RecordInvalid
          end
        end

      end
    end
  end
end
