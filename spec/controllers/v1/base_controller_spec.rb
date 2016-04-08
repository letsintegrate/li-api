require 'rails_helper'

RSpec.describe V1::BaseController, type: :controller do
  describe '#deserialized_params' do
    it 'exists' do
      expect(subject).to respond_to(:deserialized_params).with(1).argument
    end
  end

  describe '#get_index' do
    it 'exists' do
      expect(subject).to respond_to(:get_index).with(1).argument
    end
  end
end
