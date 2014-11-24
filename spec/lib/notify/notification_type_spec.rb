require 'spec_helper'

module Notify
  describe NotificationType do
    let(:config) { NotificationType.new }

    subject { class ::FooNotification; extend NotificationType; end }
    after { Object.send(:remove_const, :FooNotification) if Object.constants.include?(:FooNotification) }

    describe 'validation' do
    end

    describe '.id' do
      it 'removes "Notification" from the classname' do
        expect(subject.id.to_sym).to eq :foo
      end
    end

    describe '#ruleset' do

      it { expect(subject.ruleset).to be_a_kind_of Ruleset }

      it 'creates a new ruleset instance with each request' do
        expect(Ruleset).to receive(:new).twice
        subject.ruleset
        subject.ruleset
      end

      it 'includes all items in RULE_ATTRIBUTES in the ruleset' do
        NotificationType::RULE_ATTRIBUTES.each do |rule|
          subject.send("#{rule}=", 'foo')
          expect(subject.ruleset[rule]).to eq 'foo'
        end
      end

    end

  end
end
