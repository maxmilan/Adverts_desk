require 'rails_helper'

describe 'adverts interface', type: :feature do
	before{sign_in(user)}
	let(:user){FactoryGirl.create(:user)}
	let(:admin_role){FactoryGirl.create(:role, name: 'admin')}
	let(:admin){FactoryGirl.create(:user, role: admin_role)}
	let(:advert){FactoryGirl.create(:advert, user: user)}

  def sign_in (user)
	  visit new_user_session_path
	  fill_in 'Email', with: user.email
	  fill_in 'Password', with: user.password
	  click_button 'Sign in'
	  expect(page).to have_content('Signed in successfully.')
  end

	describe 'Create Advert' do
		before{visit new_advert_path}

		it 'should not create invalid advert' do
			expect(page).to have_button('Create')
			click_button 'Create'
			expect(page).to have_content("can't be blank")
		end

		it 'should create valid advert' do
			fill_in 'Title', with: 'Title'
			fill_in 'Body', with: 'Text'
			fill_in 'Price', with: '23.05'
			click_button 'Create'
			expect(page).to have_content('Adverts')
		end
	end

	describe 'Adverts edit' do
		before do
			user.adverts << advert
			visit persons_profile_path
			expect(page).to have_content('Adverts')
			click_link advert.title
			expect(page).to have_content(advert.body)
			click_link 'Edit'
		end

		it 'should not edit advert' do
			expect(page).to have_button('Update')
			fill_in 'Body', with: ''
			click_button 'Update'
			expect(page).to have_content('can\'t be blank')
		end

		it 'should edit advert' do
			expect(page).to have_button('Update')
			fill_in 'Body', with: 'New advert body'
			click_button 'Update'
			expect(page).to have_content('Advert was successfully updated')
		end
	end

  it 'should change state' do
	  visit persons_profile_path
	  user.adverts << advert
	  expect(page).to have_content('Information')
  end

	describe 'Advert sorting and filtering' do
		before do
			Category.create(name: 'something')
			visit root_path
			advert.wait
			advert.accept
		end

		it 'should filter adverts' do
			expect(page).to have_content('Adverts')
			expect(page).to have_select('q[advert_type_eq]')
			expect(page).to have_select('q[category_name_eq]')
			select advert.advert_type, from: 'q[advert_type_eq]'
			select 'something', from: 'q[category_name_eq]'
			click_button 'Search'
			expect(page).to have_content('There are no adverts')
		end
	end

end
