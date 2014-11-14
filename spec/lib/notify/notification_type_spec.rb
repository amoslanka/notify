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

  end
end
