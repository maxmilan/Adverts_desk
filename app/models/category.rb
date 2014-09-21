class Category < ActiveRecord::Base
  has_many :adverts

  validates :name, uniqueness: true
end
