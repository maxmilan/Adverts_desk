require 'rails_helper'

describe "adverts interface", :type => :feature do

  before :each do
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
    @user.adverts << @advert
    @user.adverts << @other_advert
    @user.save
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
    @user_role.destroy
    @admin_role.destroy
  end
end
