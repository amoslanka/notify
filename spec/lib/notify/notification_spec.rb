require 'spec_helper'

module Notify
  describe Notification

    # describe '.create' do
    #   let!(:clazz) { class ::FooNotification; extend Notify::Notification; ;end }
    #   after do
    #     # Remove the fake notifications we created.
    #     Object.send(:remove_const, :FooNotification) if Object.constants.include?(:FooNotification)
    #   end

    #   let(:receivers) { FactoryGirl.create_list :receiver, 1 }
    #   subject{ Notify.create :foo, to: receivers }

    #   it 'requires a to param' do
    #     expect{ Notify.create :foo }.to raise_error
    #   end

    #   it 'requires the activity to be an ActiveRecord model if present' do
    #     expect{ Notify.create :foo, to: receivers, activity: "foo" }.
    #       to raise_error ArgumentError, "activity must be an ActiveRecord object"
    #   end

    #   it 'creates a notification' do
    #     allow_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true
    #     expect{ subject }.to change(Message, :count).by 1
    #   end

    #   describe 'the created notification' do
    #     before { allow_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true }

    #     it 'is returned' do
    #       expect(subject).to be_a_kind_of Message
    #     end

    #     it 'is persisted' do
    #       expect(subject.persisted?).to be_truthy
    #     end
    #   end

    #   it 'creates deliveries for each receiver' do
    #     allow_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true

    #     receivers.push *FactoryGirl.create_list(:receiver, 2)
    #     expect(receivers.count).to eq 3
    #     expect{ Notify.create :foo, to: receivers }.
    #       to change(Notify::Delivery, :count).by 3
    #   end

    #   it 'runs deliveries' do
    #     expect_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true
    #     Notify.create :foo, to: receivers
    #   end
    # end



  end
end
