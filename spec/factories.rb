FactoryGirl.define do
	factory :role do
		name 'user'
	end

	factory :user do
		name  Faker::Name.first_name
		surname Faker::Name.last_name
		email Faker::Internet.email
		password Faker::Internet.password
		association :role, factory: :role
	end

	factory :category do
		name 'transport'
	end

	factory :advert do
		title Faker::Lorem.word
		body Faker::Lorem.paragraph(Random.new.rand(2..5))
		association :category, factory: :category
		state :new
		advert_type 'sell'
		price Random.new.rand(50..1000)
		association :user, factory: :user
	end
end