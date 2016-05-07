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

  describe '#set_locale' do
    it 'exists' do
      expect(subject).to respond_to(:set_locale).with(0).argument
    end

    it 'sets the locale to the given header' do
      @request.env["HTTP_X_LOCALE"] = 'de'
      subject.set_locale
      expect(subject.locale).to eql('de')
    end
  end
end
