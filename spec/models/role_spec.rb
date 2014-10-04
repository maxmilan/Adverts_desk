require 'rails_helper'

RSpec.describe Role, :type => :model do
  before(:each) do
    Role.find_each do |role|
      role.destroy
    end
    @admin_role = Role.create(:name => "admin")
    @user_role = Role.create(:name => "user")
    @user = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email,
                        password: Faker::Internet.password, role_id: @user_role.id)
  end

  it 'should be valid' do
    @user_role.should be_valid
    @admin_role.should be_valid
  end

  it 'should have name' do
    @user_role.name = nil
    @user_role.should_not be_valid
    @user_role.name = ''
    @user_role.should_not be_valid
  end

  it 'should have unique name' do
    @other_role = Role.create(name: 'admin')
    @other_role.should_not be_valid
    @other_role.name = 'other'
    @other_role.should be_valid
  end

  after(:each) do
    @user.destroy
    @user_role.destroy
    @admin_role.destroy
  end

end