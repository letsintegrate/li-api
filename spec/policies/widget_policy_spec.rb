require 'rails_helper'

RSpec.describe WidgetPolicy do

  let(:user) { User.new }
  let(:widget) { FactoryGirl.create(:widget) }

  subject { described_class }

  permissions ".scope" do
    context 'as a user' do
      subject { described_class::Scope.new(user, Widget.all).resolve }

      it { should include widget }
    end

    context 'as a guest' do
      subject { described_class::Scope.new(nil, Widget.all).resolve }

      it { should include widget }
    end
  end

  permissions :show? do
    it { should permit user, widget }
    it { should permit nil, widget }
  end

  permissions :create? do
    it { should_not permit user, widget }
    it { should_not permit nil, widget }
  end

  permissions :update? do
    it { should_not permit user, widget }
    it { should_not permit nil, widget }
  end

  permissions :destroy? do
    it { should_not permit user, widget }
    it { should_not permit nil, widget }
  end

  context '#permitted_attributes' do
    context 'as a user' do
      subject { described_class.new(user, widget).permitted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end

    context 'as a guest' do
      subject { described_class.new(nil, widget).permitted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end
  end

  context '#whitelisted_attributes' do
    context 'as a user' do
      subject { described_class.new(user, widget).whitelisted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end

    context 'as a guest' do
      subject { described_class.new(nil, widget).whitelisted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end
  end
end
