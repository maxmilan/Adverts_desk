require 'rails_helper'

describe "adverts interface", :type => :feature do

  before :each do
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

    @advert = Advert.create(title: Faker::Lorem.word, body: Faker::Lorem.paragraph(Random.new.rand(2..5)), category: Category.find_by(name: category_names[1]),
                            state: :published, advert_type: types[1], price: Random.new.rand(50..1000) )
    @other_advert = Advert.create(title: Faker::Lorem.word, body: Faker::Lorem.paragraph(Random.new.rand(2..5)), category: Category.find_by(name: category_names[1]),
                            state: :published, advert_type: types[2], price: Random.new.rand(50..1000) )
	  @third_advert = Advert.create(title: Faker::Lorem.word, body: Faker::Lorem.paragraph(Random.new.rand(2..5)), category: Category.find_by(name: category_names[1]),
	                                state: :new, advert_type: types[2], price: Random.new.rand(50..1000) )
    @user.adverts << @advert
    @user.adverts << @other_advert
	  @user.adverts << @third_advert
    @user.save
	  sign_in(@user)
  end

  def sign_in (user)
	  visit new_user_session_path
	  fill_in "Email", :with => @user.email
	  fill_in "Password", :with => @user.password
	  click_button "Sign in"
	  expect(page).to have_content('Signed in successfully.')
  end

  it 'should create advert' do
		visit new_advert_path
	  expect(page).to have_button('Create')
	  click_button 'Create'
	  expect(page).to have_content("can't be blank")
	  fill_in "Title", :with => "Title"
	  fill_in "Body", :with => "Text"
	  fill_in "Price", :with => "23.05"
	  click_button 'Create'
	  expect(page).to have_content('Advert was successfully created')
  end

  it 'should edit advert' do
	  visit persons_profile_path
	  expect(page).to have_content('Adverts')
	  click_link @user.adverts[0].title
	  expect(page).to have_content(@user.adverts[0].body)
	  click_link 'Edit'
	  fill_in "Body", :with => "New advert body"
	  click_button 'Update'
	  expect(page).to have_content("New advert body")
  end

  it 'should change state' do
	  visit persons_profile_path
	  expect(page).to have_content('Adverts')
	  expect(page).to have_link('Publicate')
  end

  it 'should filter adverts' do
    visit root_path
    expect(page).to have_content('Adverts')
    expect(page).to have_select('q[advert_type_eq]')
    expect(page).to have_select('q[category_name_eq]')
    select 'buy', from: 'q[advert_type_eq]'
    select 'realty', from: 'q[category_name_eq]'
    click_button 'Search'
    expect(page).to have_content(@advert.title)
    select 'sell', from: 'q[advert_type_eq]'
    select 'transport', from: 'q[category_name_eq]'
    click_button 'Search'
    expect(page).to have_content('There are no adverts')
  end

  it 'should sort adverts by date' do
    visit root_path
    expect(page).to have_content('Adverts')
    expect(page).to have_link('Sort by date')
  end

  after :each do
    @user.destroy
    @admin.destroy
  end
end