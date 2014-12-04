require 'spec_helper'

RSpec.describe Department, :type => :model do

  let(:department) {FactoryGirl.create(:department)}

  describe Department do
    it { should validate_presence_of :name }
    it { should allow_value('Jr.Developer').for(:name)}
  end

  it "should search the departments" do
    Department.create(:name =>"User1", :description =>"Test data");
    expect(Department.search("Test data")).to be_truthy
    expect(Department.search("Some data")).to be_empty
  end
end