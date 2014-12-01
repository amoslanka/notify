require 'spec_helper'

module Notify
  describe Notify do

    describe '.strategy' do
      subject{ Notify.strategy }

      it 'is instantiated by default' do
        expect(subject).to be_a_kind_of Strategy
      end

      it 'defaults deliver_via' do
        expect(Array(subject.deliver_via)).to eq [:action_mailer]
      end

      it 'defaults visible' do
        expect(subject.visible).to eq true
      end

      it 'defaults mailer' do
        expect(subject.mailer).to eq :notifications
      end

    end

    describe '.notification' do
      it 'safely finds a notification class' do
        class ::FooNotification; extend Notify::Notification; end;
        expect(Notify.notification(:foo)).to eq FooNotification
        expect(Notify.notification(:bar)).to be_nil
      end

      it 'finds a notification class when the name is nested' do
        module ::Foo
          class BarNotification; extend Notify::Notification; end;
        end
        expect(Notify.notification('foo/bar')).to eq ::Foo::BarNotification
      end

      after do
        # Remove the fake notifications we created.
        Object.send(:remove_const, :FooNotification) if Object.constants.include?(:FooNotification)
        if Object.constants.include?(:Foo) && Foo.constants.include?(:BarNotification)
          Foo.send(:remove_const, :BarNotification)
        end
      end
    end

    describe '.adapter' do
      it 'safely return nil if no adapter is found' do
        expect(Notify.adapter(:foo)).to be_nil
      end

      it 'finds a adapter class at Notify::Adapter::Foo' do
        class ::Notify::Adapter::Foo; end;
        expect(Notify.adapter :foo).to eq ::Notify::Adapter::Foo
      end

      it 'finds a adapter class at FooAdapter' do
        class ::FooAdapter; end;
        expect(Notify.adapter :foo).to eq ::FooAdapter
      end

      after do
        # Remove the fake adapters we created.
        Object.send(:remove_const, :FooAdapter) if Object.constants.include?(:FooAdapter)
        Notify::Adapter.send(:remove_const, :Foo) if Notify::Adapter.constants.include?(:Foo)
      end
    end

  end
end
