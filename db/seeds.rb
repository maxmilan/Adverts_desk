# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = Role.create(:name => "user")
user = Role.create(:name => "admin")

admin = User.create(name: 'Admin', surname: 'Admin', email: 'admin@advert.com', password: '82368236', role: admin)

category_names = ['transport','realty']

category_names.each do |category|
  Category.create(name: category)
end