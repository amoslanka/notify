require 'spec_helper'

module Notify
  describe NotificationType do
    let(:config) { NotificationType.new }

    describe 'validation' do

      it 'validates that a name is provided' do
        config.name = nil
        expect{ config.validate! }.to raise_error
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
