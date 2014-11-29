require 'spec_helper'

module Notify
  describe CreateDeliveries do
    let(:message) { FactoryGirl.create(:delivery).message }
    subject { ExecuteDeliveries.new.call(message: message) }

    context 'if message is nil' do
      subject { ExecuteDeliveries.new.call(message: nil) }
      it { expect{ subject }.to raise_error ArgumentError }
    end

    context 'if the message has no delivery platforms listed' do
      before { allow(message).to receive(:deliver_via).and_return [] }
      it { expect{ subject }.to raise_error AdapterError }
    end

    # context 'if the message\'s specified platform is not in the list of registered platforms'

    context 'if the message\'s specified platform cannot be found' do
      before { allow(message).to receive(:deliver_via).and_return ['this_should_not_exist'] }
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

