require 'rails_helper'

RSpec.describe Category, type: :model do

  let(:category){FactoryGirl.create(:category)}
  let(:other_category){FactoryGirl.create(:category, name:"Other name")}

  describe 'Category' do
	  it 'should respond to name' do
		  expect(category).to respond_to(:name)
	  end

	  it 'should be valid' do
	    expect(category).to be_valid
	  end
  end

  describe 'Category presence validation' do
	  it 'should not be nil name' do
		  category.name = nil
		  expect(category).not_to be_valid
	  end

	  it 'should not be empty name' do
		  category.name = ''
		  expect(category).not_to be_valid
	  end
  end

  describe 'Category uniquness validation' do
	  it 'should have unique name' do
		  other_category.name = category.name
	    expect(other_category).not_to be_valid
	  end
	end
end
