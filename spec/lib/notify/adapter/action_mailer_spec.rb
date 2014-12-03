require 'spec_helper'

module Notify::Adapter
  describe ActionMailer do

    describe '#deliver' do

      let(:mailer_class) do
        class ::FooMailer < ::ActionMailer::Base
          def foo(receiver, notification); end
        end
        FooMailer
      end
      after { Object.send(:remove_const, :FooMailer) if Object.constants.include?(:FooMailer) }

      let(:delivery)     { double :delivery, receiver: receiver, message: message, strategy: strategy, notification: notification }
      let(:receiver)     { double :receiver }
      let(:notification) { double :notification, strategy: strategy, class: double(id: :foo) }
      let(:strategy)     { double :strategy, mailer: :foo }
      let(:message)      { double :message, notification: notification, receivers: [receiver] }
      subject{ ActionMailer.new.deliver delivery, strategy }

      it 'sends the message to a mailer' do
        mail = double deliver!: true
        expect(mailer_class).to receive(notification.class.id).with(receiver, message).and_return(mail)
        subject
      end

      context 'when a mailer option is specified' do
        it 'parses the mailer and action from <mailer>#<action>' do
          strategy = double :strategy, mailer: 'foo#bar'
          mail = double :mail, deliver!: true
          expect(mailer_class).to receive(:bar).and_return mail
          ActionMailer.new.deliver delivery, strategy
        end

        context 'with a namespaced mailer' do

          let(:mailer_class) do
            module ::Foo
              class BarMailer < ::ActionMailer::Base; end
            end
            Foo::BarMailer
          end
          after { Foo.send(:remove_const, :BarMailer) if Object.constants.include?(:Foo) && Foo.constants.include?(:BarMailer) }

          it 'finds the mailer class' do
            strategy = double :strategy, mailer: 'foo/bar#baz'
            mail = double :mail, deliver!: true
            expect(mailer_class).to receive(:baz).and_return mail
            ActionMailer.new.deliver delivery, strategy
          end
        end
      end

      it 'calls deliver! on the mail object' do
        mail = double
        expect(mail).to receive :deliver!
        expect(mailer_class).to receive(:foo).and_return mail
        subject
      end

    end
  end
end
