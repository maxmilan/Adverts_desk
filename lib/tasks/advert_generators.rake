namespace :advert_generators do
  desc 'Generate adverts'
  task :generate  => :environment do
    number = 3
    types = %w{sell buy exchange service loan}
    categories = Category.pluck(:name)
    users = User.where(role_id: Role.find_by_name('user').id)
    users.each do |u|
      number.times do
        u.adverts << Advert.create(title: Faker::Lorem.word,
                                   body: Faker::Lorem.paragraph(Random.new.rand(2..5)),
                                   category: Category.find_by(name: categories[Random.new.rand(0...categories.length)]),
                                   state: :new, advert_type: types[Random.new.rand(0...types.length)],
                                   price: Random.new.rand(50..1000) )
      end
      u.save
    end
  end

  desc 'Delete adverts'
  task delete: :environment do
    Advert.all.each do |advert|
      advert.destroy
    end
  end

  desc 'Update crontab'
  task update_crontab: :environment do
    system( 'whenever --update-crontab board' )
  end
end
