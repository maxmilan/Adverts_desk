admin = Role.create(name: 'admin')
user = Role.create(name: 'user')

@admin = User.create(name: 'Admin', surname: 'Admin', email: 'admin@advert.com', password: '82368236')
@admin.role_id = admin.id
@admin.save

category_names = %w{transport realty}

category_names.each do |category|
  Category.create(name: category)
end
