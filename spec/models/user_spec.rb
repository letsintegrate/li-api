require 'rails_helper'

RSpec.describe User, type: :model do
  subject { FactoryGirl.build :user }

  # Attributes
  it { should have_db_column(:id).of_type :uuid }
  it { should have_db_column(:email).of_type :string }
  it { should have_db_column(:password_digest).of_type :string }

  # Validations
  it { should validate_presence_of :email }
  it { should validate_uniqueness_of(:email).case_insensitive }

  describe "Validations" do
    context "on a new user" do
      it "should not be valid without a password" do
        subject.password = subject.password_confirmation = nil
        expect(subject).to_not be_valid
      end

      it "should be not be valid with a short password" do
        subject.password = subject.password_confirmation = 'short'
        expect(subject).to_not be_valid
      end

      it "should not be valid with a confirmation mismatch" do
        subject.password = 'very long password'
        subject.password_confirmation = 'even longer password'
        expect(subject).to_not be_valid
      end

      it "should be valid with a strong password" do
        subject.password = subject.password_confirmation = 'very long password'
        expect(subject).to be_valid
      end
    end

    context "on an existing user" do
      subject do
        u = FactoryGirl.create(:user)
        User.find(u.id) # This is required, else the password is stil set and we get a false success
      end

      it "should be valid with no changes" do
        expect(subject).to be_valid
      end

      it "should not be valid with an empty password" do
        subject.password = subject.password_confirmation = ""
        expect(subject).to_not be_valid
      end

      it "should be valid with a new (valid) password" do
        subject.password = subject.password_confirmation = "very long password"
        expect(subject).to be_valid
      end
    end
  end
end
