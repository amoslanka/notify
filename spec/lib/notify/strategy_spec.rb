require 'spec_helper'

module Notify
  describe Strategy do

    let!(:foo) { class FooNotification; extend Notification; end }
    after { Notify.send(:remove_const, :FooNotification) if Notify.constants.include?(:FooNotification) }

    describe '.from_notification' do
      let(:rules) { {} }
      subject{ Strategy.from_notification(foo, rules) }

      it{ expect(subject).to be_a_kind_of Strategy }

      it 'uses the global strategy as the base' do
        expect(subject).to eq Notify.strategy
      end

      it 'merges the notification class strategy into the global strategy' do
        foo.deliver_via = [:foo, :bar, :baz]
        expect(subject.deliver_via).to eq [:foo, :bar, :baz]
      end

      it 'merges the argument rules as highest priority' do
        foo.deliver_via = [:foo, :bar, :baz]
        rules.merge! deliver_via: [:a, :b, :c]
        expect(subject.deliver_via).to eq [:a, :b, :c]
      end
    end

    describe '#merge' do
      it 'merges the passed in rules' do
        strategy = Strategy.new(foo: :bar, herp: :derp)
        rules = { foo: :new_bar, herp: :new_derp }
        expect(strategy.merge(rules).to_h).to eq rules
      end

      it 'does not merge nil values' do
        strategy = Strategy.new(foo: :bar, herp: :derp)
        rules = { foo: :new_bar, herp: nil }
        expect(strategy.merge(rules).to_h).to eq({foo: :new_bar, herp: :derp})
      end
    end

  end
end
