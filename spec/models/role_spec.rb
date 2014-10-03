require 'rails_helper'

RSpec.describe Role, :type => :model do
  before(:each) do
    @admin_role = Role.create(:name => "admin")
    @user_role = Role.create(:name => "user")
    @user = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email,
                        password: Faker::Internet.password)
  end



  after(:each) do
    @user.destroy
    @user_role.destroy
    @admin_role.destroy
  end

end