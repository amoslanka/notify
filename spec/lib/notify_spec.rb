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

    describe '.reload!' do
    end

    describe '.create' do
      before { Notify.reload! }
      before { register_notification :foo }
      let(:receivers) { FactoryGirl.create_list :receiver, 1 }
      subject{ Notify.create :foo, to: receivers }

      it 'requires a to param' do
        expect{ Notify.create :foo }.to raise_error
      end

      it 'creates a notification' do
        expect{ subject }.to change(Notification, :count).by 1
      end

      describe 'the created notification' do
        it 'is returned' do
          expect(subject).to be_a_kind_of Notification
        end

        it 'is persisted' do
          expect(subject.persisted?).to be_truthy
        end
      end

      it 'creates deliveries for each receiver' do
        receivers.push *FactoryGirl.create_list(:receiver, 2)
        expect(receivers.count).to eq 3
        expect{ Notify.create :foo, to: receivers }.
          to change(Notification::Delivery, :count).by 3
      end

      it 'runs deliveries' do
        raise 'TODO'
      end

    end

  end
end
