require 'rails_helper'

RSpec.describe Role, type: :model do
	let(:user_role){FactoryGirl.create(:role)}
	let(:admin_role){FactoryGirl.create(:role, name: 'admin')}

  it 'should be valid' do
    expect(user_role).to be_valid
    expect(admin_role).to be_valid
  end

  it 'should have name' do
    user_role.name = nil
    expect(user_role).not_to be_valid
    user_role.name = ''
    expect(user_role).not_to be_valid
  end

  it 'should have unique name' do
	  other_role = admin_role.dup
    expect(other_role).not_to be_valid
    other_role.name = 'other'
    expect(other_role).to be_valid
  end
end
