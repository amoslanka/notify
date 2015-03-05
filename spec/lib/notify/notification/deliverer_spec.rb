require 'spec_helper'

module Notify
  module Notification
    describe Deliverer do

      let(:message) { double(strategy: strategy) }
      let(:strategy) { Strategy.new }
      let(:notification) { double(message: message, strategy: strategy) }
      subject { Deliverer.call(notification) }

      context 'if the notification has no delivery platforms listed' do
        before { allow(notification.strategy).to receive(:deliver_via).and_return [] }
        it { expect{ subject }.to raise_error AdapterError }
      end

      context 'if the message\'s specified platform cannot be found' do
        before { allow(strategy).to receive(:deliver_via).and_return ['this_should_not_exist'] }
        it { expect{ subject }.to raise_error AdapterError }
      end

      it 'delivers each delivery' do
        # TODO
      end

      it 'delivers to every platform' do
        # TODO
      end

      describe 'failures' do
        # TODO
      end

    end
  end
end
