require 'spec_helper'

module Notify
  describe CreateDeliveries do
    let(:notification) { FactoryGirl.create(:delivery).notification }
    subject { ExecuteDeliveries.new.call(notification: notification) }

    context 'if notification is nil' do
      subject { ExecuteDeliveries.new.call(notification: nil) }
      it { expect{ subject }.to raise_error ArgumentError }
    end

    context 'if the notification has no delivery platforms listed' do
      before { allow(notification).to receive(:deliver_via).and_return [] }
      it { expect{ subject }.to raise_error AdapterError }
    end

    # context 'if the notification\'s specified platform is not in the list of registered platforms'

    context 'if the notification\'s specified platform cannot be found' do
      before { allow(notification).to receive(:deliver_via).and_return ['this_should_not_exist'] }
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

