require 'spec_helper'

module Notify
  describe Notify do

    describe '.strategy' do
      it 'safely finds a notification class' do
        class ::FooNotification; extend Notify::Strategy; end;
        expect(Notify.strategy(:foo)).to eq FooNotification
        expect(Notify.strategy(:bar)).to be_nil
      end

      it 'finds a notification class when the name is nested' do
        module ::Foo
          class BarNotification; extend Notify::Strategy; end;
        end
        expect(Notify.strategy('foo/bar')).to eq ::Foo::BarNotification
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

    describe '.create' do
      let!(:clazz) { class ::FooNotification; extend Notify::Strategy; ;end }
      after do
        # Remove the fake notifications we created.
        Object.send(:remove_const, :FooNotification) if Object.constants.include?(:FooNotification)
      end

      let(:receivers) { FactoryGirl.create_list :receiver, 1 }
      subject{ Notify.create :foo, to: receivers }

      it 'requires a to param' do
        expect{ Notify.create :foo }.to raise_error
      end

      it 'requires the activity to be an ActiveRecord model if present' do
        expect{ Notify.create :foo, to: receivers, activity: "foo" }.
          to raise_error ArgumentError, "activity must be an ActiveRecord object"
      end

      it 'creates a notification' do
        allow_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true
        expect{ subject }.to change(Notification, :count).by 1
      end

      describe 'the created notification' do
        before { allow_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true }

        it 'is returned' do
          expect(subject).to be_a_kind_of Notification
        end

        it 'is persisted' do
          expect(subject.persisted?).to be_truthy
        end
      end

      it 'creates deliveries for each receiver' do
        allow_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true

        receivers.push *FactoryGirl.create_list(:receiver, 2)
        expect(receivers.count).to eq 3
        expect{ Notify.create :foo, to: receivers }.
          to change(Notification::Delivery, :count).by 3
      end

      it 'runs deliveries' do
        expect_any_instance_of(ExecuteDeliveries).to receive(:call).and_return true
        Notify.create :foo, to: receivers
      end
    end

  end
end
