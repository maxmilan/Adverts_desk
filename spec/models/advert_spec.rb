require 'rails_helper'

RSpec.describe Advert, type: :model do
  before(:each) do
	  @admin_role = Role.create(name: 'admin')
	  @user_role = Role.create(name: 'user')

    @admin = User.create(name: 'Admin', surname: 'Admin', email: 'admin@advert.com', password: '82368236')
    @admin.role_id = @admin_role.id
    @admin.save

    @user = User.create(name: Faker::Name.first_name, surname: Faker::Name.last_name,
                        email: Faker::Internet.email,
                        password: Faker::Internet.password)
    @user.role_id = @user_role.id

	  category_names = %w{transport realty}
	  types = %w{sell buy exchange service loan}

    category_names.each do |category|
      Category.create(name: category)
    end

    @advert = Advert.create(title: Faker::Lorem.word, body: Faker::Lorem.paragraph(Random.new.rand(2..5)),
                            category: Category.find_by(name: category_names[Random.new.rand(0...category_names.length)]),
                            state: :new, advert_type: types[Random.new.rand(0...types.length)],
                            price: Random.new.rand(50..1000) )

    @user.adverts << @advert
    @user.save
  end

  it 'should be valid' do
    @advert.should be_valid
  end

  it 'should delete advert' do
    @advert.destroy
    @user.adverts.include?(@advert).should_not == true
  end

  it 'should be invalid without title' do
    @advert.title = nil
    @advert.should_not be_valid
    @advert.title = ''
    @advert.should_not be_valid
  end

  it 'should be invalid without body' do
    @advert.body = nil
    @advert.should_not be_valid
    @advert.body = ''
    @advert.should_not be_valid
  end

  it 'should have category' do
    @advert.category = nil
    @advert.should_not be_valid
  end

  it 'should have normal price' do
    @advert.price = -1
    @advert.should_not be_valid
  end

  it 'should have correct type' do
    @advert.should be_valid
    @advert.advert_type = 'unknown'
    @advert.should_not be_valid
  end

  it 'should have state new' do
    @advert.new?.should == true
  end

  it 'should be waiting' do
    [:new, :archive].each do |state|
      @advert.state = state
      @advert.wait
      @advert.waiting?.should == true
    end
  end

  it 'should archivate each advert' do
    [:new, :waiting, :published, :rejected].each do |state|
      @advert.state = state
      @advert.send_to_archive
      @advert.archive?.should == true
    end
  end

  it 'should have rejected reason' do
    @advert.wait
    @advert.reject
    @advert.reject_reason = nil
    @advert.should_not be_valid
    @advert.reject_reason = ''
    @advert.should_not be_valid
  end

  it 'should accept waiting advert' do
    @advert.wait
    @advert.accept
    @advert.published?.should == true
  end

  it 'should reject waiting advert' do
    @advert.wait
    @advert.reject
    @advert.rejected?.should == true
  end

  after(:each) do
    @advert.destroy
    @user.destroy
    @admin.destroy
    @admin_role.destroy
    @user_role.destroy
  end

end