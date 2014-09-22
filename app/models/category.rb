class Category < ActiveRecord::Base
  has_many :adverts

  validates :name, uniqueness: true
  validates :name, presence: true
end
