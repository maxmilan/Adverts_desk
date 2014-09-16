class Advert < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
  validates :price, presence: true, numericality: {greater_than: 0 }
end
