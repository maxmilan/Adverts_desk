require 'rails_helper'

RSpec.describe User, type: :model do
	let(:user){FactoryGirl.create(:user)}
	let(:user_role){FactoryGirl.create(:role)}
	let(:admin_role){FactoryGirl.create(:role, name: 'admin')}

  it 'should be valid' do
    user.should be_valid
  end

  it 'should have valid name' do
    user.name = nil
    user.should_not be_valid
    user.name = ''
    user.should_not be_valid
  end

  it 'should have valid surname' do
    user.surname = nil
    user.should_not be_valid
    user.surname = ''
    user.should_not be_valid
  end

  it 'should have unique email' do
    other_user = user.dup
	  expect(other_user).not_to be_valid
  end

	let(:incorrect_emails){%w{newjnfewfnjwefn feuwfn@ejfe enjfen@enf.}}
	let(:correct_emails){%w{wenfj@nwejf.ru EDJNDWEJND@efmekf.ru}}

  it 'should have correct email' do
	  incorrect_emails.each do |in_email|
		  user.email = in_email
		  expect(user).not_to be_valid
	  end
	  correct_emails.each do |cor_email|
		  user.email = cor_email
		  expect(user).to be_valid
	  end
  end

  it 'should know define user role' do
    expect(user.user?).to eq(true)
    expect(user.admin?).not_to eq(true)
    user.role = admin_role
    expect(user.user?).not_to eq(true)
    expect(user.admin?).to eq(true)
  end

end
