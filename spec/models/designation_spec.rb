require 'rails_helper'

RSpec.describe Designation, :type => :model do

  let(:designation1) {FactoryGirl.create(:designation, title: "Infrastructure Manager", responsibilities: "Infrastructure Management")}
  let(:designation2) {FactoryGirl.create(:designation, title: "Operations Manager", responsibilities: "Operations Management")}
  let(:designation3) {FactoryGirl.create(:designation, title: "Sr. Operations Manager", responsibilities: "Operations Management")}
  let(:designation4) {FactoryGirl.create(:designation, title: "Sr. Engineering Manager", responsibilities: "Engineering Operations")}

  context "Factory" do
    it "should validate the report factories" do
      expect(FactoryGirl.build(:designation).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :title }
    it { should allow_value('Engineering Manager').for(:title )}
    it { should_not allow_value('EM').for(:title )}
    it { should_not allow_value("a"*257).for(:title )}

    it { should allow_value("x"*205).for(:responsibilities )}
    it { allow_value allow_value("x"*2056).for(:responsibilities )}
    it { should_not allow_value('AB').for(:responsibilities )}
    it { should_not allow_value("x"*2057).for(:responsibilities )}
  end

  context "Associations" do
    it { should have_many(:users) }
  end

  context "Class Methods" do
    it "search" do
      arr = [designation1, designation2, designation3, designation4]
      expect(Designation.search("Infrastructure")).to match_array([designation1])
      expect(Designation.search("Operations")).to match_array([designation2, designation3, designation4])
      expect(Designation.search("Manager")).to match_array(arr)
      expect(Designation.search("Management")).to match_array([designation1, designation2, designation3])
    end
  end
end