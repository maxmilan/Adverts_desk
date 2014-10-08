require 'rails_helper'

RSpec.describe User, :type => :model do
  before(:each) do
    Role.find_each do |role|
      role.destroy
    end
    @admin_role = Role.create(:name => "admin")
    @user_role = Role.create(:name => "user")

    @admin = User.create(name: 'Admin', surname: 'Admin', email: 'admin@advert.com', password: '82368236')
    @admin.role_id = @admin_role.id
    @admin.save

    @user = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: Faker::Internet.email,
                        password: Faker::Internet.password)

    @user.role_id = @user_role.id

    category_names = ['transport','realty']
    types = ['sell', 'buy', 'exchange', 'service', 'loan']

    category_names.each do |category|
      Category.create(name: category)
    end

    @advert = Advert.create(title: Faker::Lorem.word, body: Faker::Lorem.paragraph(Random.new.rand(2..5)), category: Category.find_by(name: category_names[Random.new.rand(0...category_names.length)]),
                            state: :new, advert_type: types[Random.new.rand(0...types.length)], price: Random.new.rand(50..1000) )

    @user.adverts << @advert
    @user.save
  end

  it 'should be valid' do
    @user.should be_valid
  end

  it 'should have valid name' do
    @user.name = nil
    @user.should_not be_valid
    @user.name = ''
    @user.should_not be_valid
  end

  it 'should have valid surname' do
    @user.surname = nil
    @user.should_not be_valid
    @user.surname = ''
    @user.should_not be_valid
  end

  it 'should have unique email' do
    User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name, email: @user.email,
                        password: Faker::Internet.password).should_not be_valid
  end

  it 'should have correct email' do
    @user.email = 'newjnfewfnjwefn'
    @user.should_not be_valid
    @user.email = 'feuwfn@ejfe'
    @user.should_not be_valid
    @user.email = 'enjfen@enf.'
    @user.should_not be_valid
    @user.email = 'wenfj@nwejf.ru'
    @user.should be_valid
  end

  it 'should destroy adverts when destroy user' do
    @user.destroy
    Advert.all.include?(@advert).should_not == true
  end

  it 'should know define user role' do
    @user.role_id = @user_role.id
    @user.user?.should == true
    @user.admin?.should_not == true
    @user.role_id = @admin_role.id
    @user.user?.should_not == true
    @user.admin?.should == true
  end

  after(:each) do
    @advert.destroy
    @user.destroy
    @admin.destroy
    @admin_role.destroy
    @user_role.destroy
  end
end