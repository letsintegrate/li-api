require 'rails_helper'

RSpec.describe MenuItemPolicy do

  let(:user) { User.new }
  let(:menu_item) { FactoryGirl.create(:menu_item) }

  subject { described_class }

  permissions ".scope" do
    context 'as a user' do
      subject { described_class::Scope.new(user, MenuItem.all).resolve }

      it { should include menu_item }
    end

    context 'as a guest' do
      subject { described_class::Scope.new(nil, MenuItem.all).resolve }

      it { should include menu_item }
    end
  end

  permissions :show? do
    it { should permit user, menu_item }
    it { should permit nil, menu_item }
  end

  permissions :create? do
    it { should permit user, menu_item }
    it { should_not permit nil, menu_item }
  end

  permissions :update? do
    it { should permit user, menu_item }
    it { should_not permit nil, menu_item }
  end

  permissions :destroy? do
    it { should permit user, menu_item }
    it { should_not permit nil, menu_item }
  end

  context '#permitted_attributes' do
    context 'as a user' do
      subject { described_class.new(user, menu_item).permitted_attributes }

      it { should be_kind_of Array }
      it { should include :name }
      it { should include :page_id }
    end

    context 'as a guest' do
      subject { described_class.new(nil, menu_item).permitted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end
  end

  context '#whitelisted_attributes' do
    context 'as a user' do
      subject { described_class.new(user, menu_item).whitelisted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end

    context 'as a guest' do
      subject { described_class.new(nil, menu_item).whitelisted_attributes }

      it { should be_kind_of Array }
      it { should be_empty }
    end
  end
end
