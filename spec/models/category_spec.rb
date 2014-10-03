require 'rails_helper'

RSpec.describe Category, :type => :model do
  before(:each) do
    @user_role = Role.create(:name => "user")
    @user = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email,
                        password: Faker::Internet.password)

    @user.role_id = @user_role.id

    category_names = ['transport','realty']
    types = ['sell', 'buy', 'exchange', 'service', 'loan']

    category_names.each do |category|
      Category.create(name: category)
    end

    @advert = Advert.create(title: Faker::Lorem.word, body: Faker::Lorem.paragraph(Random.new.rand(2..5)), category: Category.find_by(name: category_names[0]),
                            state: :new, advert_type: types[Random.new.rand(0...types.length)], price: Random.new.rand(50..1000) )

    @user.adverts << @advert
    @user.save
  end

  it 'should be valid' do
    Category.create(name: "other").should be_valid
  end

  it 'should not be empty name' do
    @category = Category.all[0]
    @category.name = nil
    @category.should_not be_valid
    @category.name = ''
    @category.should_not be_valid
  end

  it 'should have unique name' do
    Category.create(name: "transport").should_not be_valid
  end

  after(:each) do
    @advert.destroy
    @user.destroy
    @user_role.destroy
  end

end