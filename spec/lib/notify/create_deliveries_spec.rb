require 'spec_helper'

module Notify
  describe CreateDeliveries do
    let(:receivers) { FactoryGirl.create_list :receiver, 1 }
    let(:options) do
      {
        message: FactoryGirl.create(:message),
        to: receivers
      }
    end
    subject { CreateDeliveries.new.call options }

    it 'creates a delivery object for each item in the receiver list' do
      receivers << FactoryGirl.create(:receiver)
      expect(receivers.count).to eq 2
      expect{ subject }.to change(Notify::Delivery, :count).by 2
    end

    describe 'the receiver list' do
      it 'can be a single item' do
        options[:to] = FactoryGirl.create :receiver
        expect{ subject }.to_not raise_error
      end

      it 'can be an array' do
        options[:to] = FactoryGirl.create_list(:receiver, 2).to_a
        expect{ subject }.to_not raise_error
      end

      it 'can be an ActiveRecord::Relation' do
        receiver = FactoryGirl.create :receiver
        options[:to] = receiver.class.order(:id)
        expect{ subject }.to_not raise_error
      end

      it 'must only contain ActiveRecord::Base instances' do
        options[:to] = [FactoryGirl.create(:receiver), 'foo']
        expect{ subject }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    it 'requires the receivers option' do
      options[:to] = nil
      expect{ subject }.to raise_error ArgumentError
    end

    it 'requires the message option' do
      options[:message] = nil
      expect{ subject }.to raise_error ArgumentError
    end

  end
end
