require 'rails_helper'

RSpec.describe Department, :type => :model do

  let(:department1) {FactoryGirl.create(:department, name: "Infrastructure Department", description: "Infrastructure Apple")}
  let(:department2) {FactoryGirl.create(:department, name: "Engineering Department", description: "Engineering Operations PineApple")}
  let(:department3) {FactoryGirl.create(:department, name: "Operations Department", description: "Operations Mango")}

  context "Factory" do
    it "should validate the department factory" do
      expect(FactoryGirl.build(:department).valid?).to be true
    end
  end

  context "Validations" do
    it { should validate_presence_of :name }
    it { should allow_value('Engineering Department').for(:name )}
    it { should_not allow_value('ED').for(:name )}
    it { should_not allow_value("a"*257).for(:name )}

    it { should allow_value("x"*205).for(:description )}
    it { allow_value allow_value("x"*2056).for(:description )}
    it { should_not allow_value('AB').for(:description )}
    it { should_not allow_value("x"*2057).for(:description )}
  end

  context "Associations" do
    it { should have_many(:users) }
  end

  context "Class Methods" do
    it "search" do
      arr = [department1, department2, department3]
      expect(Department.search("Infrastructure")).to match_array([department1])
      expect(Department.search("Engineering")).to match_array([department2])
      expect(Department.search("Operations")).to match_array([department2, department3])
      expect(Department.search("Department")).to match_array(arr)
      expect(Department.search("Apple")).to match_array([department1, department2])
      expect(Department.search("Mango")).to match_array([department3])
    end
  end
end

