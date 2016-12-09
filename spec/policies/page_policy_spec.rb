require 'rails_helper'

RSpec.describe PagePolicy do

  let(:user) { User.new }
  let(:page) { FactoryGirl.create(:page) }

  subject { described_class }

  permissions ".scope" do
    context 'as a user' do
      subject { described_class::Scope.new(user, Page.all).resolve }

      it { should include page }
    end

    context 'as a guest' do
      subject { described_class::Scope.new(nil, Page.all).resolve }

      it { should include page }
    end
  end

  permissions :show? do
    it { should permit user, page }
    it { should permit nil, page }
  end

  permissions :create? do
    it { should permit user, page }
    it { should_not permit nil, page }
  end

  permissions :update? do
    it { should permit user, page }
    it { should_not permit nil, page }
  end

  permissions :destroy? do
    it { should permit user, page }
    it { should_not permit nil, page }
  end

  context '#permitted_attributes' do
    context 'as a user' do
      subject { described_class.new(user, page).permitted_attributes }

      it { should be_kind_of Array }
      it { should include :id }
    end

    context 'as a guest' do
      subject { described_class.new(nil, page).permitted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end
  end

  context '#whitelisted_attributes' do
    context 'as a user' do
      subject { described_class.new(user, page).whitelisted_attributes }

      it { should be_kind_of Array }
      it { should include :title_translations }
      it { should include :content_translations }
    end

    context 'as a guest' do
      subject { described_class.new(nil, page).whitelisted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end
  end
end
