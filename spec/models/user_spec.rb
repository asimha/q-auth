require 'rails_helper'

RSpec.describe User, :type => :model do

  let(:user1) {FactoryGirl.create(:user, name: "Ram word", email: "ram@domain.com", username: "ram1234", city: "Bangalore", state: "Karnataka")}
  let(:user2) {FactoryGirl.create(:user, name: "Lakshman", email: "lakshmanword@domain.com", username: "lakshman1234", city: "Calicut", state: "Kerala")}
  let(:user3) {FactoryGirl.create(:user, name: "Sita", email: "sita@domain.com", username: "sita1234word", city: "Mysore", state: "Karnataka")}

  context "Factory" do
    it "should validate all the user factories" do
      expect(FactoryGirl.build(:user).valid?).to be true
      expect(FactoryGirl.build(:inactive_user).valid?).to be true
      expect(FactoryGirl.build(:active_user).valid?).to be true
      expect(FactoryGirl.build(:suspended_user).valid?).to be true
      expect(FactoryGirl.build(:admin_user).valid?).to be true
      expect(FactoryGirl.build(:super_admin_user).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('Krishnaprasad Varma').for(:name )}
    it { should_not allow_value('KP').for(:name )}
    it { should_not allow_value("x"*257).for(:name )}

    it { should validate_presence_of :username }
    it { should allow_value('kpvarma').for(:username )}
    it { should allow_value('kpvarma1234').for(:username )}
    it { should_not allow_value('kp varma').for(:username )}
    it { should_not allow_value('kp-varma').for(:username )}
    it { should_not allow_value('kp*varma').for(:username )}
    it { should_not allow_value('xx').for(:username )}
    it { should_not allow_value("x"*129).for(:username )}

    it { should validate_presence_of :email }
    it { should allow_value('something@domain.com').for(:email )}
    it { should_not allow_value('something domain.com').for(:email )}
    it { should_not allow_value('something.domain.com').for(:email )}
    it { should_not allow_value('ED').for(:email )}
    it { should_not allow_value("x"*257).for(:email )}

    it { should validate_presence_of :password }
    it { should allow_value('Password@1').for(:password )}
    it { should_not allow_value('password').for(:password )}
    it { should_not allow_value('password1').for(:password )}
    it { should_not allow_value('password@1').for(:password )}
    it { should_not allow_value('ED').for(:password )}
    it { should_not allow_value("a"*257).for(:password )}

    it { should validate_inclusion_of(:status).in_array(ConfigCenter::User::STATUS_LIST)  }
  end

  context "Associations" do
    it { should belong_to(:designation) }
    it { should belong_to(:department) }
    it { should have_one(:profile_picture) }
  end

  context "Class Methods" do
    it "search" do
      arr = [user1, user2, user3]
      expect(User.search("Ram")).to match_array([user1])
      expect(User.search("Lakshman")).to match_array([user2])
      expect(User.search("Sita")).to match_array([user3])
      expect(User.search("word")).to match_array([user1, user2, user3])
      expect(User.search("Karnataka")).to match_array([user1, user3])
    end

    it "find_by_email_or_username" do
      arr = [user1, user2, user3]
      expect(User.find_by_email_or_username("ram@domain.com")).to eq(user1)
      expect(User.find_by_email_or_username("ram1234")).to eq(user1)
    end
  end

  context "Instance Methods" do
    it "display_designation" do
      u = FactoryGirl.build(:user, designation: FactoryGirl.build(:designation, title: "Some Designation"))
      expect(u.display_designation).to eq("Some Designation")

      u = FactoryGirl.build(:user, designation: FactoryGirl.build(:designation), designation_overridden: "Overidden Designation")
      expect(u.display_designation).to eq("Overidden Designation")
    end

    it "display_address" do
      u = FactoryGirl.build(:user, city: "Mysore", state: nil, country: nil)
      expect(u.display_address).to eq("Mysore")

      u = FactoryGirl.build(:user, city: "Mysore", state: "Karnataka", country: nil)
      expect(u.display_address).to eq("Mysore, Karnataka")

      u = FactoryGirl.build(:user, city: "Mysore", state: "Karnataka", country: "India")
      expect(u.display_address).to eq("Mysore, Karnataka, India")

      u = FactoryGirl.build(:user, city: nil, state: "Karnataka", country: nil)
      expect(u.display_address).to eq("Karnataka")
    end

    it "is_admin?" do
      u = FactoryGirl.build(:normal_user)
      expect(u.is_admin?).to be_falsy

      u = FactoryGirl.build(:admin_user)
      expect(u.is_admin?).to be_truthy

      u = FactoryGirl.build(:super_admin_user)
      expect(u.is_admin?).to be_truthy
    end

    it "is_super_admin?" do
      u = FactoryGirl.build(:normal_user)
      expect(u.is_super_admin?).to be_falsy

      u = FactoryGirl.build(:admin_user)
      expect(u.is_super_admin?).to be_falsy

      u = FactoryGirl.build(:super_admin_user)
      expect(u.is_super_admin?).to be_truthy
    end

    it "token_expired?" do
      token_created_at = Time.now - 30.minute
      u = FactoryGirl.build(:normal_user, token_created_at: token_created_at)
      expect(u.token_expired?).to be_truthy

      token_created_at = Time.now - 29.minute
      u = FactoryGirl.build(:normal_user, token_created_at: token_created_at)
      expect(u.token_expired?).to be_falsy
    end
  end

end