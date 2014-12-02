require 'spec_helper'

module Notify
  describe Message do

    let(:notification_class) { class ::FooNotification; extend Notification; end }
    after { Object.send(:remove_const, :FooNotification) if Object.constants.include?(:FooNotification) }
    subject { described_class.new notification_name: notification_class.id }

    describe '#strategy' do
      it { expect(subject.strategy).to be_a_kind_of Strategy }
      it 'creates a new strategy each call' do
        expect(subject.strategy).to_not be subject.strategy
      end
    end

    describe '#strategy=' do
      it 'assigns the values to attributes' do
        strategy = Strategy.new deliver_via: :foo
        expect{ subject.strategy = strategy }.to change{ subject.deliver_via }.to [:foo]
      end

      it 'only assigns attributes named in STRATEGY_ATTRIBUTES' do
        strategy = Strategy.new notification_name: :bar
        expect{ subject.strategy = strategy }.to_not change(strategy, :notification_name)
      end
    end

  end
end
