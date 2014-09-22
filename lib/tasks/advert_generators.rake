namespace :advert_generators do
  desc "Generate adverts"
  task :generate_adverts  => :environment do
    number = 3
    states = [:new, :waiting, :rejected, :published, :archive]
    types = ['sell', 'buy', 'exchange', 'service', 'loan']
    categories = Category.all
    users = User.where(role_id: Role.find_by_name('user').id)
    users.each do |u|
      number.times do
        u.adverts.build(title: Faker::Lorem.word, body: Faker::Lorem.paragraph(Random.new.rand(2..5)), category: Category.find_by(name: categories[Random.new.rand(0...categories.length)]),
                           state: states[Random.new.rand(0...states.length)], type: types[Random.new.rand(0...types.length)], price: Random.new.rand(50..1000) ).save
      end
    end
  end
end